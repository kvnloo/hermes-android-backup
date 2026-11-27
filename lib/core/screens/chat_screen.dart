// Chat screen with real-time streaming via REST API.
// Uses REST endpoints: POST /api/sessions/{id}/chat and
// GET /api/sessions/{id}/messages.
import 'dart:async';
import '../widgets/chat_presence.dart';
import '../workspace/terminal_chat_link.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import '../parked_automotive.dart';
import '../widgets/session_name_dialog.dart';
import '../widgets/rewind_dialogs.dart';
import '../history/canonical_rewind.dart'
    show rewindFencesUnknownReason, rewindTargetUnsavedReason;
import '../history/rewind_submit.dart'
    show RewindHistory, RewindPlan, buildRewindParams;
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../presentation/companion_draft.dart';
import '../presentation/petdex.dart';
import '../presentation/presentation_chrome.dart';
import '../presentation/radio.dart' show showAresRadioSheet;
import '../presentation/transcript_reading.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:uuid/uuid.dart';
import '../controllers/hands_free_conversation_controller.dart';
import '../services/auto_speak_replies.dart';
import '../services/barge_in_monitor.dart';
import '../services/barge_in_preference.dart';
import '../services/hermes_deeplink.dart' show appendComposerPrefill;
import '../services/hands_free_preference.dart';
import '../services/hands_free_voice_platform.dart';
import '../services/android_voice_composer_adapter.dart';
import '../services/hands_free_speech.dart';
import '../services/hands_free_route_observer.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/client_direct_voice.dart';
import '../services/client_direct_voice_speaker.dart';
import '../services/gateway_wake_word.dart';
import '../services/gpt_live_conversation.dart';
import '../services/voice_live_engine.dart';
import '../services/voice_live_mode.dart';
import '../services/wake_voice_request.dart';
import '../utils/voice_stop_word.dart';
import '../widgets/barge_in_indicator.dart';
import '../widgets/gateway_wake_controls.dart';
import '../widgets/voice_live_controls.dart';
import '../widgets/hands_free_voice_controls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/slash_command_controller.dart';
import '../controllers/voice_composer_controller.dart';
import '../controllers/voice_recording_controller.dart';
import '../services/local_voice_recorder.dart';
import '../services/voice_transcription.dart';
import '../widgets/voice_recording_controls.dart';
import '../controllers/delegated_task_controller.dart';
import '../services/delegated_task_history.dart';
import '../widgets/delegated_task_timeline.dart';
import '../widgets/delegated_task_labels.dart';
import '../services/connection_manager.dart';
import '../services/attachment_draft_service.dart';
import '../services/client_held_queue.dart';
import '../services/composer_draft_store.dart';
import '../services/prepared_image_store.dart';
import '../widgets/client_held_queue_bar.dart';
import '../widgets/image_recovery_capability_notice.dart';
import '../widgets/prepared_image_recovery.dart';
import '../services/chat_presentation_state.dart';
import '../services/chat_kanban_dock.dart';
import '../widgets/kanban_dock.dart';
import '../services/chat_model_override_store.dart';
import '../services/chat_density_preference.dart';
import '../services/chat_history_window.dart';
import '../services/desktop_gateway_client.dart';
import '../services/composer_session_rpc.dart';
import '../services/remote_workspace.dart';
import '../services/gateway_turn_application_controller.dart';
import '../services/normal_gateway_application_session.dart';
import '../services/gateway_turn_coordinator.dart';
import '../services/gateway_turn_recovery.dart';
import '../services/gateway_turn_ui_projection.dart';
import '../services/remote_files_client.dart';
import '../preview/chat_preview.dart';
import 'kanban_board_screen.dart';
import 'bots_screen.dart';
import '../render/render_scope.dart';
import '../capabilities/capability_admin.dart';
import '../render/catalog_install.dart';
import '../render/rich_transcript.dart';
import '../render/setup_beat.dart';
import '../services/slash_command_errors.dart';
import '../services/legal_links.dart';
import '../services/turn_notification_service.dart';
import '../services/completion_cue_player.dart';
import '../services/notification_approval_authority.dart';
import '../services/notification_prefs.dart';
import '../services/voice_composer_adapter.dart';
import '../services/ws_client.dart';
import '../utils/media_tags.dart';
import '../utils/session_sources.dart';
import '../utils/large_paste.dart';
import '../utils/delivered_files.dart';
import '../utils/generated_media.dart';
import '../models/attachment_draft.dart';
import '../models/background_report.dart';
import '../models/chat_timeline.dart';
import '../models/received_scope_outcome.dart';
import '../models/gateway_activity.dart';
import '../models/gateway_approval.dart';
import '../models/gateway_clarify.dart';
import '../models/gateway_insight.dart';
import '../models/gateway_sensitive_prompt.dart';
import '../models/gateway_turn_contract.dart';
import '../models/projects_tree_overview.dart';
import '../models/slash_command.dart';
import '../services/tool_activity_group_pins.dart';
import '../utils/chat_display_items.dart';
import '../utils/chat_received_recovery_projection.dart';
import '../utils/chat_conversation_projection.dart';
import '../models/chat_message_time.dart';
import '../utils/rest_chat_reply_retention.dart';
import '../utils/android_prompt_context.dart';
import '../utils/chat_history_scroll.dart';
import '../widgets/transcript_reader.dart';
import '../widgets/transcript_body.dart';
import '../utils/message_content.dart';
import '../utils/turn_recovery_fallback.dart';
import '../theme/hermes_theme.dart';
import 'files_screen.dart';
import '../widgets/session_files_view.dart';
import '../widgets/session_history_page.dart';
import 'workspace_workers_screen.dart';
import 'gateway_queue_screen.dart';
import '../widgets/git_review_pane.dart';
import '../models/turn_changed_files.dart';
import '../widgets/background_report_card.dart';
import '../widgets/gateway_activity_card.dart';
import '../widgets/chat_context_header.dart';
import '../widgets/keyboard_room.dart';
import '../widgets/chat_activity_bar.dart';
import '../widgets/markdown_code_block.dart';
import '../widgets/markdown_link_handler.dart';
import '../widgets/attachment_draft_tile.dart';
import '../utils/audio_file_references.dart';
import '../widgets/chat_end_affordance.dart';
import '../widgets/received_recovery_inspector.dart';
import '../widgets/gateway_approval_dialog.dart';
import '../widgets/gateway_clarify_dialog.dart';
import '../widgets/gateway_insight_card.dart';
import '../widgets/gateway_sensitive_prompt_dialog.dart';
import '../widgets/hermes_components.dart';
import '../widgets/media_artifact_card.dart';
import '../widgets/slash_command_dropdown.dart';
import '../widgets/slash_command_highlight.dart';
import '../widgets/slash_command_notice_card.dart';
import '../widgets/voice_composer_controls.dart';

import 'package:hermes_android/core/l10n/l10n.dart';
import '../l10n/service_strings.dart';
import '../l10n/ui_message_exception.dart';
import '../widgets/desktop_shortcuts.dart';
import '../widgets/composer_prompt_recall.dart';
import '../composer/composer_commands.dart';
import '../composer/failure_recovery.dart';
import '../composer/regenerate.dart';
import '../composer/composer_drag.dart';
import '../composer/composer_intake.dart';
import '../composer/os_intake.dart';
import '../widgets/composer_drop_surface.dart';
import '../composer/context_status.dart';
import '../composer/reference_completion.dart';
import '../widgets/composer_context_status.dart';
import '../widgets/composer_reference_assist.dart';
import '../widgets/failure_recovery_card.dart';
import '../widgets/prompt_snippet_sheet.dart';
import '../widgets/resume_session_picker.dart';
import '../widgets/orphan_draft_recovery.dart';
import '../desktop/screen_capture.dart';

/// Recovery v2 opens a new server session and cannot yet target an existing
/// Gateway session. Keep it confined to locally-created drafts; a session from
/// `GET /sessions` must submit through the legacy transport that accepts its
/// exact session id. A Project draft also uses legacy until `session.open`
/// supports `cwd`, since stock Hermes files it by the creation cwd.
@visibleForTesting
bool shouldUseRecoveryV2ForSession(
  Session session, {
  String? projectWorkingDirectory,
}) =>
    session.isLocalDraft &&
    (projectWorkingDirectory?.trim().isNotEmpty != true);

/// Avoid opening the same local draft once through the legacy client's
/// `session.create` path and again through recovery v2's `session.open` path.
/// If recovery v2 is explicitly unsupported, the local draft may safely fall
/// back to the legacy transport and establish its first server session there.
@visibleForTesting
bool shouldEstablishLegacyDesktopSession(
  Session session, {
  required bool legacyTransportFallback,
}) => !session.isLocalDraft || legacyTransportFallback;

/// Whether a send refusal deserves the additive API-only access note.
///
/// True only when [connection] carries no Dashboard credentials and no
/// explicit Desktop Gateway origin, so the send could only have been made as
/// the API-server key principal, and the refusal is an access-control denial.
/// This mirrors the attach gate's own condition and never alters it: the note
/// is extra context appended to the server's own words, not a replacement, a
/// retry, or a principal switch. An ACL denial can equally be deliberate
/// server policy, so the wording it selects stays conditional.
@visibleForTesting
bool shouldExplainApiOnlyPermissionDenial(
  SavedConnection connection,
  String error,
) {
  final hasDashboardAuth = connection.hasDashboardAuth;
  if (hasDashboardAuth) return false;
  if (connection.desktopGatewayUrl?.trim().isNotEmpty == true) return false;
  return error.toLowerCase().contains('permission_denied');
}

/// Route identity and resource ownership around one physical history flight.
/// Offset paging captures a fence without allocating latest-read authority.
class _ChatHistoryRead {
  const _ChatHistoryRead({
    required this.owner,
    required this.account,
    required this.localSessionId,
    required this.authority,
    required this.sessionId,
    required this.routeSessionId,
    required this.responseGeneration,
    required this.observation,
    required this.windowRevision,
  });
  final NormalGatewayChatOwner? owner;
  final Object account;
  final String localSessionId;
  final NormalGatewayHistoryRead? authority;
  final String sessionId;
  final String routeSessionId;
  final int responseGeneration;
  final int observation;
  final int windowRevision;
}

class _ModelChoice {
  final String provider;
  final String model;

  const _ModelChoice({required this.provider, required this.model});
}

class _ChatModelPickerSheet extends StatefulWidget {
  const _ChatModelPickerSheet({
    required this.choices,
    required this.modelInfo,
    required this.initialChoice,
    required this.initialEffort,
    required this.providerChoiceRequired,
  });

  final List<_ModelChoice> choices;
  final Map<String, dynamic> modelInfo;
  final _ModelChoice? initialChoice;
  final String initialEffort;
  final bool providerChoiceRequired;

  @override
  State<_ChatModelPickerSheet> createState() => _ChatModelPickerSheetState();
}

class _ChatModelPickerSheetState extends State<_ChatModelPickerSheet> {
  final _searchController = TextEditingController();
  late _ModelChoice? _selectedChoice = widget.initialChoice;
  late String _selectedEffort = widget.initialEffort;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final visibleChoices = widget.choices
        .where(
          (choice) =>
              choice.model.toLowerCase().contains(query) ||
              choice.provider.toLowerCase().contains(query),
        )
        .toList(growable: false);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 640),
          child: Column(
            children: [
              // Let the header and search scroll too: on a compact phone or
              // at large text sizes the keyboard can leave very little room.
              Expanded(
                child: CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.tune),
                            title: Text(
                              context.l10n.model_and_thinking_for_this_chat,
                            ),
                            subtitle: Text(
                              widget.modelInfo['provider'] == null
                                  ? context.sharedL10n
                                        .release_chat_profile_default(
                                          (widget.modelInfo['model'] ??
                                                  context
                                                      .sharedL10n
                                                      .release_chat_unknown_model)
                                              .toString(),
                                        )
                                  : context.sharedL10n
                                        .release_chat_profile_default_provider(
                                          (widget.modelInfo['model'] ??
                                                  context
                                                      .sharedL10n
                                                      .release_chat_unknown_model)
                                              .toString(),
                                          widget.modelInfo['provider']
                                              .toString(),
                                        ),
                            ),
                          ),
                          if (widget.providerChoiceRequired)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              child: Text(
                                context.sharedL10n.release_chat_choose_provider,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: context.l10n.thinking_effort,
                                border: const OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _selectedEffort,
                                  items: _reasoningEffortOptions
                                      .map(
                                        (effort) => DropdownMenuItem(
                                          value: effort,
                                          child: Text(
                                            _reasoningEffortLabel(
                                              context,
                                              effort,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(growable: false),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() => _selectedEffort = value);
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: TextField(
                              key: const Key('chat-model-search'),
                              controller: _searchController,
                              decoration: InputDecoration(
                                labelText: context.l10n.search,
                                prefixIcon: const Icon(Icons.search),
                                border: const OutlineInputBorder(),
                                suffixIcon: _searchController.text.isEmpty
                                    ? null
                                    : IconButton(
                                        tooltip: context.l10n.clear_search,
                                        icon: const Icon(Icons.clear),
                                        onPressed: () =>
                                            setState(_searchController.clear),
                                      ),
                              ),
                              autocorrect: false,
                              enableSuggestions: false,
                              textInputAction: TextInputAction.search,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const Divider(height: 1),
                        ],
                      ),
                    ),
                    if (visibleChoices.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            context.l10n.no_matches,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      SliverList.builder(
                        itemCount: visibleChoices.length,
                        itemBuilder: (context, index) {
                          final choice = visibleChoices[index];
                          final selected =
                              choice.model == _selectedChoice?.model &&
                              choice.provider == _selectedChoice?.provider;
                          return ListTile(
                            leading: Icon(
                              selected
                                  ? Icons.check_circle
                                  : Icons.smart_toy_outlined,
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                            title: Text(choice.model),
                            subtitle: Text(choice.provider),
                            onTap: () =>
                                setState(() => _selectedChoice = choice),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: OverflowBar(
                  alignment: MainAxisAlignment.end,
                  overflowAlignment: OverflowBarAlignment.end,
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.l10n.cancel),
                    ),
                    FilledButton(
                      onPressed: _selectedChoice == null
                          ? null
                          : () => Navigator.pop(
                              context,
                              _ModelSelection(
                                choice: _selectedChoice!,
                                reasoningEffort: _selectedEffort,
                              ),
                            ),
                      child: Text(context.l10n.apply_to_this_chat),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModelSelection {
  final _ModelChoice choice;

  /// Null keeps the chat's current reasoning effort (a suggested model
  /// from the failure card switches the model only).
  final String? reasoningEffort;

  const _ModelSelection({required this.choice, required this.reasoningEffort});
}

const _reasoningEffortOptions = <String>[
  'none',
  'minimal',
  'low',
  'medium',
  'high',
  'xhigh',
  'max',
  'ultra',
];

String _reasoningEffortLabel(BuildContext context, String effort) {
  return switch (effort) {
    'none' => context.l10n.off_no_thinking,
    'minimal' => context.l10n.reasoning_minimal,
    'low' => context.l10n.reasoning_low,
    'medium' => context.l10n.reasoning_medium,
    'high' => context.l10n.reasoning_high,
    'xhigh' => context.l10n.extra_high,
    'max' => context.l10n.reasoning_max,
    'ultra' => context.l10n.reasoning_ultra,
    _ => effort,
  };
}

enum _ResponseTransport { none, rest, desktop }

@visibleForTesting
typedef TestRemotePromptSubmit =
    Future<void> Function({
      required String sessionId,
      required String text,
      required StreamCallback onEvent,
      required void Function() onSent,
    });

@visibleForTesting
typedef TestRemoteAttachmentUpload =
    Future<AttachmentUploadReceipt> Function({
      required AttachmentDraft draft,
      required String dataUrl,
    });

/// Loads the gateway's authoritative chat-to-Project placement in tests.
@visibleForTesting
typedef TestProjectOverviewLoader = Future<ProjectsTreeOverview> Function();

/// The result of looking up a chat in an authoritative Projects tree.
///
/// [known] distinguishes a chat explicitly filed under Home (known, with no
/// Project name) from a chat absent from a response that may have raced its
/// first server-side persistence (unknown). The latter must not erase a valid
/// navigation-time Project label.
@visibleForTesting
class ChatProjectHeaderResolution {
  final bool known;
  final String? projectName;

  const ChatProjectHeaderResolution._({
    required this.known,
    required this.projectName,
  });

  static const unknown = ChatProjectHeaderResolution._(
    known: false,
    projectName: null,
  );

  const ChatProjectHeaderResolution.known(this.projectName) : known = true;
}

/// Resolves the first canonical session id present in [overview].
///
/// Callers pass the gateway's stored id before any draft/mobile id. This makes
/// the durable record authoritative after `session.open` reconciliation while
/// still supporting existing sessions whose app id is already the stored id.
@visibleForTesting
ChatProjectHeaderResolution resolveChatProjectHeader(
  ProjectsTreeOverview overview,
  Iterable<String> sessionIds,
) {
  for (final rawId in sessionIds) {
    final id = rawId.trim();
    if (id.isEmpty) continue;
    final ownerId = overview.sessionProjects[id];
    if (ownerId == null) continue;
    if (ownerId == ProjectsTreeOverview.noProjectId) {
      return const ChatProjectHeaderResolution.known(null);
    }
    return ChatProjectHeaderResolution.known(overview.ownerLabelOf(id));
  }
  return ChatProjectHeaderResolution.unknown;
}

@visibleForTesting
typedef TestComposerDraftReader =
    Future<String?> Function({
      required String connectionId,
      required String sessionId,
    });

/// Mutable holder that lets a test reach the ChatScreen's Desktop
/// connection-state handler when no real gateway is configured. The screen
/// fills [handler] in `initState`; the test then calls it with the state
/// transitions a reconnecting `DesktopGatewayClient` would emit.
@visibleForTesting
class TestDesktopConnectionHook {
  void Function(DesktopConnectionState state)? handler;
  DesktopConnectionState currentState = DesktopConnectionState.disconnected;
}

/// Test seam for session-scoped terminal events that arrive after the
/// prompt.submit listener was detached by a socket close.
@visibleForTesting
class TestDesktopAsyncEventHook {
  void Function(StreamEvent event)? handler;
}

class _PendingSensitivePrompt {
  final GatewaySensitivePromptRequest request;
  final int responseGeneration;

  const _PendingSensitivePrompt(this.request, this.responseGeneration);
}

class _PendingClarifyPrompt {
  final GatewayClarifyRequest request;
  final int responseGeneration;

  const _PendingClarifyPrompt(this.request, this.responseGeneration);
}

/// A pushed chat route whose `/resume` opens the pick in this route's place,
/// for a host with no session list of its own (a cron run, a notification,
/// a pop-out window). The routes under it, the host shell among them, stay.
/// [build] makes the chat for a session and must pass it [onOpenSession];
/// [onReplaced] sees each route that takes a previous one's place, with the
/// future that completes when it closes (a host tracking its routes keeps
/// it).
MaterialPageRoute<void> resumableChatRoute(
  Session session,
  Widget Function(
    Session session,
    Future<void> Function(Session picked) onOpenSession,
  )
  build, {
  void Function(
    MaterialPageRoute<void> route,
    Session session,
    Future<void> closed,
  )?
  onReplaced,
}) {
  late final MaterialPageRoute<void> route;
  route = MaterialPageRoute<void>(
    builder: (_) => build(session, (picked) async {
      final navigator = route.navigator;
      if (navigator == null || !route.isActive) return;
      final next = resumableChatRoute(picked, build, onReplaced: onReplaced);
      final Future<void> closed;
      if (route.isCurrent) {
        closed = navigator.pushReplacement<void, void>(next);
      } else {
        navigator.removeRoute(route);
        closed = navigator.push<void>(next);
      }
      onReplaced?.call(next, picked, closed);
    }),
  );
  return route;
}

class ChatScreen extends StatefulWidget {
  final SavedConnection connection;
  final Session session;

  /// Publishes a server-confirmed stored-session change to the owning list.
  final Future<void> Function(String sessionId, bool archived)?
  onArchiveChanged;

  /// Lets a longer-lived list own PATCH, read-back and reconciliation even
  /// when this route is popped before the request completes.
  final Future<bool> Function(String sessionId, bool archived)? sessionArchiver;

  /// The server-owned Project this chat was opened from, when known.
  /// `null` stays explicit as Unassigned in the sticky context header.
  final String? projectName;

  /// The owning Project's working directory on the gateway host. Forwarded as
  /// `cwd` when this chat's session is created, so a Project chat runs inside
  /// the project folder — stock Hermes derives project membership from the
  /// session cwd (`project_for_path`), so the cwd is the filing.
  final String? projectWorkingDirectory;

  /// Optional text supplied by Android's share sheet. It only prefills the
  /// composer; sending remains an explicit user action.
  final String? initialComposerText;

  /// When true, [initialComposerText] (a `hermes://` link's prefill) is
  /// appended to the chat's unsent draft instead of replacing it.
  final bool initialComposerAppends;

  /// Mounted chats by connection and session (the latest mount wins), so a
  /// deep-link prefill for a chat that is already open goes into its live
  /// composer rather than a second copy of the chat.
  static final Map<String, _ChatScreenState> _mounted = {};

  static String _mountKey(String connectionId, String sessionId) =>
      '$connectionId\u0000$sessionId';

  /// Appends [text] to the composer of the open chat [sessionId] on
  /// [connectionId], after its unsent draft, and returns that chat's route
  /// so the caller can bring it forward. Null when the chat is not open.
  /// Nothing is sent.
  static ModalRoute<Object?>? appendToOpenChat({
    required String connectionId,
    required String sessionId,
    required String text,
  }) {
    final state = _mounted[_mountKey(connectionId, sessionId)];
    if (state == null || !state.mounted) return null;
    unawaited(state._appendLinkPrefill(text));
    return ModalRoute.of(state.context);
  }

  /// Validated app-private files supplied by Android's share sheet.
  final List<AttachmentDraft> initialAttachmentDrafts;

  final GatewayTurnApplicationController? turnApplicationController;

  @visibleForTesting
  final GatewayTurnApplicationSession? testTurnApplicationSession;

  @visibleForTesting
  final ApiClient? testApiClient;

  @visibleForTesting
  final AttachmentDraftService? testAttachmentDraftService;

  /// Desktop screen capture; tests pass a fake-channel controller.
  final ScreenCaptureController? screenCapture;

  @visibleForTesting
  final TestRemotePromptSubmit? testRemotePromptSubmit;

  @visibleForTesting
  final NormalGatewayResume? testNormalResume;

  @visibleForTesting
  final Future<String?> Function()? testServerFilePicker;

  @visibleForTesting
  final TestRemoteAttachmentUpload? testRemoteAttachmentUpload;

  @visibleForTesting
  final List<AttachmentDraft> testInitialAttachmentDrafts;

  @visibleForTesting
  final TestComposerDraftReader? testComposerDraftReader;

  @visibleForTesting
  final VoiceComposerAdapter? testVoiceComposerAdapter;

  @visibleForTesting
  final VoiceRecorder? testVoiceRecorder;
  @visibleForTesting
  final Future<String> Function(String)? testVoiceTranscription;

  final HandsFreeVoicePlatform? testHandsFreePlatform;
  @visibleForTesting
  final VoiceReplySpeaker? testVoiceReplySpeaker;

  /// Supplies the read-aloud barge-in monitor (production listens through
  /// the platform's dictation path).
  @visibleForTesting
  final BargeInMonitor Function()? testBargeInMonitor;

  /// Retained/offstage destinations must explicitly relinquish voice authority.
  final bool active;

  /// A dedicated stored-chat window must not open a second chat via /new.
  final bool singleSession;

  /// An isolated pop-out supplies a silent service. Regular embedded chat
  /// panes continue using the main application's notification owner.
  final TurnNotificationService? notifications;

  /// When set, the chat is embedded in a wider list+detail pane rather than
  /// pushed as a route: the AppBar shows a close affordance that calls this
  /// instead of popping the enclosing route. Null keeps the normal pushed
  /// full-screen behaviour (back button pops the route).
  final VoidCallback? onClose;

  /// Opens the app-wide command palette owned by the enclosing workspace.
  final VoidCallback? onOpenAppCommandPalette;

  /// Lets a test observe what the chat posts to Android when a turn settles,
  /// without touching the notification platform channel.
  @visibleForTesting
  final TurnNotificationService? testTurnNotifications;

  /// Passed by tests when no real Desktop gateway is configured: the
  /// screen attaches its connection-state handler to this hook in
  /// `initState`, so a test can drive drop-during-turn → reconnect →
  /// resync transitions without a live socket.
  @visibleForTesting
  final TestDesktopConnectionHook? testDesktopConnectionHook;

  /// Route disposal leaves the screen-owned gateway socket open. Tests that
  /// bind a preview use this to close that socket and its heartbeat.
  @visibleForTesting
  final void Function(DesktopGatewayClient gateway)? testDesktopGateway;

  @visibleForTesting
  final TestDesktopAsyncEventHook? testDesktopAsyncEventHook;

  /// Supplies an authoritative Projects tree without a real gateway.
  @visibleForTesting
  final TestProjectOverviewLoader? testProjectOverviewLoader;

  /// Invoked on every `_ensureDesktopSession()` call so a test can assert
  /// the reattach resync actually re-bound the session.
  @visibleForTesting
  final VoidCallback? testDesktopSessionEnsured;

  /// Observes the project-cwd binding before a legacy draft's first prompt.
  @visibleForTesting
  final Future<void> Function(String sessionId, String cwd)?
  testLegacyProjectSessionEnsure;

  /// Test seam mirroring `DesktopGatewayClient.storedSessionKeyFor`: maps
  /// the mobile session id to the gateway's stored DB key so a test can
  /// assert the reattach history refetch targets the stored identity.
  @visibleForTesting
  final String? Function(String mobileSessionId)? testStoredSessionKey;

  /// Lets widget tests observe the exact stored-session scope bound to an
  /// artifact tap without opening a real dashboard connection.
  @visibleForTesting
  final RemoteFilesDataSource Function(String storedSessionId)?
  testMediaFilesClient;

  @visibleForTesting
  final TaskHistorySource Function()? testTaskHistorySource;

  /// Supplies the slash-command RPC surface without a live Desktop socket, so
  /// tests can exercise catalogue parsing, execution and delivery uncertainty.
  @visibleForTesting
  final SlashCommandGateway? testSlashGateway;

  /// Test seam for the Kanban dock: a fake board transport and gateway owner.
  final TestChatKanban? testKanban;
  @visibleForTesting
  final VoiceLiveModeController? testVoiceLiveMode;

  @visibleForTesting
  final VoiceLiveEngine Function(GptLiveTransport transport)?
  testVoiceLiveEngineFactory;

  /// Overrides the Desktop gateway's wake-word controller.
  @visibleForTesting
  final GatewayWakeWordController? testWakeController;

  /// Supplies the saved connections a wake phrase of another profile is
  /// routed among, without reading secure storage.
  @visibleForTesting
  final Future<List<SavedConnection>> Function()? testSavedConnections;

  /// The composer's gateway calls (completion, context breakdown, compress)
  /// without a socket. Production uses the Desktop gateway client.
  final ComposerSessionRpc? testComposerRpc;

  const ChatScreen({
    required this.connection,
    required this.session,
    this.projectName,
    this.projectWorkingDirectory,
    this.initialComposerText,
    this.initialComposerAppends = false,
    this.initialAttachmentDrafts = const [],
    this.turnApplicationController,
    this.testTurnApplicationSession,
    this.testApiClient,
    this.testAttachmentDraftService,
    this.testRemotePromptSubmit,
    this.testNormalResume,
    this.testKanban,
    this.testServerFilePicker,
    this.screenCapture,
    this.testRemoteAttachmentUpload,
    this.testInitialAttachmentDrafts = const [],
    this.testComposerDraftReader,
    this.testVoiceComposerAdapter,
    this.testVoiceRecorder,
    this.testVoiceTranscription,
    this.testHandsFreePlatform,
    this.testVoiceReplySpeaker,
    this.testBargeInMonitor,
    this.active = true,
    this.singleSession = false,
    this.notifications,
    this.onClose,
    this.onOpenAppCommandPalette,
    this.testTurnNotifications,
    this.testDesktopConnectionHook,
    this.testDesktopGateway,
    this.testDesktopAsyncEventHook,
    this.testProjectOverviewLoader,
    this.testDesktopSessionEnsured,
    this.testLegacyProjectSessionEnsure,
    this.testStoredSessionKey,
    this.testMediaFilesClient,
    this.testTaskHistorySource,
    this.testSlashGateway,
    this.testVoiceLiveMode,
    this.testVoiceLiveEngineFactory,
    this.testWakeController,
    this.testSavedConnections,
    this.testComposerRpc,
    this.onArchiveChanged,
    this.sessionArchiver,
    this.onOpenSession,
    super.key,
  });

  /// The host's own way of opening a chat (the one its session list uses),
  /// for `/resume`: it keeps the host, its turn controller, project context,
  /// archive callbacks and notifications. A parallel pane opens the pick as
  /// another pane; a cron run, a notification or a pop-out opens it in the
  /// chat route's place ([resumableChatRoute]). Null only where a host has
  /// no path at all: `/resume` then says so and keeps the line, and never
  /// replaces the route itself.
  final Future<void> Function(Session session)? onOpenSession;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _HandsFreeTurnBinding {
  _HandsFreeTurnBinding(this.prompt) : clientTurnId = const Uuid().v4();
  final HandsFreePrompt prompt;
  String clientTurnId;
  String? transportTurnId;
  int? responseGeneration;
  final admitted = Completer<bool>();
  final terminal = Completer<HandsFreeTurnOutcome>();
  void finish(HandsFreeTurnStatus status, [String? text]) {
    if (!terminal.isCompleted) {
      terminal.complete(
        HandsFreeTurnOutcome(
          clientTurnId: clientTurnId,
          status: status,
          publicFinalText: text,
        ),
      );
    }
  }
}

class _ChatScreenState extends State<ChatScreen>
    with WidgetsBindingObserver, TerminalComposerAttachment<ChatScreen> {
  @override
  SavedConnection get terminalConnection => widget.connection;
  @override
  String get terminalSession => widget.session.id;
  @override
  RemoteWorkspaceOwner? get terminalOwner => _desktopGateway?.workspace;
  @override
  TextEditingController get terminalComposer => _textController;
  List<Map<String, dynamic>> _messages = [];
  ChatTimeline _timeline = const ChatTimeline();
  RestChatReplyRetention? _restReplyRetention;
  bool _hasSuccessfulHistoryRead = false;
  late final ChatPresentationRegistry _presentationRegistry;
  late final ChatPresentationState _presentation;
  late final ComposerDraftWriter _draftWriter;
  late final GatewayTurnApplicationController _viewController;
  late final SlashCommandController _slashController;
  String _lastComposerText = '';
  bool _restoringComposer = false;
  // Keep manual expansion through streaming rebuilds/lazy-list eviction, but
  // only for this route's visit. Leaving/reopening must start collapsed again.
  late ChatPresentationRegistry _reasoningRegistry;
  late ChatPresentationState _reasoningPresentation;
  late ToolActivityGroupPins _reasoningExpansionPins;
  // Bounded, visit-local choices only; no bodies or cross-source correlation.
  Map<Object, bool> _backgroundReportExpansions = {};
  Map<Object, bool> _detailExpansions = {};
  bool? _delegationExpanded;
  final ChatHistoryWindow _historyWindow = ChatHistoryWindow();
  bool _loadingOlder = false;
  int _historyReadIssued = 0;
  int _historyReadAccepted = 0;
  int _historyWindowRevision = 0;
  _ChatHistoryRead? _loadingHistoryRead;
  _ChatHistoryRead? _olderHistoryRead;
  _ChatHistoryRead? _deferredHistoryRead;
  final List<GatewayToolActivity> _toolActivities = [];

  /// Expansion choices for tool-activity cards, keyed by group id so they
  /// survive reordering/eviction within this State's visit, never a real exit.
  late final ToolActivityGroupPins _toolActivityPins;
  final List<GatewaySubagentActivity> _subagentActivities = [];
  DelegatedTaskController? _openTaskController;
  int _automaticScrollGeneration = 0;
  final Map<String, GatewayNotification> _gatewayNotifications = {};
  final Map<String, Timer> _notificationTimers = {};
  late final List<GatewayNotice> _gatewayNotices;
  final List<SlashCommandNotice> _slashNotices = [];
  static final Map<String, List<SlashCommandNotice>> _savedSlashNotices = {};
  bool _loading = true;
  late String _sessionTitle;
  bool _renaming = false;
  late bool _sessionArchived;
  bool _archiving = false;
  int _archiveRevision = 0;
  int _archiveReadGeneration = 0;
  String? _archiveStateSessionId;
  String? _archiveReadSessionId;
  String? _error;
  late final ApiClient _client;
  late final GatewayChatClient _gateway;
  late final AttachmentDraftService _attachmentDraftService;
  late final AttachmentDraftSendCoordinator _attachmentSendCoordinator;
  late final Future<ChatModelOverrideStore> _chatModelStore;
  late final Future<void> _sessionModelRestore;
  DesktopGatewayClient? _desktopGateway;
  // Voice is optional: a client that serves none (closed, or a stand-in
  // relaying turns only) leaves wake not offered and live voice unbound.
  GatewayWakeWordController? get _wake =>
      widget.testWakeController ?? _desktopGateway?.servedWakeWord;
  VoiceLiveModeController? get _voiceLiveMode =>
      widget.testVoiceLiveMode ?? _desktopGateway?.servedVoiceLiveMode;
  VoiceLiveEngine? _liveEngine;
  GptLiveTransport? _liveTransport;
  String? _liveDelegationId;
  String? _liveDelegatedTurnId;
  bool _liveTurnObserved = false;

  /// Counts live-voice teardowns, so a start that was cancelled by one is
  /// told apart from a start the host refused.
  int _liveTeardowns = 0;
  GatewayTurnApplicationController? _localTurnController;
  NormalGatewayApplicationSession? _normalSession;
  bool _normalSessionReady = false;
  NormalGatewayChatOwner? _normalChat;
  NormalGatewayChatSnapshot? _normalSnapshot;
  // Presentation only: no saved/received correspondence or owner retirement.
  final Set<String> _retainedRecoveryOutcomeIds = {};
  final Set<String> _historyObservedRecoveryOutcomeIds = {};
  bool _receivedRecoverySheetOpen = false;
  late final Map<String, String> _notificationApprovalOrigin;
  Object? _normalSubscription;
  Object? _normalReservation;
  String? _normalTurnId;
  String? _hiddenActivityTurnId;
  final Set<String> _normalInputSeen = {};
  final Set<String> _normalMaterializedIds = {};
  final Set<StreamEvent> _normalAuxiliarySeen = {};
  final Set<StreamEvent> _normalInputUpdatesSeen = {};
  final Set<String> _normalPendingRequestIds = {};
  final Map<String, String> _normalPendingRequestMethods = {};
  GatewayTurnApplicationSession? _turnApplicationSession;
  Object? _turnApplicationAsyncEventRegistration;
  Object? _turnApplicationSettledRegistration;
  Object? _turnApplicationBoundRegistration;
  DesktopConnectionState _desktopConnectionState =
      DesktopConnectionState.disconnected;
  bool _appInBackground = false;

  // Chat sending state
  final _textController = SlashCommandHighlightController();
  int _composerRevision = 0;
  int _clearedComposerRevision = 0;
  bool _preparingPaste = false;
  bool _startingVoiceInput = false;
  late final LargePasteFormatter _largePasteFormatter;
  final Map<String, String> _pastedDraftTexts = {};

  final _imagePicker = ImagePicker();
  final List<AttachmentDraft> _attachmentDrafts = [];

  /// Every draft intake (drops, pastes, keyboard images, the pickers and
  /// files-panel drags) checks the free slots and prepares inside this
  /// queue, so two that overlap never pass the limits together.
  final _intake = ComposerIntakeQueue();
  final _preview = PreviewSlot();
  String? _sessionModel;
  String? _sessionProvider;
  String? _sessionReasoningEffort;
  String? _sessionReasoningWire;
  String? _projectName;
  String? _storedSessionId;
  bool _showSessionFiles = false;
  bool _openGit = false;
  String? _gitFocus;

  String? get _fileSessionId =>
      _storedSessionId ??
      (widget.session.isLocalDraft
          ? _normalChat?.storedSessionId
          : _storedSessionKey);

  /// The session tree needs a stored chat whose live binding is not a remote
  /// terminal. Drafts and non-local backends keep the earlier file browser.
  bool get _sessionScopedFiles {
    final id = _fileSessionId;
    final gateway = _desktopGateway;
    if (gateway == null || id == null) return false;
    final backend = gateway.boundTerminalBackend(id);
    return backend == null || backend == 'local';
  }

  void _noteGitTurnStarted() {
    final owner = _desktopGateway?.workspace;
    final session = _fileSessionId;
    if (owner == null || session == null || session.isEmpty) return;
    unawaited(captureGitTurnBaseline(owner: owner, sessionId: session));
  }

  List<TurnChangedFile> get _turnChangedFiles {
    if (_desktopGateway == null || _fileSessionId == null) return const [];
    return changedFilesInLatestTurn(_messages);
  }

  int _projectNameRefreshGeneration = 0;
  bool _sessionModelOverride = false;
  bool _loadingModelOptions = false;
  bool _changingModel = false;
  bool _sending = false;
  bool _streamingNow = false;
  bool get _streaming => _streamingNow;

  /// Every end of a turn passes here, however the turn ended, even when it
  /// starts and ends between two frames.
  set _streaming(bool value) {
    if (_streamingNow && !value) _statusAfterTurn();
    _streamingNow = value;
  }

  bool _companionLeftDuringTurn = false;
  bool _companionUnread = false;
  final _held = ClientHeldQueue();
  bool _heldDrainBusy = false;
  bool _heldTouched = false;
  String? _editingHeldId;
  bool _parkHeldOnStop = true;
  bool _preparingSend = false;
  bool _midTurnSendInFlight = false;
  GatewayTurnStatus? _gatewayTurnStatus;
  String? _terminalTurnNotice;
  _ResponseTransport _activeResponseTransport = _ResponseTransport.none;
  String? _activeClientTurnId;
  // Stop can arrive after submit admission but before the coordinator's first
  // persisted callback supplies its client-turn identity. Keep that intent on
  // the v2 route rather than falling back to a legacy session interrupt.
  Completer<void>? _recoverableSubmissionState;
  bool _recoveringTurn = false;
  bool _legacyTransportFallback = false;
  bool _stockGatewayFallback = false;

  /// View-only admission gate; all reconnect work belongs to the app owner.
  bool get _pendingReattachResync => _normalChat?.snapshot.reconciling ?? false;

  /// Backstop for [releaseClientAfterStreamSettles] on the dispose path: a
  /// stream that never settles must not hold this screen's HTTP client open
  /// for the life of the process.
  static const _detachedStreamCloseDeadline = Duration(minutes: 30);

  /// Fences route-owned preparation and the existing REST/v2 UI callbacks.
  /// Stock turn and recovery generations live exclusively on the app owner.
  int _responseGeneration = 0;
  bool _deferredHistoryRefreshPending = false;
  bool _deferredHistoryRefreshing = false;
  String? _persistedHistoryContextRequested;
  Object? _persistedHistoryContextFlight;
  bool _stopResponseInFlight = false;
  bool _approvalDialogOpen = false;
  bool _approvalRouteOpen = false;
  Route<bool>? _approvalPromptRoute;
  String? _activeApprovalServerRequestId;
  final Set<String> _cancelledInteractiveRequestIds = {};
  final List<_PendingSensitivePrompt> _sensitivePromptQueue = [];
  final Set<String> _expiredSensitivePromptIds = {};
  _PendingSensitivePrompt? _activeSensitivePrompt;
  bool _sensitivePromptRouteOpen = false;
  Route<GatewaySensitivePromptDialogResult>? _sensitivePromptRoute;
  final List<_PendingClarifyPrompt> _clarifyPromptQueue = [];
  _PendingClarifyPrompt? _activeClarifyPrompt;

  /// The onboarding card waiting in this chat (one per chat, as on the
  /// Desktop). Cleared when answered, closed or withdrawn.
  SetupBeatRequest? _setupBeat;

  /// The open `manage_catalog` install card of this chat, if any.
  CatalogOperation? _catalog;
  bool _clarifyPromptRouteOpen = false;
  Route<bool>? _clarifyPromptRoute;
  bool _clarifyPromptClosing = false;

  /// Clarify prompts whose answer the user submitted from their own card.
  ///
  /// The batch transport locks one answer at a time and reports the remaining
  /// question ids while that answer is still in flight, so the reconcile sees
  /// the card's own question leave the pending set. Without this record it
  /// would close the card a second time, and that surplus pop takes the route
  /// underneath with it — the chat screen on the legacy transport, or the next
  /// question of the batch once its card is open — leaving the batch
  /// unanswerable until the chat is re-entered.
  final Set<String> _selfAnsweredClarifyIdentities = {};

  // Voice input / spoken replies
  final FlutterTts _flutterTts = FlutterTts();
  late final VoiceComposerController _voiceComposer;
  late final VoiceRecordingController _voiceRecording;
  DashboardClient? _voiceDashboard;
  late final HandsFreeConversationController _handsFree;
  late final VoiceReplySpeaker _replySpeaker;

  /// The client-direct speaker this screen made (null when a test injects
  /// one): disposed with the screen so its audio player is released.
  ClientDirectVoiceReplySpeaker? _ownedDirectSpeaker;

  /// The barge-in monitor whose microphone is open over the reply being
  /// read aloud; the composer shows that the mic is on while it is set.
  BargeInMonitor? _bargeInLive;
  late final Future<void> _voiceSetup;
  final Object _voiceRouteToken = Object();
  ModalRoute<dynamic>? _voiceRoute;
  bool _voiceElementActive = true;
  bool _voiceBound = false;
  Object? _voiceAccountEpoch;
  bool _voiceForeground = true;
  int _voiceForegroundEpoch = 0;
  int _manualAudioIntent = 0;
  Duration _followupTimeout = const Duration(seconds: 10);
  _HandsFreeTurnBinding? _voiceTurn;
  bool get _handsFreeSupported =>
      !isParkedAutomotive &&
      (widget.testHandsFreePlatform != null ||
          (!kIsWeb && defaultTargetPlatform == TargetPlatform.android));
  bool _voiceReplyEnabled = !isParkedAutomotive;
  bool _voicePlaybackConfigured = false;
  bool _awaitingVoiceReply = false;
  String? _voiceStatus;
  String? _sttLocaleId;

  // Verbose mode
  bool _verboseMode = false;

  // Chat density (bubble geometry and sender labels)
  ChatDensity _chatDensity = chatDensitySelection.value;

  // Scroll management
  final _reader = GlobalKey<TranscriptReaderState>();
  final _scrollController = ScrollController();
  final _scrollCoordinator = ChatScrollCoordinator();
  final _endAffordanceController = ChatEndAffordanceController();
  final _composerFocus = FocusNode();
  final _promptRecall = ComposerPromptRecall();
  bool _keyboardEndScrollDone = false;
  bool _streamFollowScheduled = false;
  bool _initialEndFrameScheduled = false;
  bool _openingHistoryChromePending = true;
  bool _openingScrollInterrupted = false;
  double? _initialEndLastExtent;
  int _initialEndStableFrames = 0;
  int _initialEndFramesRemaining = 0;
  static const _initialEndFrameBudget = 12;
  static const _requiredStableEndFrames = 2;
  static const _stableExtentTolerance = 0.5;
  static final Map<String, List<GatewayNotice>> _savedGatewayNotices = {};

  late final TurnNotificationService _turnNotifications;

  @override
  void initState() {
    super.initState();
    ChatScreen._mounted[ChatScreen._mountKey(
          widget.connection.id,
          widget.session.id,
        )] =
        this;
    CompanionDraft.pending.addListener(_applyCompanionDraft);
    _composerFocus.addListener(_syncComposerKeyboardEndScroll);
    _notificationApprovalOrigin = NotificationApprovalAuthority.origin(
      widget.connection,
    );
    _sessionTitle = widget.session.title;
    _sessionArchived = widget.session.archived;
    WidgetsBinding.instance.addObserver(this);
    _voiceAccountEpoch = ConnectionMutationBarrier.capture(
      widget.connection.id,
    );
    _voiceForeground =
        WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    _projectName = _normalisedProjectName(widget.projectName);
    _viewController =
        widget.turnApplicationController ??
        (widget.testRemotePromptSubmit != null
            ? (_localTurnController ??= GatewayTurnApplicationController())
            : GatewayTurnApplicationController.standalone);
    _presentationRegistry = _viewController.presentationFor(widget.connection);
    _presentation = _presentationRegistry.chatFor(widget.session.id);
    _reasoningRegistry = _presentationRegistry;
    _reasoningPresentation = _presentation;
    _reasoningExpansionPins = _reasoningPresentation.openReasoningVisit();
    _toolActivityPins = _presentation.openToolVisit();
    _draftWriter = _presentation.openWriter(
      onBindingChanged: () {
        if (mounted && widget.initialComposerText == null) {
          unawaited(_restoreComposerDraft());
        }
      },
    );
    _slashController = SlashCommandController(
      cacheScope: _slashCatalogScope,
      loadCatalog: () async {
        final gateway = _slashGateway;
        if (gateway == null) {
          throw UiMessageException(
            serviceStrings.release_chat_slash_needs_gateway,
          );
        }
        return gateway.fetchSlashCommands(sessionId: widget.session.id);
      },
      localCommands: _localSlashCommands,
    )..addListener(_onSlashCommandChanged);
    if (_slashGateway case final gateway?) {
      _slashController.useRefusals(gateway.slashRefusals);
    }
    _textController.addListener(_onComposerChanged);
    if (widget.initialComposerText case final shared?) {
      if (widget.initialComposerAppends) {
        // A link's prefill goes after the unsent draft, never over it.
        unawaited(_appendLinkPrefill(shared));
      } else {
        _textController.text = shared;
        _textController.selection = TextSelection.collapsed(
          offset: shared.length,
        );
      }
    }
    _turnNotifications =
        widget.testTurnNotifications ??
        widget.notifications ??
        TurnNotificationService.shared;
    unawaited(_turnNotifications.ensureInitialized());
    // A notification action that could not answer directly (the request is
    // owned by this screen's gateway, not the app-level controller) lands in
    // the shared store; consume it on mount and whenever it changes while
    // this chat is open — the already-mounted owner must observe it too.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _consumePendingNotificationApproval(),
    );
    pendingNotificationApprovals.addListener(
      _consumePendingNotificationApproval,
    );
    _client =
        widget.testApiClient ?? ApiClient.forConnection(widget.connection);
    _gateway = GatewayChatClient(_client);
    _attachmentDraftService =
        widget.testAttachmentDraftService ?? AttachmentDraftService();
    _largePasteFormatter = LargePasteFormatter(onLargePaste: _onLargePaste);
    _attachmentSendCoordinator = AttachmentDraftSendCoordinator(
      _attachmentDraftService,
    );
    _voiceComposer = VoiceComposerController(
      textController: _textController,
      adapter:
          widget.testVoiceComposerAdapter ??
          createVoiceComposerAdapter(platform: widget.testHandsFreePlatform),
    )..addListener(_onVoiceComposerChanged);
    _voiceRecording = VoiceRecordingController(
      widget.testVoiceRecorder ??
          LocalVoiceRecorder(
            '${widget.connection.id}:${_notificationApprovalOrigin['approvalAccount']}:${widget.session.id}',
          ),
    )..addListener(_onVoiceComposerChanged);
    unawaited(_voiceRecording.ready);
    // The direct speaker opens its audio player on first playback only, and
    // this screen releases it on dispose.
    _replySpeaker =
        widget.testVoiceReplySpeaker ??
        (_ownedDirectSpeaker = ClientDirectVoiceReplySpeaker(
          store: VoiceClientRuntime.storeFor(
            widget.connection,
            connectionId: widget.connection.id,
            profile: widget.connection.gatewayProfile,
          ),
          scopeKey:
              '${widget.connection.id}::${widget.connection.gatewayProfile ?? ''}',
          fallback: FlutterVoiceReplySpeaker(_flutterTts),
        ));
    _handsFree = HandsFreeConversationController(
      platform:
          widget.testHandsFreePlatform ??
          MethodChannelHandsFreeVoicePlatform.shared,
      ownerId: 'hands-free-${const Uuid().v4()}',
      isAuthorityCurrent: _isVoiceAuthorityCurrent,
      canStart: _canStartHandsFree,
      prepareAudio: _prepareHandsFreeAudio,
      submitHandsFreePrompt: _submitHandsFreePrompt,
      speakHandsFreeReply: _speakHandsFreeReply,
      cancelSpeech: _replySpeaker.stop,
      localeId: () => _sttLocaleId,
    )..addListener(_onVoiceComposerChanged);
    _voiceBound = true;
    handsFreeRouteObserver.addListener(_onVoiceRouteChanged);
    handsFreeEnabled.addListener(_onHandsFreeEnabledChanged);
    ConnectionMutationBarrier.addListener(_onVoiceAccountChanged);
    _attachmentDrafts
      ..addAll(widget.initialAttachmentDrafts)
      ..addAll(widget.testInitialAttachmentDrafts);
    _gatewayNotices = List<GatewayNotice>.from(
      _savedGatewayNotices[_gatewayNoticeIdentity] ?? const [],
    );
    _slashNotices.addAll(
      _savedSlashNotices[_gatewayNoticeIdentity] ?? const [],
    );
    _chatModelStore = ChatModelOverrideStore.open();
    _sessionModelRestore = _restoreSessionModelOverride();
    final hasDashboardAuth = widget.connection.hasDashboardAuth;
    if (widget.connection.desktopGatewayUrl?.trim().isNotEmpty == true ||
        hasDashboardAuth) {
      try {
        _attachNormalSession();
        final gateway = _normalSession!.client;
        _desktopGateway = gateway;
        if (gateway != null) widget.testDesktopGateway?.call(gateway);
        if (gateway != null) _bindWake();
        if (_voiceLiveMode != null) _bindLiveVoice();
        // The catalogue is per connection: a bound transport invalidates any
        // failure recorded before the socket existed. An application session
        // can exist without a Desktop client (routing/test owners).
        if (gateway != null) {
          _slashController.useRefusals(gateway.slashRefusals);
          _slashController.invalidate();
        }
      } on ArgumentError {
        // The regular mobile chat remains usable; selection surfaces the
        // actionable configuration error when Desktop attachments are needed.
        _desktopGateway = null;
      }
    }
    if (_liveEngine == null &&
        (widget.testVoiceLiveMode != null ||
            widget.testVoiceLiveEngineFactory != null)) {
      _bindLiveVoice();
    }
    if (_desktopGateway == null && widget.testWakeController != null) {
      _bindWake();
    }
    // A wake word routed here (a fresh chat, or this profile's connection)
    // starts its voice once this chat is on screen.
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeTakeWakeVoice());
    // Test seam: with no real gateway, hand the same handler to the test
    // hook so it can simulate reconnect transitions.
    if (widget.testRemotePromptSubmit != null && _normalSession == null) {
      _attachNormalSession();
    }
    _syncKanbanChat();
    if (widget.initialComposerText == null) unawaited(_restoreComposerDraft());
    widget.testDesktopConnectionHook?.handler = (state) {
      widget.testDesktopConnectionHook?.currentState = state;
      _normalSession?.connectionChanged(state);
      if (_normalSession == null) _onDesktopConnectionChanged(state);
    };
    widget.testDesktopAsyncEventHook?.handler = (event) {
      if (_normalSession != null &&
          (_turnApplicationSession == null || _legacyTransportFallback)) {
        _normalSession!.receiveEvent(widget.session.id, event);
      } else {
        _handleDesktopAsyncEvent(widget.session.id, event);
      }
    };
    // The experimental recovery-v2 session.open contract carries no cwd.
    // Project drafts must use stock session.create(cwd), or the server files
    // them as unassigned even when their header names a Project.
    _turnApplicationSession =
        widget.testTurnApplicationSession ??
        (_desktopGateway != null &&
                shouldUseRecoveryV2ForSession(
                  widget.session,
                  projectWorkingDirectory: widget.projectWorkingDirectory,
                )
            ? widget.turnApplicationController?.sessionFor(widget.connection)
            : null);
    final turnApplicationSession = _turnApplicationSession;
    if (turnApplicationSession != null) {
      _turnApplicationAsyncEventRegistration = turnApplicationSession
          .setAsyncEventListener(widget.session.id, _handleDesktopAsyncEvent);
      _turnApplicationSettledRegistration = turnApplicationSession
          .setTurnSettledListener(widget.session.id, _onTurnSettled);
      _turnApplicationBoundRegistration = turnApplicationSession
          .setSessionBoundListener(widget.session.id, _onSessionBound);
    }
    unawaited(_refreshProjectName());
    unawaited(_refreshArchiveState());
    unawaited(_initializeChat());
    _loadVerboseMode();
    _loadChatDensity();
    chatDensitySelection.addListener(_onChatDensityChanged);
    _voiceSetup = _initVoice();
    // retrieveLostData is Android-only and has no owning session ID. A
    // restored workspace must not race several chats for the same photo.
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        !widget.singleSession) {
      unawaited(_recoverLostImage());
    }
    _scrollController.addListener(_onScroll);
    if (_desktopGateway != null) unawaited(_ensureDesktopSession());
    unawaited(_restoreHeldQueue());
  }

  void _attachNormalSession() {
    final controller = _viewController;
    final testClient = widget.testApiClient;
    _normalSession = controller.normalSessionFor(
      widget.connection,
      submit: widget.testRemotePromptSubmit,
      resume: widget.testNormalResume,
      history: testClient == null
          ? null
          : (id) => testClient.getMessages(
              id,
              limit: ChatHistoryWindow.pageSize,
              latest: true,
            ),
      notifications: _turnNotifications,
    );
    _normalChat = _normalSession!.chatFor(
      widget.session.id,
      storedSessionId: widget.session.isLocalDraft
          ? null
          : _normalSession!.findChat(widget.session.id)?.storedSessionId ??
                widget.testStoredSessionKey?.call(widget.session.id) ??
                widget.session.id,
      title: _sessionTitle,
      lineageRootId: widget.session.lineageRootId,
      workingDirectory: widget.projectWorkingDirectory,
    );
    if (_textController.text.isNotEmpty || widget.initialComposerText != null) {
      _normalChat!.invalidateDraftRecovery();
    }
    _normalSubscription = _normalChat!.subscribe(_applyNormalSnapshot);
    final session = _normalSession!;
    unawaited(
      session.ready.then(
        (_) {
          if (!mounted || !identical(_normalSession, session)) return;
          setState(() => _normalSessionReady = true);
        },
        onError: (Object _, StackTrace _) {
          // Failed receipt hydration cannot prove that the chat is idle.
        },
      ),
    );
  }

  void _applyNormalSnapshot(
    NormalGatewayChatSnapshot snapshot, {
    bool hydrateHistory = true,
    bool followStream = true,
  }) {
    if (!mounted) return;
    _observeVoiceNormalTerminal(snapshot);
    if (_normalChat case final owner?
        when owner.kanbanRevision != _kanbanSeedsSeen) {
      _kanbanSeedsSeen = owner.kanbanRevision;
      // The ids compression moved the chat to, before the cards: a card
      // made after a compression carries the newer id.
      _kanbanDock
        ..setChat(primaryId: null, aliases: owner.kanbanSessionIds)
        ..observeSeeds(owner.kanbanSeeds);
    }
    final rejectedDraft = snapshot.rejectedDraft;
    if (rejectedDraft != null &&
        widget.initialComposerText == null &&
        _composerRevision == _clearedComposerRevision) {
      _restoreComposerAfterRejectedSend(rejectedDraft);
    }
    _normalInputUpdatesSeen.retainAll(snapshot.inputUpdates);
    final updatedInputIds = <String>{};
    for (final event in snapshot.inputUpdates) {
      if (_normalInputUpdatesSeen.add(event)) {
        final id = (event.data['id'] ?? event.data['request_id'])?.toString();
        if (id != null) updatedInputIds.add(id);
        _handleDesktopGatewayEvent(event, _responseGeneration);
      }
    }
    _normalInputSeen.retainAll(
      snapshot.pendingInput.map(
        (event) => '${event.type}:${jsonEncode(event.data)}',
      ),
    );
    _normalAuxiliarySeen.retainAll(snapshot.auxiliaryEvents);
    for (final event in snapshot.auxiliaryEvents) {
      if (_normalAuxiliarySeen.add(event)) {
        _handleDesktopAsyncEvent(widget.session.id, event);
      }
    }
    _normalSnapshot =
        snapshot; // read-only owner projection, not a route buffer
    _cardNormalFailure(snapshot);
    _retainedRecoveryOutcomeIds.retainAll(
      snapshot.receivedOutcomes.map((outcome) => outcome.id),
    );
    _historyObservedRecoveryOutcomeIds.retainAll(
      snapshot.receivedOutcomes.map((outcome) => outcome.id),
    );
    final justDetached =
        _desktopConnectionState == DesktopConnectionState.connected &&
        snapshot.connectionState != DesktopConnectionState.connected &&
        snapshot.wireEmitted &&
        snapshot.hasActiveTurn;
    if (justDetached &&
        _normalTurnId != null &&
        ModalRoute.of(context)?.isCurrent == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context
                .l10n
                .connection_switched_the_running_reply_continues_on_the_server_and,
          ),
          persist: false,
        ),
      );
    }
    final newTurn = snapshot.turnId != _normalTurnId;
    if (newTurn) {
      _normalTurnId = snapshot.turnId;
      _responseGeneration++;
      _normalInputSeen.clear();
      _scrollCoordinator.beginStreaming(isNearEnd: _isNearEnd());
    }
    final bindingChanged =
        snapshot.storedSessionId != null &&
        _storedSessionId != snapshot.storedSessionId;
    _storedSessionId = snapshot.storedSessionId;
    _syncKanbanChat();
    if (bindingChanged) {
      unawaited(_refreshProjectName());
      unawaited(_refreshArchiveState());
    }
    final pendingIds = snapshot.pendingInput
        .map(
          (event) =>
              (event.data['server_request_id'] ??
                      event.data['request_id'] ??
                      event.data['id'])
                  ?.toString(),
        )
        .whereType<String>()
        .toSet();
    for (final removed in _normalPendingRequestIds.difference(pendingIds)) {
      if (updatedInputIds.contains(removed)) continue;
      _handleDesktopGatewayEvent(
        StreamEvent(
          type: 'request.cancel',
          data: {
            'id': removed,
            'method': _normalPendingRequestMethods[removed],
          },
        ),
        _responseGeneration,
      );
    }
    _normalPendingRequestMethods.clear();
    for (final event in snapshot.pendingInput) {
      final id =
          (event.data['server_request_id'] ??
                  event.data['request_id'] ??
                  event.data['id'])
              ?.toString();
      if (id != null) {
        _normalPendingRequestMethods[id] = event.type.split('.').first;
      }
    }
    _normalPendingRequestIds
      ..clear()
      ..addAll(pendingIds);
    // Only this admission's received assistant scopes can create unread work.
    // Imported donors and saved rows are not new current output.
    final lastPrompt = snapshot.displayRows.lastIndexWhere(
      (row) => row['role'] == 'user',
    );
    final currentRows = snapshot.displayRows.skip(lastPrompt + 1).toList();
    _normalMaterializedIds.retainAll(
      snapshot.displayRows
          .map((row) => row['_normal_projection_id'])
          .whereType<String>(),
    );
    for (final row in snapshot.displayRows) {
      final id = row['_normal_projection_id']?.toString();
      if (id != null &&
          row['role'] == 'assistant' &&
          (row['content']?.toString().isNotEmpty ?? false) &&
          _normalMaterializedIds.add(id) &&
          snapshot.wireEmitted &&
          snapshot.turnId != null &&
          currentRows.contains(row)) {
        _registerMaterializedAssistantMessage();
      }
    }
    final wasSending = _sending;
    // The socket came up: the Kanban strip may read the board now.
    if (_desktopConnectionState != DesktopConnectionState.connected &&
        snapshot.connectionState == DesktopConnectionState.connected) {
      scheduleMicrotask(() => unawaited(_kanbanDock.refresh()));
    }
    setState(() {
      _desktopConnectionState = snapshot.connectionState;
      if (snapshot.turnId != null || snapshot.displayRows.isNotEmpty) {
        _loading = false;
      }
      _sending = snapshot.hasActiveTurn && !snapshot.reconciling;
      if (!wasSending && _sending) scheduleMicrotask(_noteGitTurnStarted);
      _streaming =
          snapshot.hasActiveTurn &&
          !snapshot.reconciling &&
          snapshot.phase != NormalGatewayTurnPhase.preparing;
      _activeResponseTransport = snapshot.hasActiveTurn
          ? _ResponseTransport.desktop
          : _ResponseTransport.none;
      _gatewayTurnStatus = snapshot.reconciling
          ? GatewayTurnStatus(
              kind: 'recovery',
              // Subscription replay can happen while attaching in initState.
              text: serviceStrings.release_chat_recovering_without_resending,
            )
          : snapshot.status;
      if (hydrateHistory) {
        // Finish synchronous owner fan-out before merging into the retained
        // window: another subscriber can accept a newer snapshot reentrantly.
        // An idle owner provides rows only; physical route pages still own the
        // paging cursor, including during a held older/latest request.
        final owner = _normalChat;
        scheduleMicrotask(() {
          if (!mounted ||
              !identical(owner, _normalChat) ||
              !identical(_normalSnapshot, snapshot) ||
              _windowContainsLatest(_ownerHistoryForPresentation(snapshot))) {
            return;
          }
          setState(() {
            if (!_windowContainsLatest(snapshot.historyRows)) {
              if (snapshot.turnId == null) {
                _historyWindow.mergeObservedRows(snapshot.historyRows);
                _historyWindowRevision++;
                _extractToolMessages(_historyWindow.rows);
              } else {
                _acceptRecentMessages(snapshot.historyRows);
              }
            }
            if (snapshot.historyPresentationRows.isNotEmpty) {
              // A sibling can confirm a long turn while this route's own
              // context read is held. Publish its canonical replacement here,
              // without granting retained rows latest/read or cursor authority.
              _historyWindow.mergeObservedRows(
                _ownerHistoryForPresentation(snapshot),
              );
              _historyWindowRevision++;
              _extractToolMessages(_historyWindow.rows);
            }
            _messages = _restHistoryForPresentation();
          });
        });
      }
      if (!hydrateHistory &&
          snapshot.historyPresentationRows.isNotEmpty &&
          !_windowContainsLatest(_ownerHistoryForPresentation(snapshot))) {
        // Physical readers already applied their cursor-owning batch, but it
        // can predate an alias's retained per-row veto. This synchronous path
        // supersedes the queued owner callback; apply its presentation union
        // too, without lending that union paging or latest-read authority.
        _historyWindow.mergeObservedRows(
          _ownerHistoryForPresentation(snapshot),
        );
        _historyWindowRevision++;
        _extractToolMessages(_historyWindow.rows);
      }
      _messages = _restHistoryForPresentation();
      // Hydrated child roots and owner runtime IDs may differ. Preserve the
      // stable task anchor and forward all progress/final updates to the modal.
      for (final update in snapshot.subagents) {
        _mergeSubagentActivity(update);
      }
      // App-owned runs use stable projection ids, so copying snapshot rows or
      // replacing a route cannot discard receipt chronology.
      _timeline = snapshot.timeline;
    });
    _queuePersistedHistoryContext(snapshot);
    if (followStream) {
      if (snapshot.hasActiveTurn) {
        _scheduleStreamingFollow();
      } else {
        _scheduleScrollTarget(_scrollCoordinator.endStreaming());
      }
    }
    if (snapshot.phase == NormalGatewayTurnPhase.failed ||
        snapshot.phase == NormalGatewayTurnPhase.reconciledUnknown) {
      _awaitingVoiceReply = false;
    }
    var voiceSpoke = false;
    if (snapshot.phase == NormalGatewayTurnPhase.completed &&
        _awaitingVoiceReply) {
      final rows = currentRows;
      for (final row in rows.reversed) {
        if (row['role'] == 'user') break;
        final text = row['content']?.toString() ?? '';
        if (const {'assistant', 'agent'}.contains(row['role']) &&
            row['_gateway_interim'] != true &&
            text.isNotEmpty) {
          _awaitingVoiceReply = false;
          // Spoken as the voice reply: auto-read never reads it again.
          AutoReadLedger.claim(
            _autoReadChatKey,
            _normalReplyKeys(snapshot, row),
          );
          unawaited(_speakAssistantText(text).catchError((Object _) {}));
          voiceSpoke = true;
          break;
        }
      }
      _awaitingVoiceReply = false;
    }
    _feedClassicLiveSnapshot(snapshot, currentRows);
    // An ordinary typed turn with auto-read on: read the terminal reply,
    // once. The owner hands a completed snapshot to this route again (a
    // re-subscription, the route coming back); the ledger keeps it to one
    // read.
    if (!voiceSpoke &&
        _liveEngine?.active != true &&
        snapshot.phase == NormalGatewayTurnPhase.completed &&
        autoSpeakRepliesEnabled.value) {
      final rows = currentRows;
      for (final row in rows.reversed) {
        if (row['role'] == 'user') break;
        final text = row['content']?.toString() ?? '';
        if (const {'assistant', 'agent'}.contains(row['role']) &&
            row['_gateway_interim'] != true &&
            text.isNotEmpty) {
          if (AutoReadLedger.claim(
            _autoReadChatKey,
            _normalReplyKeys(snapshot, row),
          )) {
            unawaited(_speakAssistantText(text).catchError((Object _) {}));
          }
          break;
        }
      }
    }
    // The route this chat captured with its dependencies, not an ancestor
    // lookup at the end of the frame: a chat deactivated by then (leaving,
    // or torn down after a failed build) must not look up its ancestors.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_voiceElementActive || _voiceRoute?.isCurrent != true) {
        return;
      }
      final currentInputs =
          _normalChat?.snapshot.pendingInput ?? const <StreamEvent>[];
      for (final event in snapshot.pendingInput) {
        if (!currentInputs.contains(event)) continue;
        final key = '${event.type}:${jsonEncode(event.data)}';
        if (_normalInputSeen.add(key)) {
          _handleDesktopGatewayEvent(event, _responseGeneration);
        }
      }
    });
  }

  /// This chat in [AutoReadLedger].
  String get _autoReadChatKey =>
      '${widget.connection.id}::${widget.session.id}';

  /// A completed normal-owner reply's identity: its turn (submission) id
  /// and, once persisted, its durable row id.
  List<String> _normalReplyKeys(
    NormalGatewayChatSnapshot snapshot,
    Map<String, dynamic> row,
  ) => [
    if (snapshot.turnId case final turn?) 'turn:$turn',
    if (row['id'] case final id?) 'row:$id',
  ];

  void _queuePersistedHistoryContext(NormalGatewayChatSnapshot snapshot) {
    final owner = _normalChat;
    if (owner == null ||
        snapshot.hasActiveTurn ||
        _loading ||
        _sending ||
        _streaming ||
        _stopResponseInFlight ||
        _pendingReattachResync ||
        _persistedHistoryContextFlight != null) {
      return;
    }
    final key = owner.persistedTurnContextKey(snapshot.historyRows);
    if (key == null || key == _persistedHistoryContextRequested) return;
    // One automatic bounded scan per receipt set. Incomplete/failed context
    // consumes its attempt only if that read remains valid. A new turn can
    // invalidate a held scan without permanently suppressing its fresh retry.
    _persistedHistoryContextRequested = key;
    final flight = Object();
    _persistedHistoryContextFlight = flight;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !identical(owner, _normalChat)) {
        _finishPersistedHistoryContext(flight, invalidated: true);
        return;
      }
      if (_sending ||
          _streaming ||
          _stopResponseInFlight ||
          _pendingReattachResync ||
          owner.persistedTurnContextKey(owner.snapshot.historyRows) != key) {
        _finishPersistedHistoryContext(flight, invalidated: true);
        return;
      }
      unawaited(_fetchMessages(persistedContextFlight: flight));
    });
  }

  void _finishPersistedHistoryContext(
    Object flight, {
    bool invalidated = false,
  }) {
    if (!identical(_persistedHistoryContextFlight, flight)) return;
    _persistedHistoryContextFlight = null;
    if (invalidated) _persistedHistoryContextRequested = null;
    // This also covers a new turn which already settled while the old page
    // was held. An accepted failure keeps its key, so it cannot retry-spin.
    final snapshot = _normalChat?.snapshot;
    if (mounted && snapshot != null) _queuePersistedHistoryContext(snapshot);
  }

  bool _sameHistoryRows(
    List<Map<String, dynamic>>? a,
    List<Map<String, dynamic>> b,
  ) =>
      a != null &&
      a.length == b.length &&
      Iterable<int>.generate(b.length).every((i) => mapEquals(a[i], b[i]));

  bool _windowContainsLatest(List<Map<String, dynamic>> latest) {
    int? id(Map<String, dynamic> row) =>
        int.tryParse(row['id']?.toString() ?? '');
    final retained = {
      for (final row in _historyWindow.rows)
        if (id(row) != null) id(row): row,
    };
    return latest
            .where((row) => id(row) != null)
            .every(
              (row) =>
                  retained[id(row)] != null &&
                  mapEquals(retained[id(row)], row),
            ) &&
        _sameHistoryRows(
          _historyWindow.rows.where((row) => id(row) == null).toList(),
          latest.where((row) => id(row) == null).toList(),
        );
  }

  List<Map<String, dynamic>> _ownerHistoryForPresentation(
    NormalGatewayChatSnapshot snapshot,
  ) {
    if (snapshot.historyPresentationRows.isEmpty) return snapshot.historyRows;
    // The owner preserves per-row observation order through alias handoff.
    // Its retained presentation may contain a newer veto than the winning
    // owner's admission-only latest snapshot. Never overwrite that value.
    final projection = ChatHistoryWindow()
      ..mergeObservedRows(snapshot.historyRows)
      ..mergeObservedRows(snapshot.historyPresentationRows);
    return projection.rows;
  }

  String get _connectionIdentity =>
      '${widget.connection.baseUrl}|'
      '${widget.connection.gatewayPrefix ?? ''}|'
      '${widget.connection.desktopGatewayUrl ?? ''}';

  /// The catalogue is per profile as well as per connection: a profile switch
  /// on the same socket advertises a different command set.
  String get _slashCatalogScope =>
      '$_connectionIdentity|${widget.connection.gatewayProfile ?? ''}|${widget.session.id}';

  /// Slash RPCs go through the Desktop socket, or the test double when there is
  /// no live one.
  SlashCommandGateway? get _slashGateway =>
      widget.testSlashGateway ?? _desktopGateway ?? _normalSession?.client;

  String get _gatewayNoticeIdentity =>
      '$_connectionIdentity|${widget.session.id}';

  void _onComposerChanged() {
    _promptRecall.editorChanged();
    if (_voiceBound && _handsFree.active) {
      _handsFree.revoke(HandsFreeStopReason.composerEdited);
    }
    _composerRevision += 1;
    _normalChat?.invalidateDraftRecovery();
    final text = _textController.text;
    final pathPaste = _pendingPathPaste;
    _pendingPathPaste = null;
    if (pathPaste != null &&
        !_restoringComposer &&
        text.contains(pathPaste.text)) {
      // The pasted path is committed now; intake may remove it safely.
      unawaited(_consumePathPaste(pathPaste));
    }
    if (!_restoringComposer && text != _lastComposerText) {
      _draftWriter.edit(_composerTextWithPastes(text));
    }
    _lastComposerText = text;
    _slashController.updateText(text);
  }

  void _applyCompanionDraft() {
    if (!mounted) return;
    CompanionDraft.applyTo(_textController);
  }

  void _onSlashCommandChanged() {
    if (mounted) setState(() {});
  }

  bool get _composerOwnerCurrent =>
      mounted &&
      widget.active &&
      _draftWriter.isCurrent &&
      identical(_presentationRegistry, _reasoningRegistry) &&
      identical(_presentation, _reasoningPresentation) &&
      ConnectionMutationBarrier.isCurrent(
        widget.connection.id,
        _voiceAccountEpoch,
      ) &&
      _voiceAccountCurrent();

  Iterable<String> _sentPrompts() sync* {
    final items = _normalChat == null
        ? buildConversationAttachmentItems(messages: _messages)
        : _normalDisplaySections(
            verbose: false,
          ).expand((section) => section.items);
    for (final row in items.whereType<Map<String, dynamic>>()) {
      if (row['role'] == 'user') {
        if (row['_display_content'] case final String text) yield text;
      }
    }
  }

  /// Replaces the draft with the chosen command and a trailing space. The
  /// dropdown then closes on its own: a command with an argument is no longer
  /// a single leading token. This is a user edit, so it goes through the same
  /// path as typing and the persisted draft follows immediately.
  void _applySlashCommand(SlashCommand command) {
    _slashController.close();
    _editComposerAsUser('${command.invocation} ');
  }

  /// Sets the composer from app chrome (a picked command, a prefill directive)
  /// and lets [_onComposerChanged] persist it exactly as typed input would.
  void _editComposerAsUser(String text) {
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  /// Puts a `hermes://` link's prefill into the composer after whatever is
  /// there or saved (an unsent draft is never replaced). Reads the draft
  /// first so a restore that has not landed yet is not lost.
  Future<void> _appendLinkPrefill(String prefill) async {
    String? draft;
    try {
      draft = await _draftWriter
          .read(reader: widget.testComposerDraftReader)
          .timeout(const Duration(seconds: 5));
    } catch (_) {
      draft = null;
    }
    if (!mounted) return;
    final current = _textController.text;
    final base = current.trim().isNotEmpty ? current : (draft ?? '');
    final text = appendComposerPrefill(base, prefill);
    if (text == current) return;
    _textController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  Future<void> _restoreComposerDraft() async {
    final revision = _composerRevision;
    await _normalSession?.ready;
    if (!mounted || !_draftWriter.isCurrent) return;
    final draft = await _draftWriter.read(
      reader: widget.testComposerDraftReader,
    );
    if (!mounted ||
        !_draftWriter.isCurrent ||
        draft == null ||
        _composerRevision != revision ||
        _textController.text.isNotEmpty) {
      return;
    }
    _setRestoredComposer(draft);
  }

  void _setRestoredComposer(String text) {
    _restoringComposer = true;
    try {
      _textController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } finally {
      _restoringComposer = false;
    }
  }

  bool get _usesNormalInputOwner =>
      _normalSession != null &&
      (_turnApplicationSession == null || _legacyTransportFallback);

  /// Slash-command RPCs need the Desktop socket. The REST/SSE transport keeps
  /// its existing text-send behaviour and never shows the dropdown.
  /// `/kanban` and `/bots` open the board and the bots screen on this chat's
  /// gateway; they are offered while there is one, listed by the gateway or
  /// not.
  List<SlashCommand> _localSlashCommands() {
    if (!mounted || _kanbanOwner == null) return const [];
    return [
      SlashCommand(
        name: 'kanban',
        description: context.sharedL10n.ng_slash_kanban,
      ),
      SlashCommand(name: 'bots', description: context.sharedL10n.ng_slash_bots),
    ];
  }

  bool get _slashCommandsAvailable =>
      _slashGateway?.slashCommandsSupported ?? false;

  bool get _slashDropdownVisible =>
      _slashController.isOpen && _slashCommandsAvailable;

  String get _normalLocalSessionKey =>
      _normalChat?.localSessionId ?? widget.session.id;

  String get _storedSessionKey =>
      _normalChat?.storedSessionId ??
      _desktopGateway?.storedSessionKeyFor(widget.session.id) ??
      widget.testStoredSessionKey?.call(widget.session.id) ??
      widget.session.id;

  /// The Kanban cards this chat sent to the board, drawn above the composer
  /// with the chat's other status rows. One per connection and chat.
  late ChatKanbanDockController _kanbanDock = _newKanbanDock();
  final GlobalKey<KanbanPaneHostState> _kanbanPane = GlobalKey();

  /// The gateway owner the dock reads the board and opens it through; null
  /// on a connection with no dashboard.
  RemoteWorkspaceOwner? get _kanbanOwner =>
      widget.testKanban?.owner ?? _desktopGateway?.workspace;

  ChatKanbanDockController _newKanbanDock() => ChatKanbanDockController(
    connectionId: widget.connection.id,
    profile: widget.connection.gatewayProfile,
    openSource: () {
      final fake = widget.testKanban?.source;
      if (fake != null) return fake();
      final owner = _kanbanOwner;
      return owner == null ? null : WorkspaceChatKanbanSource(owner);
    },
    // The dock reads over the socket this chat opened; it never opens one.
    // With no gateway client there is nothing to dial: the dock then only
    // says the connection has no dashboard.
    online: () =>
        widget.testKanban?.source != null ||
        _desktopGateway == null ||
        _desktopConnectionState == DesktopConnectionState.connected,
  );

  /// The owner's live Kanban cards already handed to the dock.
  int _kanbanSeedsSeen = -1;

  /// Tells the dock which session ids are this chat: a card whose
  /// `session_id` is one of them was created by this chat.
  void _syncKanbanChat() {
    final draft = widget.session.isLocalDraft;
    _kanbanDock.setChat(
      primaryId: _storedSessionId ?? (draft ? null : _storedSessionKey),
      aliases: [
        if (!draft) widget.session.id,
        widget.session.lineageRootId,
        _normalChat?.storedSessionId,
      ],
    );
  }

  Future<void> _openKanban([ChatKanbanCard? card]) {
    final dock = _kanbanDock;
    return openChatKanban(
      context,
      dock: dock,
      owner: _kanbanOwner,
      connection: widget.connection,
      card: card,
      pane: _kanbanPane.currentState,
      // Closed or switched to another chat meanwhile: open nothing.
      isCurrent: () => mounted && identical(dock, _kanbanDock),
      explain: (reason) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(reason))),
    );
  }

  static String? _normalisedProjectName(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Refreshes the sticky header from the same server Projects tree used by
  /// the workspace. A response that does not yet contain a newly persisted
  /// chat is inconclusive and therefore keeps the navigation-time label.
  Future<void> _refreshProjectName() async {
    final loader = widget.testProjectOverviewLoader;
    final gateway = _desktopGateway;
    if (loader == null && gateway == null) return;

    final generation = ++_projectNameRefreshGeneration;
    try {
      final overview = await (loader?.call() ?? gateway!.projects.tree());
      if (!mounted || generation != _projectNameRefreshGeneration) return;
      final candidates = <String>[];
      void addCandidate(String? value) {
        final id = value?.trim() ?? '';
        if (id.isNotEmpty && !candidates.contains(id)) candidates.add(id);
      }

      // The stored id is the canonical identity once a draft has been bound.
      addCandidate(_storedSessionId);
      addCandidate(gateway?.storedSessionKeyFor(widget.session.id));
      addCandidate(widget.testStoredSessionKey?.call(widget.session.id));
      addCandidate(widget.session.id);

      final resolution = resolveChatProjectHeader(overview, candidates);
      if (!resolution.known || resolution.projectName == _projectName) return;
      setState(() => _projectName = resolution.projectName);
    } catch (_) {
      // Project metadata is additive. Chat and recovery remain usable when an
      // older gateway lacks projects.tree or the control socket is offline.
    }
  }

  void _onSessionBound(String localSessionId, String storedSessionId) {
    if (localSessionId != widget.session.id) return;
    if (!mounted) return;
    _normalChat?.bindStoredSession(storedSessionId);
    _presentationRegistry.bind(localSessionId, storedSessionId);
    setState(() => _storedSessionId = storedSessionId);
    _syncKanbanChat();
    unawaited(_refreshProjectName());
    unawaited(_refreshArchiveState());
  }

  Future<void> _restoreSessionModelOverride() async {
    final store = await _chatModelStore;
    final override = store.read(
      connectionIdentity: _connectionIdentity,
      sessionId: widget.session.id,
    );
    if (!mounted || override == null) return;
    setState(() {
      _sessionModel = override.model;
      _sessionProvider = override.provider;
      _sessionReasoningEffort = override.reasoningEffort;
      _sessionReasoningWire = '';
      _sessionModelOverride = true;
    });
  }

  Future<void> _loadVerboseMode() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _verboseMode = prefs.getBool('verbose_mode') ?? false);
  }

  Future<void> _loadChatDensity() async {
    final prefs = await SharedPreferences.getInstance();
    final density = ChatDensityStore(prefs).read();
    if (!mounted || density == _chatDensity) return;
    setState(() => _chatDensity = density);
  }

  /// Settings can change the density while this chat is already mounted, so the
  /// selection is broadcast rather than read once per launch.
  void _onChatDensityChanged() {
    final density = chatDensitySelection.value;
    if (!mounted || density == _chatDensity) return;
    setState(() => _chatDensity = density);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _voiceRoute = ModalRoute.of(context);
    // ModalRoute establishes a dependency on visibility. A lower duplicate
    // route becoming current must replay pending input even if the server is
    // blocked waiting for that answer and sends no further stream frames.
    final current = ModalRoute.isCurrentOf(context) == true;
    if (!current || !widget.active) {
      _revokeVoice(HandsFreeStopReason.routeChanged);
    } else {
      // On top again (a pushed chat or a sheet closed): this chat owns the
      // wake word once more. The chat that covered it took the single
      // `wake.detected` handler and let go of it when it left.
      _bindWake();
      _syncClassicWakeForLive();
    }
    if (current && _normalChat != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_voiceElementActive && mounted && _voiceRoute?.isCurrent == true) {
          _applyNormalSnapshot(_normalChat!.snapshot, followStream: false);
        }
      });
    }
  }

  /// The gateway owns wake detection. Bind this chat so a wake event starts
  /// dictation on the active session, never on a neighbouring chat.
  /// The narrow-pane More chat tools row: as the wide pane's toggle button,
  /// a refused start says why.
  Future<void> _toggleWakeFromMenu() async {
    final wake = _wake;
    if (wake == null) return;
    final state = wake.state;
    final wasOn = state.listening || (state.enabled && state.paused);
    final ok = await wake.toggle(sessionId: widget.session.id);
    final notice = wake.state.notice.trim();
    if (!ok && !wasOn && mounted && notice.isNotEmpty) {
      ScaffoldMessenger.maybeOf(
        context,
      )?.showSnackBar(SnackBar(content: Text(notice)));
    }
  }

  void _bindWake() {
    final wake = _wake;
    if (wake == null) return;
    wake.bindSessionId(widget.session.id);
    wake.onWakeDetected = _onWakeDetected;
    wake.setAppForeground(_voiceElementActive && !_appInBackground);
  }

  /// As Desktop's `wake.detected` handling (app/contrib/wiring.tsx): a phrase
  /// enrolled by another profile is answered in THAT profile's chat, and a
  /// fresh session is a new chat. Either way the voice starts in the new
  /// chat once it is on screen, never in the chat that merely heard it.
  void _onWakeDetected(WakeDetectedEvent event) {
    if (!mounted || !_voiceElementActive) return;
    final target = event.profile;
    if (target != null &&
        wakeProfileKey(target) !=
            wakeProfileKey(widget.connection.gatewayProfile)) {
      unawaited(_routeWakeToProfile(target));
      return;
    }
    if (event.startNewSession && !_isFreshChat && !widget.singleSession) {
      WakeVoiceRequest.request(
        connectionId: widget.connection.id,
        profile: widget.connection.gatewayProfile,
        freshSession: true,
      );
      unawaited(_openFreshDraftChat(''));
      return;
    }
    unawaited(_startWakeVoice());
  }

  /// A chat nothing has been said in yet (what `/new` opens).
  bool get _isFreshChat =>
      widget.session.isLocalDraft &&
      _messages.isEmpty &&
      (_normalSnapshot?.displayRows.isEmpty ?? true) &&
      !_sending &&
      !_streaming;

  /// Hands a wake phrase of another profile to the saved connection that
  /// reaches it on the same machine, in a fresh chat. With none saved,
  /// nothing starts.
  Future<void> _routeWakeToProfile(String profile) async {
    var saved = const <SavedConnection>[];
    try {
      saved =
          await (widget.testSavedConnections?.call() ??
              SharedPreferences.getInstance().then(
                (prefs) =>
                    ConnectionManager(prefs).loadConnectionsWithSecrets(),
              ));
    } catch (_) {
      // Unreadable storage is the same as no saved owner.
    }
    if (!mounted || !_voiceElementActive || !widget.active) return;
    final match = wakeConnectionForProfile(
      saved,
      from: widget.connection,
      profile: profile,
    );
    if (match == null ||
        widget.singleSession ||
        ConnectionMutationBarrier.isPending(match.id) ||
        _voiceRoute?.isCurrent != true) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            context.sharedL10n.wake_word_other_profile(profile.trim()),
          ),
        ),
      );
      // Nothing took the microphone: wake listens again.
      _syncClassicWakeForLive();
      return;
    }
    WakeVoiceRequest.request(
      connectionId: match.id,
      profile: match.gatewayProfile,
      freshSession: true,
    );
    await _openFreshDraftChat('', owner: match);
  }

  /// Takes a wake request routed to this chat's owner: the chat that now
  /// shows the fresh session starts the voice.
  void _maybeTakeWakeVoice() {
    if (!mounted || !_voiceElementActive || !widget.active) return;
    if (!WakeVoiceRequest.take(
      connectionId: widget.connection.id,
      profile: widget.connection.gatewayProfile,
      isNewChat: _isFreshChat,
    )) {
      return;
    }
    unawaited(_startWakeVoice());
  }

  Future<void> _startWakeVoice() async {
    if (!mounted || !_voiceElementActive) return;
    if (_liveEngine?.active == true) return;
    // A chat that has only just mounted does not know the host's voice mode
    // yet: read it before picking the engine.
    final mode = _voiceLiveMode;
    if (mode != null && !mode.hasStatus) {
      await mode.refresh();
      if (!mounted || !_voiceElementActive || !widget.active) return;
      if (_liveEngine?.active == true) return;
    }
    if (mode?.effectiveMode == 'gpt-live') {
      unawaited(_startVoiceConversation());
      return;
    }
    if (!_voiceComposer.listening && !_voiceComposer.starting) {
      unawaited(_startVoiceInput());
    }
  }

  void _bindLiveVoice() {
    _disposeLiveVoice();
    final mode = _voiceLiveMode;
    mode?.addListener(_onLiveVoiceChanged);
    if (mode != null) {
      unawaited(mode.refresh());
    }
    final transport =
        mode?.transport ??
        GptLiveGatewayTransport(
          widget.connection,
          profile: widget.connection.gatewayProfile,
        );
    final ownsTransport = mode == null;
    if (ownsTransport) _liveTransport = transport;
    final engine =
        widget.testVoiceLiveEngineFactory?.call(transport) ??
        VoiceLiveEngine(
          transport: transport,
          connectionId: widget.connection.id,
        );
    engine.onDelegation = _onLiveDelegation;
    engine.onError = (message) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(
        context,
      )?.showSnackBar(SnackBar(content: Text(message)));
    };
    engine.onClosed = (reason) {
      if (!mounted) return;
      // The session ended under us (connection lost, closed by the service):
      // drop the turn it was feeding and say why.
      _liveDelegationId = null;
      _liveDelegatedTurnId = null;
      _liveTurnObserved = false;
      _syncClassicWakeForLive();
      setState(() {});
      final notice = voiceLiveEndedNotice(context, reason);
      if (notice != null) {
        ScaffoldMessenger.maybeOf(
          context,
        )?.showSnackBar(SnackBar(content: Text(notice)));
      }
    };
    engine.onStopWord = () {
      if (!mounted) return;
      _syncClassicWakeForLive();
      setState(() {});
    };
    engine.addListener(_onLiveVoiceChanged);
    _liveEngine = engine;
  }

  void _disposeLiveVoice() {
    _liveDelegationId = null;
    _liveDelegatedTurnId = null;
    _liveTurnObserved = false;
    _voiceLiveMode?.removeListener(_onLiveVoiceChanged);
    final engine = _liveEngine;
    _liveEngine = null;
    if (engine != null) {
      engine.removeListener(_onLiveVoiceChanged);
      engine.dispose();
    }
    _liveTransport?.dispose();
    _liveTransport = null;
  }

  /// Ends the live session at once, with no wait for the vendor: this chat is
  /// in the background, hidden or covered, so it may not keep a microphone.
  /// The engine stays bound; Start opens a new session when the chat is back.
  void _teardownLiveVoice(String reason) {
    _liveTeardowns++;
    _liveDelegationId = null;
    _liveDelegatedTurnId = null;
    _liveTurnObserved = false;
    final engine = _liveEngine;
    if (engine == null || !engine.engaged) return;
    unawaited(engine.stopNow(reason));
  }

  void _onLiveVoiceChanged() {
    if (!mounted) return;
    _syncClassicWakeForLive();
    setState(() {});
  }

  void _syncClassicWakeForLive() {
    if (_wake case final wake?) {
      // A stopped session keeps the capture device until the vendor answers
      // its goodbye (or the 15 s fallback): wake resumes only once it is free.
      final busy =
          _voiceComposer.listening ||
          _voiceComposer.starting ||
          (_liveEngine?.active ?? false) ||
          (_liveEngine?.holdsMicrophone ?? false);
      wake.setPausedForVoice(busy);
    }
  }

  List<Map<String, dynamic>> _seedClassicLiveHistory() {
    final source = _normalSnapshot?.displayRows.isNotEmpty == true
        ? _normalSnapshot!.displayRows
        : _messages;
    final turns = <({String role, String text})>[];
    for (final row in source) {
      final role = row['role']?.toString();
      if (role != 'user' && role != 'assistant') continue;
      final text = row['content']?.toString().trim() ?? '';
      if (text.isEmpty) continue;
      turns.add((role: role!, text: text));
    }
    return toLiveHistory(turns);
  }

  Future<void> _startVoiceConversation() async {
    if (isParkedAutomotive) return;
    final mode = _voiceLiveMode;
    // One status read per start: a read made here to choose the engine is
    // handed to it; with a cached status the engine reads a fresh one.
    GptLiveStatus? fresh;
    if (mode != null && !mode.hasStatus) {
      fresh = await mode.refresh();
    }
    if (!mounted) return;
    if (mode != null && mode.selectedMode == 'gpt-live') {
      // A background teardown nulls the engine; rebind on demand so the
      // start button still opens a live conversation after app resume.
      if (_liveEngine == null) _bindLiveVoice();
      final engine = _liveEngine;
      if (mode.liveAvailable && engine != null) {
        if (_wake case final wake?) {
          await wake.pauseForVoice();
        }
        if (!mounted) return;
        final teardowns = _liveTeardowns;
        final started = await engine.start(
          history: _seedClassicLiveHistory(),
          status: fresh,
        );
        if (started && mounted) {
          _syncClassicWakeForLive();
          setState(() {});
          return;
        }
        if (!mounted) return;
        // Cancelled by a teardown (background, hidden or covered chat), not
        // refused by the host: no fallback, and no other microphone path.
        if (teardowns != _liveTeardowns || !identical(engine, _liveEngine)) {
          _syncClassicWakeForLive();
          return;
        }
      }
      final reason =
          mode.unavailableReason ??
          engine?.reason ??
          context.sharedL10n.voice_engine_live_needs_key;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            context.sharedL10n.voice_engine_fallback_chained(reason),
          ),
        ),
      );
    }
    if (handsFreeEnabled.value && _handsFreeSupported) {
      await _startHandsFree();
    } else if (!_voiceComposer.listening && !_voiceComposer.starting) {
      await _startVoiceInput();
    }
  }

  Future<void> _stopLiveVoice() async {
    _liveDelegationId = null;
    _liveDelegatedTurnId = null;
    _liveTurnObserved = false;
    final engine = _liveEngine;
    if (engine == null) return;
    await engine.stop();
    if (!mounted) return;
    _syncClassicWakeForLive();
    setState(() {});
  }

  void _toggleLiveMute() {
    final engine = _liveEngine;
    if (engine == null || !engine.active) return;
    engine.setMuted(!engine.muted);
  }

  void _interruptLiveVoice() {
    if (_streaming && !_stopResponseInFlight) {
      unawaited(_stopResponse());
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
    // Capture owner identity BEFORE any await so a late event after a chat
    // switch, route close or connection/profile change is dropped cleanly.
    final ownerSessionId = widget.session.id;
    final ownerConnectionId = widget.connection.id;
    final ownerProfile = widget.connection.gatewayProfile;
    final ownerAccountEpoch = ConnectionMutationBarrier.capture(
      ownerConnectionId,
    );
    final ownerEngine = engine;
    final ownerEpoch = engine.startEpoch;
    final ownerNormalChat = _normalChat;

    bool stillOwned() =>
        mounted &&
        _voiceElementActive &&
        widget.active &&
        widget.session.id == ownerSessionId &&
        widget.connection.id == ownerConnectionId &&
        widget.connection.gatewayProfile == ownerProfile &&
        ConnectionMutationBarrier.isCurrent(
          ownerConnectionId,
          ownerAccountEpoch,
        ) &&
        identical(_liveEngine, ownerEngine) &&
        ownerEngine.active &&
        ownerEngine.startEpoch == ownerEpoch &&
        identical(_normalChat, ownerNormalChat);

    unawaited(
      _submitClassicLiveDelegation(
        delegationId: id,
        utterance: utterance,
        voiceContext: voiceContext,
        ownerEngine: ownerEngine,
        stillOwned: stillOwned,
      ),
    );
  }

  Future<void> _submitClassicLiveDelegation({
    required String delegationId,
    required String utterance,
    required String voiceContext,
    required VoiceLiveEngine ownerEngine,
    required bool Function() stillOwned,
  }) async {
    if (!stillOwned()) return;
    final l10n = context.sharedL10n;
    if (_streaming || _normalChat?.snapshot.hasActiveTurn == true) {
      if (!_stopResponseInFlight) {
        try {
          await _stopResponse();
        } catch (_) {}
      }
      for (
        var i = 0;
        i < 30 &&
            stillOwned() &&
            (_streaming ||
                _sending ||
                _normalChat?.snapshot.hasActiveTurn == true);
        i++
      ) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    }
    if (!stillOwned()) return;
    _liveDelegationId = delegationId;
    _liveDelegatedTurnId = null;
    _liveTurnObserved = false;
    try {
      await _sendMessage(
        textOverride: utterance,
        promptParams: <String, Object?>{
          'surface': 'voice-live',
          if (voiceContext.isNotEmpty) 'voice_context': voiceContext,
        },
      );
    } catch (_) {
      if (stillOwned() && _liveDelegationId == delegationId) {
        _liveDelegationId = null;
        _liveDelegatedTurnId = null;
        _liveTurnObserved = false;
        ownerEngine.speak(
          l10n.release_chat_live_request_unreachable,
          delegationId: delegationId,
          flush: true,
        );
        ownerEngine.settle();
      }
    }
  }

  void _feedClassicLiveSnapshot(
    NormalGatewayChatSnapshot snapshot,
    List<Map<String, dynamic>> currentRows,
  ) {
    final engine = _liveEngine;
    final delegationId = _liveDelegationId;
    if (engine == null || !engine.active || delegationId == null) return;
    if (_liveDelegatedTurnId == null) {
      if (!snapshot.hasActiveTurn || snapshot.turnId == null) return;
      _liveDelegatedTurnId = snapshot.turnId;
    } else if (snapshot.turnId != _liveDelegatedTurnId) {
      return;
    }

    final parts = <String>[];
    for (final row in currentRows) {
      if (!const {'assistant', 'agent'}.contains(row['role'])) continue;
      final text = row['content']?.toString().trim() ?? '';
      if (text.isNotEmpty) parts.add(text);
    }
    final turnReply = parts.join('\n\n');

    if (snapshot.hasActiveTurn) {
      _liveTurnObserved = true;
      final status = snapshot.status;
      if (status != null &&
          status.kind == 'tool' &&
          status.text.trim().isNotEmpty) {
        engine.think(
          context.sharedL10n.release_chat_live_working(status.text.trim()),
          delegationId: delegationId,
        );
      }
      if (turnReply.isNotEmpty) {
        engine.speak(turnReply, delegationId: delegationId);
      }
      return;
    }

    if (!_liveTurnObserved) return;
    final terminalText =
        snapshot.terminal?.turnId == _liveDelegatedTurnId &&
            (snapshot.terminal?.publicFinalText?.trim().isNotEmpty ?? false)
        ? snapshot.terminal!.publicFinalText!.trim()
        : turnReply;
    if (terminalText.isNotEmpty) {
      engine.speak(terminalText, delegationId: delegationId, flush: true);
    } else if (engine.spokenCursor == 0) {
      engine.think(
        context.sharedL10n.release_chat_live_finished_without_spoken_result,
        delegationId: delegationId,
      );
    }
    _liveDelegationId = null;
    _liveDelegatedTurnId = null;
    _liveTurnObserved = false;
    engine.settle();
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.connection != widget.connection ||
        oldWidget.session.id != widget.session.id) {
      _preview.close();
      _bindWake();
      // The live session belongs to the chat we left; close it and rebind
      // for the new chat, mirroring the NextGen composer teardown.
      if (_liveEngine != null) _bindLiveVoice();
    }
    if (oldWidget.connection.id != widget.connection.id ||
        oldWidget.connection.gatewayProfile !=
            widget.connection.gatewayProfile ||
        oldWidget.session.id != widget.session.id) {
      // Another chat, connection or profile: its cards are not this one's.
      _kanbanPane.currentState?.close();
      _kanbanDock.dispose();
      _kanbanDock = _newKanbanDock();
      _kanbanSeedsSeen = -1;
      _syncKanbanChat();
    }
    if (_slashGateway case final gateway?) {
      _slashController.useRefusals(gateway.slashRefusals);
    }
    _slashController.updateScope(_slashCatalogScope);
    if (oldWidget.connection != widget.connection ||
        oldWidget.session.id != widget.session.id ||
        !widget.active) {
      _revokeVoice(
        oldWidget.session.id != widget.session.id
            ? HandsFreeStopReason.sessionChanged
            : HandsFreeStopReason.connectionChanged,
      );
    }
    final registry = (widget.turnApplicationController ?? _viewController)
        .presentationFor(widget.connection);
    if (!identical(registry, _reasoningRegistry) ||
        !identical(
          registry.chatFor(oldWidget.session.id),
          registry.chatFor(widget.session.id),
        )) {
      _reasoningPresentation.closeReasoningVisit(_reasoningExpansionPins);
      _reasoningRegistry = registry;
      _reasoningPresentation = registry.chatFor(widget.session.id);
      _reasoningExpansionPins = _reasoningPresentation.openReasoningVisit();
      _backgroundReportExpansions = {};
      _detailExpansions = {};
      _delegationExpanded = null;
      _retainedRecoveryOutcomeIds.clear();
      _historyObservedRecoveryOutcomeIds.clear();
    }
  }

  @override
  void deactivate() {
    // A mounted State can already be inactive when a replacement Navigator
    // notifies the global observer. Revoke before leaving the active tree;
    // neither retained callbacks nor pending audio starts may borrow a reparent.
    _voiceElementActive = false;
    _releaseWake();
    handsFreeRouteObserver.removeListener(_onVoiceRouteChanged);
    _revokeVoice(HandsFreeStopReason.routeChanged);
    super.deactivate();
  }

  /// Lets go of the wake word when this chat leaves the tree. Only the chat
  /// bound to it does, so a chat leaving never pauses wake under the one
  /// still showing. The pause runs once this frame is done: notifying the
  /// controller's listeners while the tree is torn down is not allowed, and a
  /// chat that comes straight back (a reparent) keeps it.
  void _releaseWake() {
    final wake = _wake;
    if (wake == null || wake.onWakeDetected != _onWakeDetected) return;
    wake.onWakeDetected = null;
    scheduleMicrotask(() {
      if (!_voiceElementActive && wake.onWakeDetected == null) {
        wake.setAppForeground(false);
      }
    });
  }

  @override
  void activate() {
    super.activate();
    _voiceElementActive = true;
    handsFreeRouteObserver.addListener(_onVoiceRouteChanged);
    _bindWake();
    // Reactivation restores observation, never microphone consent.
  }

  @override
  void dispose() {
    final mountKey = ChatScreen._mountKey(
      widget.connection.id,
      widget.session.id,
    );
    if (identical(ChatScreen._mounted[mountKey], this)) {
      ChatScreen._mounted.remove(mountKey);
    }
    final pendingSubmission = _recoverableSubmissionState;
    if (pendingSubmission != null && !pendingSubmission.isCompleted) {
      pendingSubmission.complete();
    }
    _kanbanDock.dispose();
    // The resume picker's own client (never the injected one).
    _ownedResumeClient?.close();
    _ownedResumeClient = null;
    _manualAudioIntent++;
    // deactivate() already let go of the wake word (see _releaseWake).
    _releaseWake();
    _composerFocus
      ..removeListener(_syncComposerKeyboardEndScroll)
      ..dispose();
    _voiceBound = false;
    handsFreeRouteObserver.removeListener(_onVoiceRouteChanged);
    handsFreeEnabled.removeListener(_onHandsFreeEnabledChanged);
    ConnectionMutationBarrier.removeListener(_onVoiceAccountChanged);
    _handsFree
      ..removeListener(_onVoiceComposerChanged)
      ..dispose();
    _disposeLiveVoice();
    _voiceTurn?.finish(HandsFreeTurnStatus.unknown);
    _voiceTurn = null;
    final ownedSpeaker = _ownedDirectSpeaker;
    _ownedDirectSpeaker = null;
    unawaited(
      _replySpeaker
          .stop()
          .catchError((Object _) {})
          .whenComplete(() => ownedSpeaker?.dispose()),
    );
    final normalChat = _normalChat;
    final reservation = _normalReservation;
    final subscription = _normalSubscription;
    if (subscription != null) normalChat?.unsubscribe(subscription);
    if (reservation != null) normalChat?.cancelPreparation(reservation);
    _openTaskController?.dispose();
    _openTaskController = null;
    WidgetsBinding.instance.removeObserver(this);
    chatDensitySelection.removeListener(_onChatDensityChanged);
    _projectNameRefreshGeneration += 1;
    _archiveReadGeneration += 1;
    pendingNotificationApprovals.removeListener(
      _consumePendingNotificationApproval,
    );
    widget.testDesktopConnectionHook?.handler = null;
    widget.testDesktopAsyncEventHook?.handler = null;
    _savedGatewayNotices[_gatewayNoticeIdentity] = List.unmodifiable(
      _gatewayNotices,
    );
    _voiceRecording
      ..removeListener(_onVoiceComposerChanged)
      ..dispose();
    _voiceDashboard?.close();
    _voiceComposer
      ..removeListener(_onVoiceComposerChanged)
      ..dispose();
    for (final timer in _notificationTimers.values) {
      timer.cancel();
    }
    _releaseClientAfterStreamSettles();
    unawaited(
      _attachmentDraftService.removeAll(
        List<AttachmentDraft>.from(_attachmentDrafts),
      ),
    );
    // Route disposal only unsubscribes; it never closes the app-owned socket.

    final registration = _turnApplicationAsyncEventRegistration;
    if (registration != null) {
      _turnApplicationSession?.removeAsyncEventListener(
        widget.session.id,
        registration,
      );
    }
    final settledRegistration = _turnApplicationSettledRegistration;
    if (settledRegistration != null) {
      _turnApplicationSession?.removeTurnSettledListener(
        widget.session.id,
        settledRegistration,
      );
    }
    final boundRegistration = _turnApplicationBoundRegistration;
    if (boundRegistration != null) {
      _turnApplicationSession?.removeSessionBoundListener(
        widget.session.id,
        boundRegistration,
      );
    }
    _presentation.closeToolVisit(_toolActivityPins);
    _reasoningPresentation.closeReasoningVisit(_reasoningExpansionPins);
    _slashController
      ..removeListener(_onSlashCommandChanged)
      ..dispose();
    CompanionDraft.pending.removeListener(_applyCompanionDraft);
    final draftSaved = _draftWriter.close();
    unawaited(draftSaved.then((_) => _localTurnController?.close()));
    _textController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Closes this screen's HTTP client — but not while a turn is streaming.
  ///
  /// Closing the client aborts the in-flight SSE request, and the API server
  /// treats a client disconnect as an agent interrupt ("SSE client
  /// disconnected" → hard interrupt): the turn and every tool call it had made
  /// were destroyed server-side, so leaving the chat mid-turn came back as a
  /// bare `Operation interrupted.` with the work gone. Detach instead — the turn
  /// finishes on the server, where the transcript is persisted anyway, and the
  /// client closes as soon as the stream settles.
  void _releaseClientAfterStreamSettles() {
    final client = _client;
    final gateway = _gateway;
    if (!gateway.isStreaming) {
      client.close();
      return;
    }
    unawaited(
      gateway
          .whenStreamSettles()
          // Backstop: a stream that never settles must not hold the client
          // open for the life of the process.
          .timeout(_detachedStreamCloseDeadline, onTimeout: () {})
          .whenComplete(client.close),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final foreground = state == AppLifecycleState.resumed;
    _wake?.setAppForeground(foreground);
    if (_voiceForeground != foreground) _voiceForegroundEpoch++;
    _voiceForeground = foreground;
    if (!_voiceForeground) {
      _revokeVoice(HandsFreeStopReason.background);
    }
    // The live session is tied to the foreground screen: close the peer and
    // stop the tracks on a real background. `inactive` alone is not one: the
    // OS microphone prompt on first use puts the app there while the session
    // it is granting is still starting.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _teardownLiveVoice('background');
    }
    if ((defaultTargetPlatform == TargetPlatform.windows &&
            state == AppLifecycleState.inactive) ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      if (_sending || _streaming) _companionLeftDuringTurn = true;
      _appInBackground = true;
      _normalSession?.setLifecycle(background: true);
      // Persist the draft on the way out: a process kill must not lose it.
      unawaited(_draftWriter.flush());
    } else if (state == AppLifecycleState.resumed) {
      _appInBackground = false;
      if (_companionLeftDuringTurn && !_sending && !_streaming) {
        _companionLeftDuringTurn = false;
        _companionUnread = true;
        if (mounted) setState(() {});
      }
      if (_normalChat?.snapshot.reconciling == true) {
        widget.testDesktopSessionEnsured?.call();
      }
      _normalSession?.setLifecycle(background: false);
      if (_normalChat?.snapshot.turnId != null) return;
      if (_desktopGateway != null) unawaited(_ensureDesktopSession());
      if (_turnApplicationSession != null) unawaited(_recoverPendingTurn());
    }
  }

  Future<void> _initializeChat() async {
    await _fetchMessages();
    if (!mounted) return;
    await _recoverPendingTurn(allowLegacyFallback: true);
  }

  /// Desktop gateway connection-state transitions.
  ///
  /// A deliberate connection switch or a dropped socket detaches the WS
  /// mid-turn. The gateway no longer cancels the running turn at the
  /// orphan-reap grace (activity-staleness gate); it completes detached
  /// and the client re-resumes the stored session on the fresh socket.
  /// Say so — the bare silence read as "your reply was lost" (issue
  /// #94196's `Operation interrupted.` UX) — and remember the drop so the
  /// eventual `connected` transition actually re-binds and refetches.
  void _onDesktopConnectionChanged(DesktopConnectionState state) {
    if (!mounted) return;
    final changed = _desktopConnectionState != state;
    setState(() => _desktopConnectionState = state);
    // A new socket is a new profile catalogue.
    if (changed) _slashController.invalidate();
    if (changed && state == DesktopConnectionState.connected) {
      unawaited(_refreshProjectName());
      _consumePendingNotificationApproval();
      unawaited(_kanbanDock.refresh());
    }
  }

  Future<void> _ensureDesktopSession() async {
    if (_normalChat?.snapshot.hasActiveTurn == true) {
      _normalChat!.requestRecovery();
      return;
    }
    if (!shouldEstablishLegacyDesktopSession(
      widget.session,
      legacyTransportFallback: _legacyTransportFallback,
    )) {
      return;
    }
    final gateway = _desktopGateway;
    widget.testDesktopSessionEnsured?.call();
    if (gateway == null) {
      unawaited(_refreshProjectName());
      return;
    }
    try {
      await gateway.ensureSession(
        _normalLocalSessionKey,
        workingDirectory: widget.projectWorkingDirectory,
      );
    } catch (_) {
      // The composer remains available. The next send retries with a fresh
      // single-use ticket and surfaces an actionable error if it still fails.
      return;
    }
    unawaited(_refreshProjectName());
  }

  void _editAndResend(String text) {
    _textController
      ..text = text
      ..selection = TextSelection.collapsed(offset: text.length);
    FocusScope.of(context).nextFocus();
  }

  /// Whether Retry can regenerate here: the Desktop gateway's stock owner
  /// truncates (Desktop's `runReload`). A recovery-v2 chat regenerates
  /// through it too: the v2 submit carries no truncation, and the stock
  /// owner shares this chat's Desktop socket and live session (the one its
  /// model switch and commands already use). REST cannot truncate.
  bool get _canRegenerate => _desktopGateway != null && _normalChat != null;

  /// Retry of a turn the gateway accepted, as Desktop's regenerate
  /// (`runReload` → `runRewindSubmit`): a live turn is interrupted first,
  /// then the same prompt goes again with `confirm_truncate` and the turn's
  /// durable row, so it replaces the failed turn instead of appending a
  /// duplicate. Never touches the composer (a newer draft stays), and never
  /// falls back to a plain resend: without a durable row it says so and
  /// sends nothing. Owner-scoped: a screen that has gone sends nothing.
  Future<void> _retryPrompt(String text) async {
    if (_archiving ||
        _preparingSend ||
        _pendingReattachResync ||
        text.trim().isEmpty) {
      return;
    }
    final l10n = context.sharedL10n;
    final gateway = _desktopGateway;
    final session = _normalLocalSessionKey;
    if (!_canRegenerate || !gateway!.hasLiveSession(session)) {
      _showRetryNotice(l10n.composer_retry_unavailable);
      return;
    }
    if (_streaming) {
      // runRewindSubmit's interruptFirst (NextGen's retryLast too): stop the
      // live turn, then wait for it to settle before replacing it.
      await _stopResponse();
      for (var i = 0; i < 50 && mounted && _hasLiveTurn; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      if (!mounted) return;
    }
    if (_sending || _streaming || _hasLiveTurn) return;
    final target = await resolveRegenerateTarget(
      rpc: gateway.requestSessionRpc,
      sessionId: session,
      text: text,
    );
    if (!mounted) return;
    if (target == null) {
      _showRetryNotice(l10n.composer_retry_not_found);
      return;
    }
    if (_sending || _streaming || _preparingSend) return;
    await _sendMessage(
      textOverride: text.trim(),
      // runRewindSubmit's params for the resolved row (Desktop's runReload).
      promptParams: regenerateSubmitParams(target.rowId),
    );
  }

  /// The bubble's Regenerate (message sheet and quick action), offered on
  /// every assistant reply as it always was. Where the transport truncates
  /// ([_canRegenerate]) it replaces the turn ([_retryPrompt]). Elsewhere
  /// (REST, an owner with no Desktop client) there is nothing to replace
  /// it with, so it asks again as it always has there: the reply's prompt
  /// goes out as a new turn. The composer is not touched either way (a
  /// newer draft stays, staged attachments stay staged).
  Future<void> _regenerateResponse(String text) async {
    if (_canRegenerate) return _retryPrompt(text);
    if (_archiving ||
        _sending ||
        _streaming ||
        _preparingSend ||
        _pendingReattachResync ||
        text.trim().isEmpty) {
      return;
    }
    await _sendMessage(textOverride: text.trim());
  }

  void _showRetryNotice(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  /// A saved row's durable id (the REST history's `id`, the gateway's
  /// `row_id`). Rows of this visit have none until history covers them.
  static int? _durableRowId(Map<String, dynamic> row) {
    final id = row['id'];
    return id is int && id > 0 ? id : null;
  }

  /// User rows the transcript currently renders, used only for positions in
  /// the rewind/edit confirm path. The durable row id is resolved against
  /// `session.history` on the gateway, never from these client-side rows.
  List<Map<String, dynamic>> get _rewindRows {
    final received = _normalSnapshot?.displayRows ?? const [];
    return received.isNotEmpty ? received : _messages;
  }

  /// Best-effort visible-user ordinal of a stored prompt plus whether later
  /// user turns would be archived by cutting at it (Desktop's
  /// `visibleUserOrdinal` / `confirmIfDeepCut`). Identical prompts resolve to
  /// their most recent occurrence; the gateway content lookup has the last
  /// word on the durable target.
  ({int ordinal, bool laterTurns}) _userTurnPosition(String content) {
    final wanted = content.trim();
    var count = 0;
    var matched = -1;
    for (final row in _rewindRows) {
      if (row['role'] != 'user') continue;
      if (_transcriptText(row).trim() == wanted) matched = count;
      count++;
    }
    return (
      ordinal: matched < 0 ? count : matched,
      laterTurns: matched >= 0 && matched < count - 1,
    );
  }

  /// Edit and Restore of a stored turn, with Desktop's rewind semantics
  /// (rewind.ts `planEdit` / `planRestore` → `runRewindSubmit`). The
  /// session's full saved transcript (`session.history`) names the durable
  /// row (the bubble's own row id first) and says whether the cut archives
  /// later user turns: the rows on screen are a paged tail and cannot. A
  /// cut that does asks first; nothing is sent before the answer. A live
  /// turn is interrupted, then the turn is submitted once. The composer
  /// draft is never consumed (`textOverride`).
  Future<void> _submitRewindTurn({
    required String text,
    required String sourceText,
    required int? bubbleRowId,
    required bool restore,
  }) async {
    final l10n = context.sharedL10n;
    final gateway = _desktopGateway;
    final session = _normalLocalSessionKey;
    if (!_canRegenerate ||
        gateway == null ||
        !gateway.hasLiveSession(session)) {
      _showRetryNotice(l10n.composer_retry_unavailable);
      return;
    }
    final position = _userTurnPosition(sourceText);
    final history = await RewindHistory.read(
      gateway.requestSessionRpc,
      session,
    );
    if (!mounted) return;
    final rowId = history == null
        ? bubbleRowId
        : history.rowFor(
            bubbleRowId: bubbleRowId,
            sourceText: sourceText,
            expectedOrdinal: position.ordinal,
          );
    if (rowId == null && history != null && history.hasRowIds) {
      // A saved transcript that does not hold this turn yet: a cut would be
      // a guess and a plain resend a duplicate. Say so; send nothing.
      _showRetryNotice(l10n.rewind_target_unsaved);
      return;
    }
    final laterTurns = rowId != null && history != null
        ? history.laterUserTurns(rowId)
        : position.laterTurns;
    if (laterTurns || restore) {
      final confirmed = await showRestoreTurnConfirm(
        context,
        body: restore ? null : l10n.edit_turn_later_turns_body,
      );
      if (!mounted || !confirmed) return;
    }
    final normal = _normalChat;
    if (_streaming || normal?.snapshot.hasActiveTurn == true) {
      // Edit interrupts a live turn on purpose (Desktop's
      // planEditAfterConfirm): stop it, then wait for it to settle. A turn
      // the owner still runs after this screen stopped streaming it (a
      // reattached or background turn) is interrupted through the owner.
      if (_streaming) {
        await _stopResponse();
      } else {
        try {
          await normal!.interrupt();
        } catch (_) {
          // Still live below: the notice says nothing was sent.
        }
      }
      for (var i = 0; i < 50 && mounted && _hasLiveTurn; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      if (!mounted) return;
    } else {
      // A detached turn may still run on the gateway: best-effort
      // interrupt before the rewind, as Desktop's runRewindSubmit.
      try {
        await gateway.interruptPrompt(sessionId: session);
      } catch (_) {
        // The submit still gates on the gateway's own busy state.
      }
      if (!mounted) return;
    }
    if (_hasLiveTurn) {
      // Never a silent no-op: say why nothing was sent.
      _showRetryNotice(l10n.rewind_turn_busy);
      return;
    }
    await _sendMessage(
      textOverride: text.trim(),
      promptParams: buildRewindParams(
        RewindPlan.resolved(
          rowId: rowId,
          sourceText: sourceText,
          originalOrdinal: position.ordinal,
        ),
        confirmDeepTruncate: laterTurns,
      ),
      onAccepted: rowId == null
          ? null
          : () => _applyAcceptedRewind(rowId, through: history?.maxRowId),
    );
  }

  /// The gateway accepted a rewind at [rowId]: the archived turns leave the
  /// transcript at once (Desktop's `applyRewindOptimistic`), and the next
  /// history read reconciles.
  void _applyAcceptedRewind(int rowId, {int? through}) {
    if (!mounted) return;
    // The owner first: its snapshot must not hand the archived rows back.
    _normalChat?.applyAcceptedRewind(rowId, through: through);
    _historyWindow.applyRewind(rowId, through: through);
    _historyWindowRevision++;
    _extractToolMessages(_historyWindow.rows, replacePresentation: true);
    setState(() => _messages = _restHistoryForPresentation());
  }

  /// Re-run a stored prompt with edited text. Cancel or no change sends
  /// nothing; the edited text replaces the turn, never appends a new one.
  Future<void> _editAndResendTurn(String content, {int? rowId}) async {
    // A live turn does not block the edit: it is interrupted on confirm.
    if (_archiving || _preparingSend) return;
    final edited = await showDialog<String>(
      context: context,
      builder: (_) => EditTurnDialog(initialText: content),
    );
    if (!mounted || edited == null) return;
    final text = edited.trim();
    if (text.isEmpty || text == content.trim()) return;
    await _submitRewindTurn(
      text: text,
      sourceText: content.trim(),
      bubbleRowId: rowId,
      restore: false,
    );
  }

  /// Restore a stored prompt to this checkpoint after explicit confirmation.
  Future<void> _restoreUserTurn(String content, {int? rowId}) async {
    if (_archiving || _preparingSend) return;
    await _submitRewindTurn(
      text: content.trim(),
      sourceText: content.trim(),
      bubbleRowId: rowId,
      restore: true,
    );
  }

  /// The newest prompt the person sent here, for Retry.
  String? get _lastPromptText {
    for (final rows in [
      _normalSnapshot?.displayRows ?? const <Map<String, dynamic>>[],
      _messages,
    ]) {
      for (final row in rows.reversed) {
        if (row['role'] != 'user') continue;
        final text = row['content']?.toString().trim() ?? '';
        if (text.isNotEmpty) return text;
      }
    }
    return null;
  }

  bool get _canRename =>
      !_renaming &&
      !_archiving &&
      !_sending &&
      !_streaming &&
      !_pendingReattachResync &&
      (!widget.session.isLocalDraft ||
          _storedSessionId != null ||
          _storedSessionKey != widget.session.id ||
          _messages.isNotEmpty);

  String get _archiveSessionId => _storedSessionId ?? _storedSessionKey;

  bool get _hasStoredArchiveTarget =>
      !widget.session.isLocalDraft ||
      _storedSessionId != null ||
      _storedSessionKey != widget.session.id ||
      _archiveStateSessionId == _archiveSessionId;

  bool get _canArchive =>
      _hasStoredArchiveTarget &&
      (_normalSession == null || _normalSessionReady) &&
      !_archiving &&
      !_renaming &&
      !_preparingSend &&
      !_sending &&
      !_streaming &&
      !_recoveringTurn &&
      !_pendingReattachResync;

  /// Navigation metadata can precede a canonical binding or an edit on another
  /// device. Read exact stored metadata once per identity/open, without ever
  /// resuming/creating a chat. A pre-write read cannot undo a confirmed save.
  Future<void> _refreshArchiveState() async {
    if (!mounted || _archiving) return;
    final sessionId = _archiveSessionId;
    if (_archiveReadSessionId == sessionId) return;
    if (!_hasStoredArchiveTarget && _messages.isEmpty) return;
    _archiveReadSessionId = sessionId;
    final generation = ++_archiveReadGeneration;
    final revision = _archiveRevision;
    try {
      final saved = await _client.getSession(sessionId);
      if (!mounted ||
          generation != _archiveReadGeneration ||
          revision != _archiveRevision ||
          sessionId != _archiveSessionId) {
        return;
      }
      if (saved['id'] != sessionId || saved['archived'] is! bool) return;
      setState(() {
        _sessionArchived = saved['archived'] as bool;
        _archiveStateSessionId = sessionId;
      });
    } catch (_) {
      // Older gateways may lack metadata. Keep navigation-time state; the
      // mutation still requires an independently verified server read-back.
    }
  }

  Future<void> _setSessionArchived(
    bool archived, {
    String? expectedSessionId,
  }) async {
    if (!mounted || !_canArchive) return;
    final sessionId = _archiveSessionId;
    if (expectedSessionId != null && expectedSessionId != sessionId) return;
    setState(() => _archiving = true);
    // Invalidate pending metadata before the first await, including failures.
    _archiveReadGeneration++;
    try {
      final archiver = widget.sessionArchiver;
      final saved = await (archiver != null
          ? archiver(sessionId, archived)
          : _client.setSessionArchived(
              sessionId: sessionId,
              archived: archived,
            ));
      if (!mounted || sessionId != _archiveSessionId) return;
      setState(() {
        _sessionArchived = saved;
        _archiveStateSessionId = sessionId;
        _archiveReadSessionId = sessionId;
        _archiveRevision++;
      });
      // The owner may need to clear a device-local expiry before Unarchive
      // becomes visible. Do not announce success ahead of that reconciliation.
      await widget.onArchiveChanged?.call(sessionId, saved);
      if (!mounted || sessionId != _archiveSessionId) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            saved ? context.l10n.chat_archived : context.l10n.chat_unarchived,
          ),
        ),
      );
    } catch (error) {
      if (!mounted || sessionId != _archiveSessionId) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.could_not_update_chat_archive(error)),
          action: SnackBarAction(
            label: context.l10n.retry,
            onPressed: () => unawaited(
              _setSessionArchived(archived, expectedSessionId: sessionId),
            ),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _archiving = false);
    }
  }

  Future<void> _renameSession() async {
    if (!_canRename) return;
    setState(() => _renaming = true);
    try {
      // Let the popup route finish closing before presenting another route.
      await Future<void>.delayed(kThemeAnimationDuration);
      if (!mounted) return;
      final title = await showSessionNameDialog(
        context: context,
        title: context.l10n.rename_chat,
        initialValue: _sessionTitle,
        actionLabel: context.l10n.rename,
      );
      if (!mounted || title == null || title == _sessionTitle.trim()) return;
      final savedTitle = await _client.renameSession(
        sessionId: _storedSessionId ?? _storedSessionKey,
        title: title,
      );
      if (mounted) {
        _normalChat?.title = savedTitle;
        setState(() => _sessionTitle = savedTitle);
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.could_not_rename_chat(error))),
      );
    } finally {
      if (mounted) setState(() => _renaming = false);
    }
  }

  Future<void> _showReceivedOutputDetails() async {
    // Let the chat-actions popup close before presenting another route.
    await Future<void>.delayed(kThemeAnimationDuration);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(context.l10n.received_output_heading),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.received_output_explanation),
            const SizedBox(height: 12),
            Text(context.l10n.received_output_lifetime),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.close),
          ),
        ],
      ),
    );
  }

  Future<void> _exportConversation() async {
    final buffer = StringBuffer('# $_sessionTitle\n\n');
    if (_normalChat != null) {
      for (final section in _normalDisplaySections(verbose: true)) {
        if (section.source == ChatDisplaySource.auxiliary) continue;
        final received = section.source == ChatDisplaySource.received;
        buffer.writeln(
          '## ${received ? context.l10n.received_output_heading : context.l10n.saved_history_heading}\n',
        );
        if (received) {
          buffer.writeln('${context.l10n.received_output_explanation}\n');
          buffer.writeln('${context.l10n.received_output_lifetime}\n');
        }
        for (final item in section.items) {
          final fact = section.outcomes[chatDisplayItemIdentity(item)];
          if (fact != null) {
            buffer.writeln('${_receivedOutcomeLabel(fact.outcome)}\n');
          }
          if (item is Map<String, dynamic>) {
            _writeExportMessage(buffer, item, localPrompt: received);
          } else if (item is ChatReasoningItem) {
            buffer.writeln('${item.text}\n');
          } else if (item is ChatToolActivityGroup) {
            for (final tool in item.activities) {
              buffer.writeln('${tool.displayName}: ${tool.statusLabel}');
            }
            buffer.writeln();
          }
        }
      }
    } else {
      // Export the same public projection as the transcript on every transport.
      // Raw history can contain hidden/model-only rows and explicit empty
      // replacements; neither is permission to expose physical model content.
      for (final item in buildChatDisplayItems(messages: _messages)) {
        if (item is Map<String, dynamic>) _writeExportMessage(buffer, item);
      }
    }
    await SharePlus.instance.share(
      ShareParams(subject: _sessionTitle, text: buffer.toString().trim()),
    );
  }

  void _openHistory() {
    final gateway = _desktopGateway;
    if (gateway == null || !mounted) return;
    final id = _fileSessionId;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SessionHistoryPage(
          owner: gateway.workspace,
          storedSessionId: id,
          onRewound: (text) {
            if (!mounted) return;
            unawaited(_fetchMessages(focusSavedHistory: true));
            _editComposerAsUser(text);
          },
          onRestored: () {
            if (!mounted) return;
            unawaited(_fetchMessages(focusSavedHistory: true));
          },
          onOpenSession: widget.singleSession && widget.onOpenSession == null
              ? null
              : _openStoredSessionFromHistory,
        ),
      ),
    );
  }

  void _openStoredSessionFromHistory(String sessionId, {String? title}) {
    if (!mounted) return;
    final now = DateTime.now().millisecondsSinceEpoch / 1000.0;
    final target = Session(
      id: sessionId,
      title: (title == null || title.trim().isEmpty) ? sessionId : title.trim(),
      model: widget.session.model,
      source: 'desktop',
      messageCount: 1,
      isActive: false,
      preview: '',
      startedAt: now,
      isLocalDraft: false,
    );
    final hostOpen = widget.onOpenSession;
    if (hostOpen != null) {
      unawaited(hostOpen(target));
      return;
    }
    if (widget.singleSession) return;
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(
          connection: widget.connection,
          session: target,
          projectName: widget.projectName,
          projectWorkingDirectory: widget.projectWorkingDirectory,
          turnApplicationController: widget.turnApplicationController,
          // The same open path as this chat (main's /resume rule: every
          // ChatScreen is built with one). Null here, as this branch only
          // runs for a chat whose host gave it none.
          onOpenSession: widget.onOpenSession,
          onArchiveChanged: widget.onArchiveChanged,
          sessionArchiver: widget.sessionArchiver,
          testTurnApplicationSession: widget.testTurnApplicationSession,
          testApiClient: widget.testApiClient,
          testAttachmentDraftService: widget.testAttachmentDraftService,
          testRemotePromptSubmit: widget.testRemotePromptSubmit,
          testNormalResume: widget.testNormalResume,
          testServerFilePicker: widget.testServerFilePicker,
          testRemoteAttachmentUpload: widget.testRemoteAttachmentUpload,
          testComposerDraftReader: widget.testComposerDraftReader,
          testVoiceComposerAdapter: widget.testVoiceComposerAdapter,
          testVoiceRecorder: widget.testVoiceRecorder,
          testVoiceTranscription: widget.testVoiceTranscription,
          testHandsFreePlatform: widget.testHandsFreePlatform,
          testVoiceReplySpeaker: widget.testVoiceReplySpeaker,
          testTurnNotifications: widget.testTurnNotifications,
          testProjectOverviewLoader: widget.testProjectOverviewLoader,
          testMediaFilesClient: widget.testMediaFilesClient,
          testTaskHistorySource: widget.testTaskHistorySource,
          testSlashGateway: widget.testSlashGateway,
        ),
      ),
    );
  }

  void _writeExportMessage(
    StringBuffer buffer,
    Map<String, dynamic> message, {
    bool localPrompt = false,
  }) {
    final role = message['role']?.toString();
    if (role != 'user' && role != 'assistant' && role != 'agent') return;
    if (!isPublicDeliveryMessage(message)) return;
    final content = stripToolResultText(
      messageContentToText(
        message.containsKey('_display_content')
            ? message['_display_content']
            : AndroidPromptContext.displayContent(
                message,
                publicDeliveryContent(message),
              ),
      ),
    ).trim();
    if (content.isEmpty) return;
    buffer
      ..writeln(
        role == 'user'
            ? (localPrompt
                  ? context.l10n.local_prompt_context
                  : context.l10n.you_heading)
            : context.l10n.hermes_heading,
      )
      ..writeln()
      ..writeln(content)
      ..writeln();
  }

  bool get _voiceRouteCurrent =>
      mounted &&
      _voiceElementActive &&
      widget.active &&
      _voiceRoute?.isCurrent == true &&
      handsFreeRouteObserver.permits(_voiceRoute);

  HandsFreeAuthority _captureVoiceAuthority() => HandsFreeAuthority(
    routeToken: _voiceRouteToken,
    connectionId: widget.connection.id,
    connectionMutationEpoch: ConnectionMutationBarrier.capture(
      widget.connection.id,
    ),
    sessionId: widget.session.id,
    foregroundEpoch: _voiceForegroundEpoch,
    controllerGeneration: _handsFree.generation + 1,
  );

  bool _voiceAccountCurrent() {
    try {
      return mapEquals(
        _notificationApprovalOrigin,
        NotificationApprovalAuthority.origin(widget.connection),
      );
    } catch (_) {
      return false;
    }
  }

  bool _isVoiceAuthorityCurrent(HandsFreeAuthority authority) =>
      mounted &&
      _voiceRouteCurrent &&
      _voiceForeground &&
      identical(authority.routeToken, _voiceRouteToken) &&
      authority.connectionId == widget.connection.id &&
      _voiceAccountCurrent() &&
      identical(authority.connectionMutationEpoch, _voiceAccountEpoch) &&
      authority.sessionId == widget.session.id &&
      authority.foregroundEpoch == _voiceForegroundEpoch &&
      ConnectionMutationBarrier.isCurrent(
        authority.connectionId,
        authority.connectionMutationEpoch,
      );

  bool _canStartHandsFree(HandsFreeAuthority authority) =>
      !_voiceRecording.recording &&
      !_voiceRecording.busy &&
      !_voiceRecording.hasDraft &&
      _isVoiceAuthorityCurrent(authority) &&
      _voiceReplyEnabled &&
      !_voiceComposer.listening &&
      !_voiceComposer.starting &&
      _textController.text.isEmpty &&
      _attachmentDrafts.isEmpty &&
      !_transcriptLoadBlocksComposer &&
      !_preparingSend &&
      !_sending &&
      !_streaming &&
      !_changingModel &&
      !_loadingModelOptions &&
      !_archiving &&
      !_renaming &&
      !_recoveringTurn &&
      !_pendingReattachResync &&
      !_stopResponseInFlight &&
      !_midTurnSendInFlight &&
      _activeClientTurnId == null &&
      _normalChat?.snapshot.hasActiveTurn != true &&
      _normalChat?.snapshot.phase != NormalGatewayTurnPhase.reconciledUnknown &&
      (_normalSession == null || _normalSessionReady);

  Future<bool> _prepareHandsFreeAudio() async {
    if (_voiceRecording.recording ||
        _voiceRecording.busy ||
        _voiceRecording.hasDraft) {
      return false;
    }
    await _voiceSetup;
    if (!_voicePlaybackConfigured) return false;
    await _voiceComposer.settle();
    final adapter = _voiceComposer.adapter;
    if (adapter is AndroidVoiceComposerAdapter) {
      await adapter.cancel();
      await adapter.settle();
    }
    await _replySpeaker.stop();
    if (!await _replySpeaker.prepare()) return false;
    return mounted && !_voiceComposer.listening && !_voiceComposer.starting;
  }

  void _revokeVoice(HandsFreeStopReason reason) {
    // GPT-Live follows hands-free: a chat that is offstage (active: false),
    // covered by another route, switched or leaving the tree may not keep a
    // live microphone. The app lifecycle is handled where it arrives,
    // because `inactive` alone (the OS microphone prompt) is no background.
    if (reason != HandsFreeStopReason.background) {
      _teardownLiveVoice(reason.name);
    }
    if (!_voiceRouteCurrent ||
        !_voiceForeground ||
        !_voiceAccountCurrent() ||
        !ConnectionMutationBarrier.isCurrent(
          widget.connection.id,
          _voiceAccountEpoch,
        )) {
      scheduleMicrotask(() {
        if (!mounted) return;
        if (!_voiceRouteCurrent ||
            !_voiceForeground ||
            !_voiceAccountCurrent() ||
            !ConnectionMutationBarrier.isCurrent(
              widget.connection.id,
              _voiceAccountEpoch,
            )) {
          unawaited(_voiceRecording.background());
        }
      });
    }
    if (!_voiceBound) return;
    _manualAudioIntent++;
    _handsFree.revoke(reason);
    if (_voiceComposer.listening || _voiceComposer.starting) {
      unawaited(_voiceComposer.cancel());
    }
    _voiceTurn?.finish(HandsFreeTurnStatus.unknown);
    _voiceTurn = null;
    unawaited(_replySpeaker.stop().catchError((Object _) {}));
  }

  void _onVoiceRouteChanged() {
    if (_voiceRouteCurrent && _voiceForeground && _voiceAccountCurrent()) {
      _voiceRecording.foreground();
    }
    if (!_voiceRouteCurrent) _revokeVoice(HandsFreeStopReason.routeChanged);
  }

  void _onVoiceAccountChanged() {
    if (!ConnectionMutationBarrier.isCurrent(
      widget.connection.id,
      _voiceAccountEpoch,
    )) {
      scheduleMicrotask(() {
        if (!mounted) return;
        if (!_voiceRouteCurrent ||
            !_voiceForeground ||
            !_voiceAccountCurrent() ||
            !ConnectionMutationBarrier.isCurrent(
              widget.connection.id,
              _voiceAccountEpoch,
            )) {
          unawaited(_voiceRecording.background());
        }
      });
    }
    final authority = _handsFree.authority;
    if ((authority != null ||
            _voiceComposer.listening ||
            _voiceComposer.starting) &&
        !ConnectionMutationBarrier.isCurrent(
          widget.connection.id,
          _voiceAccountEpoch,
        )) {
      _revokeVoice(HandsFreeStopReason.accountMutation);
    }
  }

  void _onHandsFreeEnabledChanged() {
    if (!handsFreeEnabled.value) {
      // The user turned the feature off in Settings: revoke consent immediately
      // and let the composer/control surface disappear. Disabling never starts
      // capture, and re-enabling never restarts it.
      if (_handsFree.active || _handsFree.state == HandsFreeState.error) {
        unawaited(
          _handsFree
              .stop(reason: HandsFreeStopReason.user)
              .catchError((Object _) {}),
        );
      }
    }
    // Rebuild on both directions: the control surface must reappear when the
    // feature is switched back on.
    if (mounted) setState(() {});
  }

  Future<void> _startHandsFree() async {
    if (!handsFreeEnabled.value || !_handsFreeSupported) return;
    final authority = _captureVoiceAuthority();
    if (!_canStartHandsFree(authority)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.hands_free_start_blocked)),
      );
      return;
    }
    final setup = await showHandsFreeSetup(
      context,
      followupTimeout: _followupTimeout,
    );
    if (!mounted || setup == null || !_isVoiceAuthorityCurrent(authority)) {
      return;
    }
    await _setFollowupSeconds(setup);
    if (!mounted || !_isVoiceAuthorityCurrent(authority)) return;
    await _handsFree.start(
      authority: authority,
      followupTimeout: _followupTimeout,
    );
  }

  Future<void> _setFollowupSeconds(int seconds) async {
    if (seconds < 0 || seconds > 30) return;
    await _handsFree.stop(reason: HandsFreeStopReason.user);
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setInt('hands_free_followup_timeout_ms', seconds * 1000)) {
      return;
    }
    if (mounted) setState(() => _followupTimeout = Duration(seconds: seconds));
  }

  Future<HandsFreeSubmittedTurn?> _submitHandsFreePrompt(
    HandsFreePrompt prompt,
  ) async {
    if (!_handsFree.isCurrent(prompt.authority) ||
        !_canStartHandsFree(prompt.authority) ||
        _voiceTurn != null) {
      return null;
    }
    final binding = _voiceTurn = _HandsFreeTurnBinding(prompt);
    unawaited(() async {
      try {
        await _sendMessage(handsFreePrompt: prompt, voiceBinding: binding);
      } catch (_) {
        binding.finish(HandsFreeTurnStatus.failed);
      } finally {
        if (!binding.admitted.isCompleted) binding.admitted.complete(false);
      }
    }());
    if (!await binding.admitted.future) {
      if (identical(_voiceTurn, binding)) _voiceTurn = null;
      return null;
    }
    return HandsFreeSubmittedTurn(
      clientTurnId: binding.clientTurnId,
      settled: binding.terminal.future,
    );
  }

  Future<HandsFreeSpeechOutcome> _speakHandsFreeReply(
    HandsFreeReply reply,
  ) async {
    if (!_voiceReplyEnabled || !_handsFree.isCurrent(reply.authority)) {
      return HandsFreeSpeechOutcome.canceled;
    }
    return _replySpeaker.speak(
      reply.text,
      isCurrent: () =>
          _voiceReplyEnabled && _handsFree.isCurrent(reply.authority),
    );
  }

  void _bindRecoveryVoiceTurn(
    _HandsFreeTurnBinding binding,
    GatewayTurnRecoveryState state,
  ) {
    if (binding.transportTurnId != null &&
        binding.transportTurnId != state.clientTurnId) {
      return;
    }
    binding.transportTurnId = state.clientTurnId;
    if (!binding.admitted.isCompleted) {
      // Recovery-v2 already allocates a stable client turn ID. Publish that
      // exact ID, never a second voice wire identity or a history-derived one.
      binding.clientTurnId = state.clientTurnId;
      binding.admitted.complete(true);
    }
  }

  void _finishVoiceTurn(
    _HandsFreeTurnBinding binding,
    HandsFreeTurnStatus status, [
    String? publicFinal,
  ]) {
    binding.finish(status, publicFinal);
    if (identical(_voiceTurn, binding)) _voiceTurn = null;
  }

  void _observeVoiceNormalTerminal(NormalGatewayChatSnapshot snapshot) {
    final binding = _voiceTurn;
    if (binding == null ||
        binding.transportTurnId == null ||
        snapshot.turnId != binding.transportTurnId) {
      return;
    }
    if (snapshot.pendingInput.isNotEmpty) {
      _finishVoiceTurn(binding, HandsFreeTurnStatus.needsInput);
      return;
    }
    if (snapshot.phase == NormalGatewayTurnPhase.reconciling ||
        snapshot.phase == NormalGatewayTurnPhase.reconciledUnknown) {
      _finishVoiceTurn(binding, HandsFreeTurnStatus.unknown);
      return;
    }
    final terminal = snapshot.terminal;
    if (terminal == null || terminal.turnId != binding.transportTurnId) return;
    _finishVoiceTurn(
      binding,
      terminal.completed == true
          ? HandsFreeTurnStatus.completed
          : terminal.completed == false
          ? HandsFreeTurnStatus.failed
          : HandsFreeTurnStatus.unknown,
      terminal.publicFinalText,
    );
  }

  Future<void> _initVoice({bool requestSpeechPermission = false}) async {
    if (isParkedAutomotive) return;
    // Also called from initState, before inherited lookups are safe.
    final l10n = serviceStrings;
    try {
      final prefs = await SharedPreferences.getInstance();
      final voiceName = prefs.getString('voice_name');
      final voiceLocale = prefs.getString('voice_locale');
      if (mounted) {
        setState(
          () => _followupTimeout = Duration(
            milliseconds:
                (prefs.getInt('hands_free_followup_timeout_ms') ?? 10000).clamp(
                  0,
                  30000,
                ),
          ),
        );
      }

      if (widget.testVoiceComposerAdapter == null) {
        if (voiceName != null && voiceName.isNotEmpty) {
          if (voiceName == voiceLocale) {
            if (await _flutterTts.setLanguage(voiceName) != 1) {
              throw UiMessageException(
                l10n.release_chat_reply_language_unavailable,
              );
            }
          } else {
            if (await _flutterTts.setVoice({
                  'name': voiceName,
                  'locale': voiceLocale ?? '',
                }) !=
                1) {
              throw UiMessageException(
                l10n.release_chat_reply_voice_unavailable,
              );
            }
          }
          _sttLocaleId = voiceLocale?.replaceAll('-', '_');
        } else {
          _sttLocaleId = null;
        }
        if (await _flutterTts.setSpeechRate(0.48) != 1 ||
            await _flutterTts.setVolume(1.0) != 1 ||
            await _flutterTts.setPitch(1.0) != 1) {
          throw UiMessageException(
            l10n.release_chat_reply_voice_configuration_unavailable,
          );
        }
      } else {
        _sttLocaleId = voiceLocale?.replaceAll('-', '_');
      }

      _voicePlaybackConfigured = true;
      await _voiceComposer.initialize(
        requestPermission: requestSpeechPermission,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _voiceStatus = context.l10n.voice_setup_failed(e));
    }
  }

  Future<void> _startVoiceInput() async {
    if (isParkedAutomotive) return;
    final intent = ++_manualAudioIntent;
    if (_streaming ||
        _sending ||
        _preparingPaste ||
        _startingVoiceInput ||
        _transcriptLoadBlocksComposer ||
        _pendingReattachResync) {
      return;
    }
    setState(() => _startingVoiceInput = true);
    try {
      try {
        await _handsFree.stop(reason: HandsFreeStopReason.manualDictation);
        if (widget.testVoiceComposerAdapter == null ||
            widget.testVoiceReplySpeaker != null) {
          await _replySpeaker.stop();
        }
      } catch (_) {
        return;
      }
      if (!mounted ||
          intent != _manualAudioIntent ||
          !_voiceRouteCurrent ||
          !_voiceForeground ||
          _preparingPaste ||
          _sending ||
          _streaming) {
        return;
      }
      final started = await _voiceComposer.start(localeId: _sttLocaleId);
      if (!started && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _voiceComposer.status ??
                  _voiceStatus ??
                  context.l10n.speech_recognition_is_unavailable,
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _startingVoiceInput = false);
    }
  }

  void _onVoiceComposerChanged() {
    // Wake stays silent while the mic is owned by dictation, so the engine
    // never hears its own playback and a wake word cannot start a second mic.
    if (_wake case final wake?) {
      if (_voiceComposer.listening || _voiceComposer.starting) {
        unawaited(wake.pauseForVoice());
      } else {
        wake.setPausedForVoice(false);
      }
    }
    if (_voiceBound &&
        _handsFree.active &&
        (_voiceRecording.recording ||
            _voiceRecording.busy ||
            _voiceRecording.hasDraft)) {
      _handsFree.revoke(HandsFreeStopReason.manualSend);
    }
    if (_voiceBound && !_handsFree.active) {
      _voiceTurn?.finish(HandsFreeTurnStatus.unknown);
      _voiceTurn = null;
    }
    if (mounted && _voiceElementActive) setState(() {});
  }

  /// Marks whether this send's reply is to be spoken. A spoken reply's voice
  /// config is resolved while the turn runs, not after the reply lands.
  void _expectVoiceReply(bool speakResponse) {
    _awaitingVoiceReply = speakResponse && _voiceReplyEnabled;
    if (_awaitingVoiceReply || autoSpeakRepliesEnabled.value) {
      _ownedDirectSpeaker?.warm();
    }
  }

  Future<void> _speakAssistantText(String text) async {
    if (!_voiceReplyEnabled) return;
    await _readAssistantText(text);
  }

  Future<void> _readAssistantText(String text, {bool announce = false}) async {
    if (isParkedAutomotive) return;
    final intent = ++_manualAudioIntent;
    final spokenText = text.trim();
    if (spokenText.isEmpty) return;
    try {
      await _handsFree.stop(reason: HandsFreeStopReason.manualReadAloud);
      await _voiceComposer.cancel();
      await _voiceComposer.settle();
      final adapter = _voiceComposer.adapter;
      if (adapter is AndroidVoiceComposerAdapter) await adapter.settle();
    } catch (_) {
      return;
    }
    if (!mounted ||
        intent != _manualAudioIntent ||
        !_voiceRouteCurrent ||
        !_voiceForeground) {
      return;
    }
    if (announce && mounted) {
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(context.l10n.reading_response_aloud),
            duration: Duration(seconds: 2),
          ),
        );
    }
    var interrupted = false;
    var ended = false;
    final monitor = bargeInEnabled.value
        ? (widget.testBargeInMonitor?.call() ?? SpeechToTextBargeInMonitor())
        : null;
    bool readCurrent() =>
        mounted &&
        intent == _manualAudioIntent &&
        _voiceRouteCurrent &&
        _voiceForeground;
    void listenForBargeIn(BargeInMonitor monitor, VoidCallback cut) {
      unawaited(
        monitor
            .start(
              onInterrupt: () {
                interrupted = true;
                cut();
              },
              echoText: spokenText,
              isCurrent: readCurrent,
            )
            .then((opened) {
              // The mic is live once the monitor really opened it, and only
              // while this read is still the one playing.
              if (!opened || ended || interrupted || !readCurrent()) return;
              setState(() => _bargeInLive = monitor);
            }, onError: (Object _) {}),
      );
    }

    try {
      if (!_handsFreeSupported && widget.testVoiceReplySpeaker == null) {
        // Preserve non-Android Read aloud: queue mode/input-length APIs are
        // Android-only; hands-free completion guarantees are not claimed here.
        await _flutterTts.stop();
        if (monitor != null) {
          listenForBargeIn(
            monitor,
            () => unawaited(_flutterTts.stop().catchError((Object _) {})),
          );
        }
        await _flutterTts.speak(spokenText);
        return;
      }
      await _replySpeaker.stop();
      if (monitor != null) {
        listenForBargeIn(
          monitor,
          () => unawaited(_replySpeaker.stop().catchError((Object _) {})),
        );
      }
      final outcome = await _replySpeaker.speak(
        spokenText,
        isCurrent: () =>
            mounted &&
            intent == _manualAudioIntent &&
            _voiceRouteCurrent &&
            _voiceForeground,
      );
      if (outcome != HandsFreeSpeechOutcome.completed) {
        throw StateError('Playback unavailable');
      }
    } catch (_) {
      if (interrupted) return;
      if (!announce || !mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.read_aloud_is_unavailable_on_this_device,
            ),
            duration: Duration(seconds: 3),
          ),
        );
    } finally {
      ended = true;
      await monitor?.stop();
      if (monitor != null && identical(_bargeInLive, monitor)) {
        if (mounted) {
          setState(() => _bargeInLive = null);
        } else {
          _bargeInLive = null;
        }
      }
    }
  }

  void _onTurnSettled(GatewayTurnRecoveryState state) {
    if (!mounted) return;
    final turnId = state.turnId ?? state.clientTurnId;
    final completed =
        !state.isFailClosed &&
        state.status == GatewayRecoveryTurnStatus.completed;
    if (completed && !_appInBackground) _playCompletionCue();
    if (!_appInBackground) return;
    final kind = completed
        ? HermesNotificationKind.turnDone
        : HermesNotificationKind.turnError;
    if (!notificationKindEnabled(kind)) return;
    final summary = completed
        ? context.l10n.response_ready
        : context.l10n.turn_failed;
    unawaited(
      completed
          ? _turnNotifications.showTurnCompleted(
              origin: widget.connection,
              title: context.l10n.hermes_response_ready,
              turnSummary: '$_sessionTitle: $summary',
              turnId: turnId,
              sessionId: widget.session.id,
              connectionId: widget.connection.id,
            )
          : _turnNotifications.showTurnFailed(
              origin: widget.connection,
              title: context.l10n.the_turn_failed,
              turnSummary: '$_sessionTitle: $summary',
              turnId: turnId,
              sessionId: widget.session.id,
              connectionId: widget.connection.id,
            ),
    );
  }

  /// The in-app completion cue for this chat (it plays only while Ares is
  /// in front; a completion notification covers the background).
  void _playCompletionCue() =>
      CompletionCuePlayer.instance.turnFinished(_completionCueKey);

  /// Names this chat for the cue, as a pop-out of it does, so only one
  /// window plays it.
  String get _completionCueKey =>
      '${widget.connection.id}|${widget.session.id}';

  /// Mirrors a blocking approval to a native notification (with approve/deny
  /// buttons) while the app is in the background — the one prompt class that
  /// must not wait for the user to come back on their own.
  void _notifyApprovalRequest(String? serverRequestId) {
    if (_normalSession != null && _normalChat?.snapshot.turnId != null) return;
    if (!_appInBackground || serverRequestId == null) return;
    // Match the normal owner: request details stay inside the authenticated UI.
    final body = context.sharedL10n.release_chat_notification_review_action;
    unawaited(
      _turnNotifications.showKind(
        origin: widget.connection,
        kind: HermesNotificationKind.approval,
        title: '${context.l10n.approval_needed} — $_sessionTitle',
        body: body,
        eventId: serverRequestId,
        sessionId: widget.session.id,
        connectionId: widget.connection.id,
        actions: [
          TurnNotificationAction(id: 'approve', label: context.l10n.approve),
          TurnNotificationAction(id: 'reject', label: context.l10n.deny),
        ],
        payload: jsonEncode({
          'sessionId': widget.session.id,
          'connectionId': widget.connection.id,
          'requestId': serverRequestId,
          ..._notificationApprovalOrigin,
        }),
      ),
    );
  }

  /// Mirrors a clarify/sudo/secret prompt to a native notification while the
  /// app is in the background. The dialog itself stays queued for the return.
  void _notifyInputRequest({required String eventId}) {
    if (_normalSession != null && _normalChat?.snapshot.turnId != null) return;
    if (!_appInBackground) return;
    // Prompt content is only displayed after returning to the authenticated UI.
    final noticeBody = context.sharedL10n.release_chat_notification_respond;
    unawaited(
      _turnNotifications.showKind(
        origin: widget.connection,
        kind: HermesNotificationKind.input,
        title: '${context.l10n.input_needed} — $_sessionTitle',
        body: noticeBody,
        eventId: eventId,
        sessionId: widget.session.id,
        connectionId: widget.connection.id,
        payload: jsonEncode({
          'sessionId': widget.session.id,
          'connectionId': widget.connection.id,
        }),
      ),
    );
  }

  /// Gateway notices mirror the desktop split: credit state changes are the
  /// only native notice class (credits.depleted / credits.restored); every
  /// other notice posts as a plugin notice while the app is away.
  void _notifyGatewayNotice(GatewayNotification notification) {
    if (_normalSession != null &&
        (_turnApplicationSession == null || _legacyTransportFallback)) {
      return;
    }
    if (!_appInBackground) return;
    final isCredits =
        notification.key == 'credits.depleted' ||
        notification.key == 'credits.restored';
    unawaited(
      _turnNotifications.showKind(
        origin: widget.connection,
        kind: isCredits
            ? HermesNotificationKind.credits
            : HermesNotificationKind.plugin,
        title: isCredits
            ? context.l10n.credit_notifications
            : context.l10n.plugin_notifications,
        body: notification.text,
        eventId: notification.key,
        sessionId: widget.session.id,
        connectionId: widget.connection.id,
        payload: jsonEncode({
          'sessionId': widget.session.id,
          'connectionId': widget.connection.id,
        }),
      ),
    );
  }

  /// Background task completions and review summaries arrive as GatewayNotice
  /// insights; mirror them to a native notification while the app is away —
  /// completions as background work, reviews as gateway notices.
  void _notifyBackgroundNotice(GatewayNotice notice) {
    if (_normalSession != null &&
        (_turnApplicationSession == null || _legacyTransportFallback)) {
      return;
    }
    if (!_appInBackground) return;
    final isBackground = notice.kind == GatewayNoticeKind.background;
    unawaited(
      _turnNotifications.showKind(
        origin: widget.connection,
        kind: isBackground
            ? HermesNotificationKind.backgroundDone
            : HermesNotificationKind.plugin,
        title: isBackground
            ? context.l10n.background_task_completed
            : context.l10n.plugin_notifications,
        body: notice.text,
        eventId: notice.identity,
        sessionId: widget.session.id,
        connectionId: widget.connection.id,
        payload: jsonEncode({
          'sessionId': widget.session.id,
          'connectionId': widget.connection.id,
        }),
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    _syncEndAffordance(_scrollController.position);
  }

  bool _isNearEnd([ScrollMetrics? metrics]) {
    if (metrics == null && !_scrollController.hasClients) return true;
    final current = metrics ?? _scrollController.position;
    return _scrollCoordinator.isNearEnd(
      pixels: current.pixels,
      maxScrollExtent: current.maxScrollExtent,
    );
  }

  void _syncEndAffordance(
    ScrollMetrics metrics, {
    bool clearUnreadAtEnd = true,
  }) {
    final changed = _endAffordanceController.updatePosition(
      pixels: metrics.pixels,
      maxScrollExtent: metrics.maxScrollExtent,
      clearUnreadAtEnd: clearUnreadAtEnd,
    );
    if (changed && mounted) setState(() {});
  }

  void _registerMaterializedAssistantMessage() {
    _endAffordanceController.registerMaterializedMessage(
      willFollow: _scrollCoordinator.shouldFollowStreaming,
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final isDirectUserScroll =
        (notification is ScrollStartNotification &&
            notification.dragDetails != null) ||
        (notification is ScrollUpdateNotification &&
            notification.dragDetails != null) ||
        (notification is OverscrollNotification &&
            notification.dragDetails != null);
    if (isDirectUserScroll) {
      // A direct reader gesture cancels both opening and lazy-layout alignment.
      _openingScrollInterrupted = true;
      _initialEndFramesRemaining = 0;
      _automaticScrollGeneration++;
      _scrollCoordinator.updateFromUserScroll(
        isNearEnd: _isNearEnd(notification.metrics),
      );
    }
    return false;
  }

  void _applyScrollTarget(ChatScrollTarget target, {bool converge = true}) {
    if (_openTaskController != null ||
        _receivedRecoverySheetOpen ||
        !_scrollController.hasClients) {
      return;
    }
    final maxExtent = _scrollController.position.maxScrollExtent;
    if ((_scrollController.position.pixels - maxExtent).abs() >
        _stableExtentTolerance) {
      _scrollController.jumpTo(maxExtent);
    }
    _syncEndAffordance(_scrollController.position);
    if (converge) _startEndLayoutAlignment();
  }

  void _goToEnd() {
    _reader.currentState?.rememberLatest();
    _scrollCoordinator.updateFromUserScroll(isNearEnd: true);
    if (_canFocusSavedRecovery && _retainIdleRecoveryForPresentation()) {
      setState(() {});
      _scheduleScrollTarget(const ChatScrollTarget.end());
      return;
    }
    _applyScrollTarget(const ChatScrollTarget.end());
  }

  /// The composer's keyboard rising means the reader asked to compose:
  /// bring the latest message back into view and re-arm sticky streaming
  /// follow. A dialog or sheet field holds focus instead, so its keyboard
  /// never moves a reader parked in history — and if the IME stayed up
  /// across that dialog's pop, the composer still gets its scroll when it
  /// takes focus. Runs from build (keyboard changes) and from the composer's
  /// focus listener (focus changes while the keyboard is already up).
  void _syncComposerKeyboardEndScroll() {
    if (!mounted) return;
    // A pane's host Scaffold may already have resized for the keyboard.
    final keyboardOpen = keyboardHeightOf(context) > 0;
    if (!keyboardOpen) {
      _keyboardEndScrollDone = false;
    } else if (_composerFocus.hasFocus && !_keyboardEndScrollDone) {
      _keyboardEndScrollDone = true;
      _scrollCoordinator.updateFromUserScroll(isNearEnd: true);
      _scheduleScrollTarget(const ChatScrollTarget.end());
    }
  }

  void _scheduleScrollTarget(ChatScrollTarget? target) {
    if (_openTaskController != null || _receivedRecoverySheetOpen) return;
    final generation = _automaticScrollGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_canApplyAutomaticScroll(generation)) return;
      if (target != null) {
        _applyScrollTarget(target);
      } else if (_scrollController.hasClients) {
        _syncEndAffordance(_scrollController.position, clearUnreadAtEnd: false);
      }
    });
  }

  void _scheduleStreamingFollow() {
    if (_openTaskController != null ||
        _receivedRecoverySheetOpen ||
        _streamFollowScheduled) {
      return;
    }
    final generation = _automaticScrollGeneration;
    _streamFollowScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _streamFollowScheduled = false;
      if (!_canApplyAutomaticScroll(generation)) return;
      final target = _scrollCoordinator.streamingContentChanged();
      if (target != null) {
        _applyScrollTarget(target);
      } else if (_scrollController.hasClients) {
        _syncEndAffordance(_scrollController.position, clearUnreadAtEnd: false);
      }
    });
  }

  bool _canApplyAutomaticScroll(int generation) =>
      mounted &&
      _openTaskController == null &&
      !_receivedRecoverySheetOpen &&
      generation == _automaticScrollGeneration;

  void _scheduleInitialEndAlignment() {
    if (_scrollCoordinator.consumeInitialEndAlignment() == null) {
      _scheduleScrollTarget(null);
      return;
    }
    _startEndLayoutAlignment();
  }

  // Collapsed details and independent source sections have different lazy row
  // estimates. Converge only an authorised end target, never an ordinary refresh.
  void _startEndLayoutAlignment() {
    _initialEndFramesRemaining = _initialEndFrameBudget;
    _initialEndStableFrames = 0;
    _initialEndLastExtent = null;
    _scheduleNextInitialEndFrame();
  }

  void _scheduleNextInitialEndFrame() {
    if (_openTaskController != null ||
        _receivedRecoverySheetOpen ||
        _initialEndFrameScheduled ||
        _initialEndFramesRemaining <= 0) {
      return;
    }
    final generation = _automaticScrollGeneration;
    _initialEndFrameScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialEndFrameScheduled = false;
      if (!_canApplyAutomaticScroll(generation) ||
          _initialEndFramesRemaining <= 0) {
        return;
      }
      _initialEndFramesRemaining -= 1;

      if (!_scrollController.hasClients) {
        _scheduleNextInitialEndFrame();
        return;
      }

      final extent = _scrollController.position.maxScrollExtent;
      final previousExtent = _initialEndLastExtent;
      final extentIsStable =
          previousExtent != null &&
          (extent - previousExtent).abs() <= _stableExtentTolerance;
      _applyScrollTarget(const ChatScrollTarget.end(), converge: false);
      _initialEndStableFrames = extentIsStable
          ? _initialEndStableFrames + 1
          : 0;
      _initialEndLastExtent = extent;

      if (_initialEndStableFrames >= _requiredStableEndFrames ||
          _initialEndFramesRemaining <= 0) {
        return;
      }
      _scheduleNextInitialEndFrame();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  // Value equality permits harmless SavedConnection rehydration, but fences
  // credential/profile/origin replacement even when a parent retains State.
  // This record is private in-memory authority, never logged or persisted.
  Object get _historyAccountKey {
    final c = widget.connection;
    return (
      c.id,
      c.host,
      c.port,
      c.useHttps,
      c.apiKey,
      c.gatewayPrefix,
      c.gatewayProfile,
      c.desktopGatewayUrl,
      c.dashboardUsername,
      c.dashboardPassword,
      c.dashboardPrefix,
      c.dashboardPort,
      c.dashboardProxied,
    );
  }

  _ChatHistoryRead _beginHistoryRead(String sessionId, {bool older = false}) {
    final owner = _normalChat;
    return _ChatHistoryRead(
      owner: owner,
      account: _historyAccountKey,
      localSessionId: widget.session.id,
      authority: older
          ? owner?.historyReadFence(sessionId)
          : owner?.beginHistoryRead(sessionId),
      sessionId: sessionId,
      routeSessionId: _storedSessionKey,
      responseGeneration: _responseGeneration,
      observation: older ? _historyReadAccepted : ++_historyReadIssued,
      windowRevision: _historyWindowRevision,
    );
  }

  bool _historyReadAttached(_ChatHistoryRead read) =>
      mounted &&
      read.account == _historyAccountKey &&
      read.localSessionId == widget.session.id &&
      identical(read.owner, _normalChat) &&
      read.routeSessionId == _storedSessionKey &&
      (read.authority?.isAttached ?? true);

  bool _canApplyHistoryRead(_ChatHistoryRead read) =>
      _historyReadAttached(read) &&
      read.responseGeneration == _responseGeneration &&
      read.observation >= _historyReadAccepted &&
      (read.authority?.isCurrent ?? true);

  bool _acceptHistoryRead(
    _ChatHistoryRead read,
    List<Map<String, dynamic>> latest, {
    List<Map<String, dynamic>>? confirmedRows,
  }) {
    if (!_canApplyHistoryRead(read)) return false;
    if (read.owner != null &&
        !read.owner!.observeHistory(
          latest,
          read: read.authority,
          confirmedRows: confirmedRows,
        )) {
      return false;
    }
    // Owner delivery invokes arbitrary subscribers synchronously. A new turn,
    // binding, close or newer successful read there invalidates this callback.
    if (!_canApplyHistoryRead(read)) return false;
    _historyReadAccepted = read.observation;
    _hasSuccessfulHistoryRead = true;
    final snapshot = _normalSnapshot;
    if (latest.isNotEmpty && snapshot != null && !snapshot.hasActiveTurn) {
      _historyObservedRecoveryOutcomeIds.addAll(
        snapshot.receivedOutcomes
            .where((fact) => fact.outcome == ReceivedLifecycleOutcome.unknown)
            .map((fact) => fact.id),
      );
    }
    return true;
  }

  void _finishHistoryLoading(_ChatHistoryRead read) {
    // Release only this loader's resource, even when its result was superseded.
    // It must never clear a newer route loader or publish stale error/status.
    if (!mounted || !identical(_loadingHistoryRead, read)) return;
    _loadingHistoryRead = null;
    if (_historyReadAttached(read) &&
        read.responseGeneration == _responseGeneration) {
      // The first read can replace a thin loader with a taller error banner
      // after retained history has already used its one-shot alignment. Keep
      // only an untouched, exactly-at-end opening anchored across that layout.
      final keepOpeningEnd =
          _openingHistoryChromePending &&
          !_openingScrollInterrupted &&
          _openTaskController == null &&
          _scrollCoordinator.initialEndAlignmentConsumed &&
          _scrollController.hasClients &&
          (_scrollController.position.maxScrollExtent -
                      _scrollController.position.pixels)
                  .abs() <=
              1;
      _openingHistoryChromePending = false;
      setState(() => _loading = false);
      if (keepOpeningEnd) _startEndLayoutAlignment();
    }
  }

  Future<void> _fetchMessages({
    String? sessionId,
    Object? persistedContextFlight,
    bool focusSavedHistory = false,
  }) async {
    if (_pendingReattachResync && sessionId == null) return;
    final read = _beginHistoryRead(
      sessionId ?? _normalChat?.storedSessionId ?? widget.session.id,
    );
    _loadingHistoryRead = read;
    final navigationGeneration = _automaticScrollGeneration;
    final mayFocusRecovery =
        focusSavedHistory ||
        (!_hasSuccessfulHistoryRead && !_openingScrollInterrupted);
    setState(() {
      _loading = true;
      _error = null;
    });
    List<Map<String, dynamic>>? latest;
    try {
      final batch = await _historyWindow.fetchRecent(
        (offset) async {
          final rows = await _client.getMessages(
            read.sessionId,
            limit: ChatHistoryWindow.pageSize,
            offset: offset,
            latest: true,
          );
          // Only offset zero carries latest authority. Additional cold pages
          // are context, never a new read-start sequence or admission snapshot.
          if (offset == 0) latest = rows;
          return rows;
        },
        shouldContinue: () => _canApplyHistoryRead(read),
        forceColdScan: !_hasSuccessfulHistoryRead,
        needsContext: (rows) =>
            read.owner?.persistedTurnContextKey(rows) != null,
      );
      if (!_historyReadAttached(read)) return;
      if (read.responseGeneration != _responseGeneration) {
        _deferHistoryRefresh();
        return;
      }
      // Context fetched by this read can confirm a long receipt; retained
      // rows from earlier paging cannot lend this request fresh authority.
      if (!_acceptHistoryRead(read, latest!, confirmedRows: batch.rows)) return;
      final wasFollowingEnd = _isNearEnd();
      _historyWindow.acceptRecent(batch);
      _historyWindowRevision++;

      final regroupedRecovery =
          mayFocusRecovery &&
          navigationGeneration == _automaticScrollGeneration &&
          _retainIdleRecoveryForPresentation();
      final messages = _restHistoryForPresentation();
      _extractToolMessages(
        _historyWindow.rows,
        replacePresentation: _restReplyRetention?.hasRetainedReply != true,
      );
      setState(() {
        _messages = messages;
        _error = null;
      });
      if (_normalChat != null) {
        _applyNormalSnapshot(_normalChat!.snapshot, hydrateHistory: false);
      }
      if (regroupedRecovery && wasFollowingEnd) {
        _scheduleScrollTarget(const ChatScrollTarget.end());
      }
    } catch (e) {
      if (!_historyReadAttached(read)) return;
      if (read.responseGeneration != _responseGeneration) {
        _deferHistoryRefresh();
        return;
      }
      if (!_canApplyHistoryRead(read)) return;
      final errStr = e.toString();
      if (errStr.contains('404') || errStr.contains('not found')) {
        if (_pendingReattachResync || _messages.isNotEmpty) return;
        setState(() => _messages = []);
        return;
      }
      setState(() => _error = errStr);
    } finally {
      _finishHistoryLoading(read);
      if (persistedContextFlight != null) {
        _finishPersistedHistoryContext(
          persistedContextFlight,
          invalidated: !_canApplyHistoryRead(read),
        );
      }
    }
  }

  Future<List<Map<String, dynamic>>> _getRecentMessages(
    _ChatHistoryRead read,
  ) => _client.getMessages(
    read.sessionId,
    limit: ChatHistoryWindow.pageSize,
    latest: true,
  );

  void _acceptRecentMessages(List<Map<String, dynamic>> recent) {
    _historyWindow.acceptRecent(
      ChatHistoryPageBatch(
        recent,
        recent.length,
        recent.length == ChatHistoryWindow.pageSize,
      ),
    );
    _historyWindowRevision++;
    _restReplyRetention?.reconcile(_historyWindow.rows);
    _extractToolMessages(
      _historyWindow.rows,
      replacePresentation: _restReplyRetention?.hasRetainedReply != true,
    );
  }

  Future<void> _loadOlderMessages() async {
    if (_loadingOlder || !_historyWindow.hasOlder) return;
    final scrollGeneration = _automaticScrollGeneration;
    final offset = _historyWindow.olderOffset;
    final read = _beginHistoryRead(_storedSessionKey, older: true);
    _olderHistoryRead = read;
    final oldExtent = _scrollController.hasClients
        ? _scrollController.position.maxScrollExtent
        : 0.0;
    final oldPixels = _scrollController.hasClients
        ? _scrollController.position.pixels
        : 0.0;
    setState(() => _loadingOlder = true);
    try {
      final older = await _client.getMessages(
        read.sessionId,
        limit: ChatHistoryWindow.pageSize,
        offset: offset,
        latest: true,
      );
      if (!_canApplyHistoryRead(read) ||
          read.windowRevision != _historyWindowRevision ||
          offset != _historyWindow.olderOffset ||
          _sending ||
          _streaming) {
        return;
      }
      _historyWindow.acceptOlder(older);
      final acceptedRevision = ++_historyWindowRevision;
      _extractToolMessages(_historyWindow.rows, replacePresentation: false);
      setState(() => _messages = _restHistoryForPresentation());
      final normalSnapshot = _normalChat?.snapshot;
      if (normalSnapshot != null) {
        _applyNormalSnapshot(normalSnapshot, hydrateHistory: false);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_canApplyHistoryRead(read) ||
            acceptedRevision != _historyWindowRevision ||
            _sending ||
            _streaming ||
            !_canApplyAutomaticScroll(scrollGeneration) ||
            !_scrollController.hasClients) {
          return;
        }
        final delta = _scrollController.position.maxScrollExtent - oldExtent;
        _scrollController.jumpTo(
          (oldPixels + delta).clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          ),
        );
      });
    } catch (_) {
      // Leave the control available for a retry without hiding loaded rows.
    } finally {
      if (mounted && identical(_olderHistoryRead, read)) {
        _olderHistoryRead = null;
        setState(() => _loadingOlder = false);
      }
    }
  }

  /// A remote turn may start while the initial bounded transcript request is
  /// still in flight. Its stale response must not overwrite optimistic or
  /// streamed messages, but dropping it permanently would leave the existing
  /// transcript blank. Refresh once the turn is idle, using the authoritative
  /// post-turn page instead.
  void _deferHistoryRefresh() {
    _deferredHistoryRefreshPending = true;
    unawaited(_refreshDeferredHistoryIfIdle());
  }

  Future<void> _refreshDeferredHistoryIfIdle() async {
    if (!mounted ||
        !_deferredHistoryRefreshPending ||
        _deferredHistoryRefreshing ||
        _sending ||
        _streaming ||
        _stopResponseInFlight ||
        _pendingReattachResync) {
      return;
    }
    _deferredHistoryRefreshPending = false;
    _deferredHistoryRefreshing = true;
    final read = _beginHistoryRead(_storedSessionKey);
    _deferredHistoryRead = read;
    var retryAfterSettlement = false;
    try {
      final messages = await _getRecentMessages(read);
      if (!_historyReadAttached(read)) return;
      if (read.responseGeneration != _responseGeneration ||
          _sending ||
          _streaming ||
          _stopResponseInFlight ||
          _pendingReattachResync) {
        _deferredHistoryRefreshPending = true;
        retryAfterSettlement = true;
        return;
      }
      if (!_acceptHistoryRead(read, messages)) return;
      _acceptRecentMessages(messages);
      setState(() {
        _messages = _restHistoryForPresentation();
        _error = null;
      });
      final normalSnapshot = _normalChat?.snapshot;
      if (normalSnapshot != null) {
        _applyNormalSnapshot(normalSnapshot, hydrateHistory: false);
      }
    } catch (_) {
      // A stale failure cannot resurrect pending work after a newer success.
      if (_historyReadAttached(read) &&
          read.observation >= _historyReadAccepted &&
          !(read.authority?.isSuperseded ?? false)) {
        _deferredHistoryRefreshPending = true;
        retryAfterSettlement = read.responseGeneration != _responseGeneration;
      }
    } finally {
      if (identical(_deferredHistoryRead, read)) {
        _deferredHistoryRead = null;
        _deferredHistoryRefreshing = false;
      }
      if (retryAfterSettlement &&
          _historyReadAttached(read) &&
          !_sending &&
          !_streaming &&
          !_stopResponseInFlight &&
          !_pendingReattachResync) {
        unawaited(_refreshDeferredHistoryIfIdle());
      }
    }
  }

  Future<void> _recoverPendingTurn({bool allowLegacyFallback = false}) async {
    final turnSession = _turnApplicationSession;
    if (turnSession == null || _recoveringTurn || _legacyTransportFallback) {
      return;
    }
    _recoveringTurn = true;
    if (mounted && !_streaming) {
      setState(() {
        _sending = true;
        _gatewayTurnStatus = GatewayTurnStatus(
          kind: 'recovery',
          text: context.l10n.recovering_hermes,
        );
      });
    }
    try {
      final states = await turnSession.recoverPending(
        widget.session.id,
        onState: _applyGatewayTurnState,
      );
      if (!mounted) return;
      for (final state in states) {
        _applyGatewayTurnState(state);
      }
      if (states.isEmpty && _activeClientTurnId == null) {
        setState(() {
          _sending = false;
          _gatewayTurnStatus = null;
        });
      }
    } catch (error) {
      if (!mounted) return;
      final fallback = classifyTurnRecoveryFailure(
        error,
        allowLegacyFallback: allowLegacyFallback,
      );
      if (fallback == TurnRecoveryFallback.legacyTransport) {
        setState(() {
          _legacyTransportFallback = true;
          _stockGatewayFallback = turnRecoveryFailureIsStockGateway(error);
          _sending = false;
          _streaming = false;
          _gatewayTurnStatus = null;
          _activeResponseTransport = _ResponseTransport.none;
        });
        return;
      }
      setState(() {
        _gatewayTurnStatus = GatewayTurnStatus(
          kind: 'recovery',
          text: context.l10n.hermes_recovery_is_unavailable(error),
        );
      });
    } finally {
      _recoveringTurn = false;
    }
  }

  void _applyGatewayTurnState(GatewayTurnRecoveryState state) {
    if (!mounted) return;
    final projection = GatewayTurnUiProjection.fromState(state);
    final voiceBinding = _voiceTurn;
    if (voiceBinding?.transportTurnId == state.clientTurnId &&
        voiceBinding != null) {
      if (state.status == GatewayRecoveryTurnStatus.waitingInput) {
        _finishVoiceTurn(voiceBinding, HandsFreeTurnStatus.needsInput);
      } else if (projection.isFailClosed || state.ackUncertain) {
        _finishVoiceTurn(voiceBinding, HandsFreeTurnStatus.unknown);
      } else if (projection.isTerminal) {
        _finishVoiceTurn(voiceBinding, switch (projection.status) {
          GatewayRecoveryTurnStatus.completed => HandsFreeTurnStatus.completed,
          GatewayRecoveryTurnStatus.interrupted =>
            HandsFreeTurnStatus.interrupted,
          _ => HandsFreeTurnStatus.failed,
        }, stripToolResultText(projection.assistantText).trim());
      }
    }
    final messageIndex = _gatewayAssistantMessageIndex(projection);
    final shouldCreateMessage =
        messageIndex == null &&
        (projection.hasAssistantMaterial || projection.isActive);
    final previousText = messageIndex == null
        ? ''
        : _messages[messageIndex]['content']?.toString() ?? '';
    final nextText = projection.assistantText;
    final materialized = previousText.isEmpty && nextText.isNotEmpty;
    final speakTerminalResponse =
        projection.isTerminal &&
        !projection.isFailClosed &&
        _awaitingVoiceReply &&
        nextText.isNotEmpty;

    setState(() {
      final message = messageIndex == null
          ? <String, dynamic>{
              'role': 'assistant',
              'content': nextText,
              '_gateway_pending_response': projection.isActive,
            }
          : _messages[messageIndex];
      message
        ..['content'] = nextText
        ..['_chat_response_complete'] =
            projection.status == GatewayRecoveryTurnStatus.completed &&
            !projection.isFailClosed
        ..['_gateway_client_turn_id'] = projection.clientTurnId
        ..['_gateway_message_id'] = projection.messageId
        ..['_gateway_last_seq'] = projection.lastSeq
        ..['_gateway_pending_response'] = projection.isActive;
      if (projection.finalMessageRef != null) {
        message['_gateway_final_message_ref'] = projection.finalMessageRef;
      }
      // Only the application owner may supply a live receipt. Replayed events,
      // snapshots and route rebuilds deliberately do not manufacture one.
      if (projection.receivedAt != null) {
        ChatMessageTime.observe(
          message,
          source: ChatMessageTimeSource.received,
          at: projection.receivedAt,
        );
      }
      if (shouldCreateMessage) _messages.add(message);

      if (projection.isActive) {
        _activeClientTurnId = projection.clientTurnId;
        _activeResponseTransport = _ResponseTransport.desktop;
        _sending = true;
        _streaming = true;
        _gatewayTurnStatus = GatewayTurnStatus(
          kind: 'recovery',
          text: _gatewayRecoveryStatusText(projection.status),
        );
      } else if (_activeClientTurnId == null ||
          _activeClientTurnId == projection.clientTurnId) {
        _activeClientTurnId = null;
        _activeResponseTransport = _ResponseTransport.none;
        _sending = false;
        _streaming = false;
        _awaitingVoiceReply = false;
        _terminalTurnNotice = projection.isFailClosed
            ? context.l10n.hermes_stopped_recovery_safely_no_prompt_was_resent
            : projection.status == GatewayRecoveryTurnStatus.failed
            ? context.l10n.turn_failed
            : projection.status == GatewayRecoveryTurnStatus.interrupted
            ? context.l10n.response_stopped
            : null;
        _gatewayTurnStatus = projection.isFailClosed
            ? GatewayTurnStatus(
                kind: 'recovery_failed',
                text: context
                    .l10n
                    .hermes_stopped_recovery_safely_no_prompt_was_resent,
              )
            : null;
      }
    });
    if (!projection.isActive) {
      // A failure frame that arrived while this turn was live: now that the
      // turn has settled as failed, it goes to the card.
      final frame = _liveFailureFrame;
      _liveFailureFrame = null;
      if (frame != null &&
          !projection.isFailClosed &&
          projection.status == GatewayRecoveryTurnStatus.failed) {
        _noteRecovery(frame);
      }
    }
    final pendingSubmission = _recoverableSubmissionState;
    if (pendingSubmission != null && !pendingSubmission.isCompleted) {
      pendingSubmission.complete();
    }
    if (materialized) _registerMaterializedAssistantMessage();
    // The submission's identity: a terminal state applied again (a replay,
    // the route coming back) is never read a second time.
    final replyKeys = [
      'turn:${projection.clientTurnId}',
      if (projection.messageId case final id?) 'message:$id',
    ];
    if (speakTerminalResponse) {
      AutoReadLedger.claim(_autoReadChatKey, replyKeys);
      unawaited(_speakAssistantText(nextText));
    } else if (projection.isTerminal &&
        !projection.isFailClosed &&
        _liveEngine?.active != true &&
        autoSpeakRepliesEnabled.value &&
        nextText.trim().isNotEmpty &&
        AutoReadLedger.claim(_autoReadChatKey, replyKeys)) {
      // Ordinary typed turn: auto-read the terminal reply, once.
      unawaited(_speakAssistantText(nextText).catchError((Object _) {}));
    }
    if (projection.isActive) {
      _scrollCoordinator.beginStreaming(isNearEnd: _isNearEnd());
      _scheduleStreamingFollow();
    } else {
      _scheduleScrollTarget(_scrollCoordinator.endStreaming());
      unawaited(_refreshDeferredHistoryIfIdle());
      if (projection.isFailClosed ||
          projection.status == GatewayRecoveryTurnStatus.failed) {
        _held.park();
      }
      unawaited(_drainHeldIfIdle());
    }
  }

  int? _gatewayAssistantMessageIndex(GatewayTurnUiProjection projection) {
    for (var index = _messages.length - 1; index >= 0; index--) {
      final message = _messages[index];
      if (message['role'] != 'assistant') continue;
      if (message['_gateway_client_turn_id'] == projection.clientTurnId) {
        return index;
      }
      if (projection.messageId != null &&
          (message['_gateway_message_id'] == projection.messageId ||
              message['message_id'] == projection.messageId ||
              message['id'] == projection.messageId)) {
        return index;
      }
    }
    for (var index = _messages.length - 1; index >= 0; index--) {
      final message = _messages[index];
      if (message['role'] == 'assistant' &&
          message['_gateway_pending_response'] == true) {
        return index;
      }
    }
    if (projection.assistantText.isNotEmpty) {
      for (var index = _messages.length - 1; index >= 0; index--) {
        final message = _messages[index];
        if (message['role'] == 'assistant' &&
            message['content']?.toString() == projection.assistantText) {
          return index;
        }
      }
    }
    return null;
  }

  String _gatewayRecoveryStatusText(GatewayRecoveryTurnStatus? status) {
    return switch (status) {
      GatewayRecoveryTurnStatus.waitingInput =>
        context.l10n.hermes_is_waiting_for_input,
      GatewayRecoveryTurnStatus.running => context.l10n.hermes_is_responding,
      _ => context.l10n.recovering_hermes,
    };
  }

  void _extractToolMessages(
    List<Map<String, dynamic>> messages, {
    bool replacePresentation = true,
  }) {
    // The stored rows carry this chat's Kanban tool calls with their results;
    // a refreshed history also means a turn may have just ended.
    _kanbanDock
      ..observeHistoryRows(messages)
      ..turnEnded();
    final normal = _normalChat != null;
    final liveRuns = !normal && !replacePresentation
        ? _timeline.runs
        : const <ChatTimelineRun>[];
    if (!normal && replacePresentation) _timeline = _timeline.clear();
    for (final recovered in recoverDelegatedTasks(messages)) {
      // Real child references can reconnect a persisted row to live activity;
      // neither task goal nor task index is sufficient identity evidence.
      final index = _subagentActivities.indexWhere(
        (activity) => activity.matchesTask(recovered),
      );
      if (index < 0) {
        _subagentActivities.add(recovered);
      } else {
        _subagentActivities[index] = _subagentActivities[index].merge(
          recovered,
        );
        _openTaskController?.updateTask(_subagentActivities[index]);
      }
    }
    // Canonical task recovery may be older than an independently observed
    // child tip. Reapply that single owner's current metadata after hydration;
    // never clone its controller or let parent saved rows reset the viewer.
    if (normal) {
      for (final update
          in _normalSnapshot?.subagents ?? const <GatewaySubagentActivity>[]) {
        _mergeSubagentActivity(update);
      }
    }
    final observedByToolId = {
      for (final activity in [
        ..._toolActivities,
        if (normal) ...?_normalSnapshot?.tools,
      ])
        if (activity.toolId != null) activity.toolId!: activity,
    };
    _toolActivities.clear();
    for (final msg in messages) {
      if (!isToolResultMessage(msg)) continue;

      final name =
          (msg['name'] as String?) ??
          (msg['tool_name'] as String?) ??
          (msg['toolCallName'] as String?) ??
          '';
      final toolCallId = (msg['tool_call_id'] as String?) ?? '';
      final content = messageContentToText(msg['content']);

      String toolName = name.isNotEmpty ? name : '';
      if (toolName.isEmpty && content.isNotEmpty) {
        final match = RegExp(r'source="([^"]+)"').firstMatch(content);
        if (match != null) toolName = match.group(1)!;
      }
      if (toolName.isEmpty) toolName = 'tool';

      _toolActivities.add(
        GatewayToolActivity.fromStoredResult(
          toolId: toolCallId.isEmpty ? null : toolCallId,
          name: toolName,
          timestamp: msg['timestamp'],
          observedStart: observedByToolId[toolCallId]?.startedAt,
          observedLastActivity: observedByToolId[toolCallId]?.lastActivityAt,
        ),
      );
    }
    for (final run in liveRuns) {
      if (run.kind != ChatTimelineKind.tool) continue;
      final activity = run.activity!;
      final index = _toolActivities.indexWhere(
        (stored) =>
            stored.identity == activity.identity ||
            activity.toolId != null && stored.toolId == activity.toolId,
      );
      if (index < 0) {
        _toolActivities.add(activity);
      } else {
        _timeline = _timeline.tool(run.scope, _toolActivities[index]);
      }
    }
  }

  String _composerTextWithPastes(String text) => [
    text,
    for (final draft in _attachmentDrafts) ?_pastedDraftTexts[draft.id],
  ].where((part) => part.isNotEmpty).join('\n\n');

  void _onLargePaste(LargePasteEdit edit) {
    final remote =
        _desktopGateway != null ||
        widget.testRemotePromptSubmit != null ||
        (_turnApplicationSession != null && !_legacyTransportFallback);
    if (!remote ||
        _preparingPaste ||
        _sending ||
        _streaming ||
        _preparingSend ||
        _pendingReattachResync ||
        _archiving ||
        _startingVoiceInput ||
        _voiceComposer.listening ||
        _transcriptLoadBlocksComposer) {
      return;
    }
    _pastedDraftTexts.removeWhere(
      (id, _) => !_attachmentDrafts.any((draft) => draft.id == id),
    );
    // The formatter observes the edit just before the controller listener.
    final revision = _composerRevision + 1;
    setState(() => _preparingPaste = true);
    unawaited(_prepareLargePaste(edit, revision));
  }

  Future<void> _prepareLargePaste(LargePasteEdit edit, int revision) {
    final owner = _intakeOwner;
    return _intake.run(() => _prepareLargePasteNow(edit, revision, owner));
  }

  Future<void> _prepareLargePasteNow(
    LargePasteEdit edit,
    int revision,
    Object owner,
  ) async {
    AttachmentDraft? prepared;
    try {
      prepared = await _attachmentDraftService.preparePastedText(
        text: edit.text,
        existingDrafts: List<AttachmentDraft>.of(_attachmentDrafts),
      );
      if (!mounted ||
          owner != _intakeOwner ||
          _startingVoiceInput ||
          _voiceComposer.listening ||
          !_draftWriter.isCurrent ||
          _composerRevision != revision ||
          _textController.value != edit.insertedValue) {
        return;
      }
      // A picker already in flight may have added files during cache I/O.
      _attachmentDraftService.validateRemoteDrafts([
        ..._attachmentDrafts,
        prepared,
      ]);
      final draft = prepared;
      setState(() {
        _attachmentDrafts.add(draft);
        _pastedDraftTexts[draft.id] = edit.text;
        _textController.value = edit.withoutPaste;
      });
      prepared = null;
    } catch (_) {
      if (mounted) {
        _showAttachmentError(context.l10n.paste_attachment_failed_text_kept);
      }
    } finally {
      if (prepared != null) {
        await _attachmentDraftService.removeCachedFile(prepared);
      }
      if (mounted) setState(() => _preparingPaste = false);
    }
  }

  Future<void> _showAttachmentPicker() async {
    await _handsFree.stop(reason: HandsFreeStopReason.attachmentAction);
    if (!mounted) return;
    if (_transcriptLoadBlocksComposer ||
        _preparingPaste ||
        _streaming ||
        _sending ||
        _pendingReattachResync) {
      return;
    }
    final offerCapture = await screenCaptureOffered(widget.screenCapture);
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(
                _desktopGateway == null
                    ? context.l10n.choose_image
                    : context.l10n.choose_images,
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickGalleryImages();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(context.l10n.take_photo),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickCameraImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_outlined),
              title: Text(context.l10n.browse_server_files),
              subtitle: Text(context.l10n.insert_a_remote_file_reference),
              onTap: () {
                Navigator.pop(sheetContext);
                unawaited(_pickServerFile());
              },
            ),
            ListTile(
              leading: const Icon(Icons.notes_outlined),
              title: Text(context.sharedL10n.composer_snippets),
              onTap: () {
                Navigator.pop(sheetContext);
                unawaited(
                  showPromptSnippets(context: context, editor: _textController),
                );
              },
            ),
            if (offerCapture)
              ListTile(
                key: const Key('classic-attach-capture-screen'),
                leading: const Icon(Icons.screenshot_monitor_outlined),
                title: Text(context.l10n.capture_screen_action),
                subtitle: Text(context.l10n.capture_screen_help),
                onTap: () {
                  Navigator.pop(sheetContext);
                  unawaited(_captureScreen());
                },
              ),
            if (_desktopGateway != null)
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(context.l10n.choose_files),
                subtitle: Text(
                  context.l10n.documents_archives_audio_video_or_data,
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickFiles();
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Adds a screen capture as an image draft through the picked-image
  /// path. Never sends.
  Future<void> _captureScreen() async {
    await captureScreenIntoDraft(
      context,
      controller: widget.screenCapture,
      attach: (png, name) =>
          _preparePickedImages([XFile(png.path, name: name)]),
    );
  }

  Future<void> _pickServerFile() async {
    String? path;
    final testPicker = widget.testServerFilePicker;
    if (testPicker != null) {
      path = await testPicker();
    } else if (_desktopGateway != null && _sessionScopedFiles) {
      setState(() => _showSessionFiles = true);
      return;
    } else {
      final files = RemoteFilesClient.fromConnection(widget.connection);
      try {
        if (!mounted) return;
        path = await Navigator.of(context).push<String>(
          MaterialPageRoute<String>(
            builder: (_) => FilesScreen(
              files: files,
              onAddToChat: (selectedPath) =>
                  Navigator.of(context).pop(selectedPath),
            ),
          ),
        );
      } finally {
        files.close();
      }
    }
    if (!mounted || path == null || path.trim().isEmpty) return;
    final current = _textController.text.trimRight();
    final reference =
        '${gatewayContextReference(folder: false, path: path.trim())} ';
    final next = current.isEmpty ? reference : '$current\n$reference';
    _textController.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
  }

  Future<void> _pickGalleryImages() async {
    final owner = _intakeOwner;
    try {
      final mode = _desktopGateway == null
          ? AttachmentDraftMode.rest
          : AttachmentDraftMode.remoteGateway;
      if (!allowsMultipleImageSelection(mode)) {
        final image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 75,
          maxWidth: 1600,
          maxHeight: 1600,
        );
        if (image != null) await _preparePickedImages([image], owner: owner);
        return;
      }
      final images = await _imagePicker.pickMultiImage(
        imageQuality: 75,
        maxWidth: 1600,
        maxHeight: 1600,
      );
      if (images.isNotEmpty) await _preparePickedImages(images, owner: owner);
    } catch (_) {
      if (!mounted) return;
      _showAttachmentError(
        context.l10n.unable_to_prepare_this_image_try_another_one,
      );
    }
  }

  Future<void> _pickCameraImage() async {
    final owner = _intakeOwner;
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        maxWidth: 1600,
        maxHeight: 1600,
      );
      if (image != null) await _preparePickedImages([image], owner: owner);
    } catch (_) {
      if (!mounted) return;
      _showAttachmentError(
        context.l10n.unable_to_prepare_this_image_try_another_one,
      );
    }
  }

  Future<void> _recoverLostImage() async {
    final response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) return;

    final files = response.files;
    if (files == null || files.isEmpty) {
      if (!mounted) return;
      _showAttachmentError(
        context.l10n.image_selection_was_interrupted_try_again,
      );
      return;
    }

    await _preparePickedImages(_desktopGateway == null ? [files.first] : files);
  }

  /// The chat an intake belongs to: captured when it starts, checked before
  /// its draft is staged. A host that swaps this screen's chat without a
  /// remount must not get the earlier chat's drops, pastes or picks.
  Object get _intakeOwner => (widget.connection.id, widget.session.id);

  /// Returns how many images became drafts. [remote] says whether the
  /// gateway takes several drafts (by default, a Desktop gateway does).
  Future<int> _preparePickedImages(
    List<XFile> images, {
    bool? remote,
    Object? owner,
  }) {
    final intakeOwner = owner ?? _intakeOwner;
    return _intake.run(() async {
      if (!mounted || intakeOwner != _intakeOwner) return 0;
      return _preparePickedImagesNow(
        images,
        remote: remote,
        owner: intakeOwner,
      );
    });
  }

  /// [_preparePickedImages] inside the intake queue.
  Future<int> _preparePickedImagesNow(
    List<XFile> images, {
    bool? remote,
    required Object owner,
  }) async {
    final l10n = context.l10n;
    final isRemote = remote ?? _desktopGateway != null;
    final prepared = <AttachmentDraft>[];
    final errors = <String>[];
    for (final image in images) {
      try {
        final draft = await _attachmentDraftService.prepareImage(
          sourcePath: image.path,
          displayName: image.name,
          existingDrafts: isRemote
              ? [..._attachmentDrafts, ...prepared]
              : const <AttachmentDraft>[],
          mode: isRemote
              ? AttachmentDraftMode.remoteGateway
              : AttachmentDraftMode.rest,
        );
        prepared.add(draft);
        if (!isRemote) break;
      } on AttachmentDraftException catch (error) {
        errors.add(error.message);
      } catch (_) {
        errors.add(l10n.unable_to_prepare(image.name));
      }
    }
    if (!mounted || owner != _intakeOwner) {
      // Left, or this composer now belongs to another chat: drop them.
      await _attachmentDraftService.removeAll(prepared);
      return 0;
    }
    if (prepared.isNotEmpty) {
      if (isRemote) {
        setState(() => _attachmentDrafts.addAll(prepared));
      } else {
        final replaced = List<AttachmentDraft>.from(_attachmentDrafts);
        setState(() {
          _attachmentDrafts
            ..clear()
            ..add(prepared.single);
        });
        unawaited(_attachmentDraftService.removeAll(replaced));
      }
    }
    if (errors.isNotEmpty) {
      _showAttachmentError(errors.first);
    }
    return prepared.length;
  }

  Future<void> _pickFiles() async {
    final owner = _intakeOwner;
    if (_desktopGateway == null) {
      _showAttachmentError(
        context
            .l10n
            .configure_a_valid_desktop_gateway_url_before_attaching_files,
      );
      return;
    }
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
        withData: false,
      );
      final files = result?.files ?? const [];
      if (files.isEmpty) return;
      await _intake.run(() async {
        if (!mounted || owner != _intakeOwner) return;
        final available = maxRemoteAttachmentDrafts - _attachmentDrafts.length;
        if (available <= 0) {
          _showAttachmentError(
            context.l10n.you_can_attach_up_to_items(maxRemoteAttachmentDrafts),
          );
          return;
        }
        final prepared = <AttachmentDraft>[];
        var rejected = 0;
        for (final file in files.take(available)) {
          final path = file.path;
          if (path == null) {
            rejected++;
            continue;
          }
          try {
            prepared.add(
              await _attachmentDraftService.prepareGenericFile(
                sourcePath: path,
                displayName: file.name,
                existingDrafts: [..._attachmentDrafts, ...prepared],
              ),
            );
          } catch (_) {
            rejected++;
          }
        }
        if (!mounted || owner != _intakeOwner) {
          await _attachmentDraftService.removeAll(prepared);
          return;
        }
        setState(() => _attachmentDrafts.addAll(prepared));
        if (files.length > available || rejected > 0) {
          _showAttachmentError(
            context.l10n.files_skipped(files.length - prepared.length),
          );
        }
      });
    } catch (_) {
      if (!mounted) return;
      _showAttachmentError(
        context.l10n.unable_to_prepare_this_file_try_another_one,
      );
    }
  }

  /// Attach, and the OS intake that feeds it, is open whenever the Attach
  /// button is.
  bool get _attachIntakeOpen =>
      !_transcriptLoadBlocksComposer &&
      !_preparingPaste &&
      !_streaming &&
      !_sending &&
      !_pendingReattachResync;

  /// Drafts beyond one REST image need a gateway that uploads them.
  bool get _remoteDraftsAllowed =>
      _desktopGateway != null ||
      widget.testRemotePromptSubmit != null ||
      (_turnApplicationSession != null && !_legacyTransportFallback);

  /// Files from the OS (dropped, pasted as files or as a path, or dragged
  /// from the session files panel). Images take the photo path, other files
  /// the Choose files path, with the same draft count and size limits. Each
  /// becomes a draft; nothing is sent. Returns how many were staged.
  Future<int> _intakeLocalFiles(
    List<OsIntakeFile> files, {
    Object? owner,
    bool preserveRestImage = false,
  }) async {
    final intakeOwner = owner ?? _intakeOwner;
    var staged = 0;
    var folders = false;
    for (final file in files) {
      if (!mounted || intakeOwner != _intakeOwner) break;
      if (!_attachIntakeOpen) {
        _showAttachmentError(context.sharedL10n.composer_attach_busy);
        break;
      }
      if (file.directory) {
        folders = true;
        continue;
      }
      final image = looksLikeImagePath(file.path);
      if (!image && !_remoteDraftsAllowed) {
        _showAttachmentError(
          context
              .l10n
              .configure_a_valid_desktop_gateway_url_before_attaching_files,
        );
        continue;
      }
      // REST takes one image, replacing the last; the gateway counts drafts.
      final restImage = image && !_remoteDraftsAllowed;
      // The slot check runs in the intake queue, after every earlier drop,
      // paste or pick has staged: two at once never both take the last slot.
      var full = false;
      staged += await withDroppedFileAccess(
        file,
        () => _intake.run(() async {
          if (!mounted || intakeOwner != _intakeOwner) return 0;
          if (restImage && preserveRestImage && _attachmentDrafts.isNotEmpty) {
            full = true;
            return 0;
          }
          if (!restImage &&
              _attachmentDrafts.length >= maxRemoteAttachmentDrafts) {
            full = true;
            return 0;
          }
          return image
              ? _preparePickedImagesNow(
                  [XFile(file.path, name: file.name)],
                  remote: _remoteDraftsAllowed,
                  owner: intakeOwner,
                )
              : _prepareLocalFile(file.path, file.name, owner: intakeOwner);
        }),
      );
      if (!mounted) break;
      if (full) {
        _showAttachmentError(
          context.l10n.you_can_attach_up_to_items(
            restImage ? 1 : maxRemoteAttachmentDrafts,
          ),
        );
        break;
      }
      if (restImage) {
        if (preserveRestImage && files.length > 1) {
          _showAttachmentError(context.l10n.you_can_attach_up_to_items(1));
        }
        break;
      }
    }
    if (folders && mounted) {
      _showAttachmentError(context.sharedL10n.composer_drop_folder_unsupported);
    }
    return staged;
  }

  /// One local non-image file as a draft, as Choose files prepares it. Runs
  /// inside the intake queue.
  Future<int> _prepareLocalFile(
    String path,
    String name, {
    required Object owner,
  }) async {
    try {
      final draft = await _attachmentDraftService.prepareGenericFile(
        sourcePath: path,
        displayName: name,
        existingDrafts: List<AttachmentDraft>.of(_attachmentDrafts),
      );
      if (!mounted || owner != _intakeOwner) {
        await _attachmentDraftService.removeAll([draft]);
        return 0;
      }
      setState(() => _attachmentDrafts.add(draft));
      return 1;
    } on AttachmentDraftException catch (error) {
      _showAttachmentError(error.message);
    } catch (_) {
      if (mounted) _showAttachmentError(context.l10n.unable_to_prepare(name));
    }
    return 0;
  }

  /// Cmd/Ctrl+V with files or an image on the clipboard.
  Future<void> _intakeClipboard(ClipboardAttachment found) async {
    final owner = _intakeOwner;
    final image = found.image;
    if (image != null) {
      await _intakeImageBytes(
        image,
        'image/png',
        owner: owner,
        preserveRestImage: true,
      );
      return;
    }
    await _intakeLocalFiles(
      await osIntakeFilesFor(found.files),
      owner: owner,
      preserveRestImage: true,
    );
  }

  /// A pasted or keyboard-inserted image (Android keyboards insert images
  /// through contentInsertionConfiguration).
  Future<void> _intakeImageBytes(
    Uint8List bytes,
    String mimeType, {
    Object? owner,
    bool preserveRestImage = false,
  }) async {
    final intakeOwner = owner ?? _intakeOwner;
    if (!mounted) return;
    if (!_attachIntakeOpen) {
      _showAttachmentError(context.sharedL10n.composer_attach_busy);
      return;
    }
    final String path;
    try {
      path = await stageComposerImageBytes(bytes, mimeType: mimeType);
    } catch (_) {
      if (mounted) {
        _showAttachmentError(
          context.l10n.unable_to_prepare_this_image_try_another_one,
        );
      }
      return;
    }
    try {
      if (mounted) {
        await _intakeLocalFiles(
          [OsIntakeFile(path)],
          owner: intakeOwner,
          preserveRestImage: preserveRestImage,
        );
      }
    } finally {
      // The draft holds its own sanitised copy (or there is no draft).
      await discardStagedComposerImage(path);
    }
  }

  /// A file or folder dragged from the session files panel: gateway paths
  /// and folders become references, a file on this device a draft.
  Future<void> _intakeComposerDrag(ComposerDrag drag) async {
    final owner = _intakeOwner;
    final plan = classifyDrag(drag);
    final path = plan.path ?? '';
    if (plan.kind == LocalIntake.reference) {
      appendWorkspaceReference(
        _textController,
        gatewayContextReference(folder: plan.directory, path: path),
      );
      return;
    }
    final local = await localFileForPastedPath(path);
    if (!mounted) return;
    if (local == null) {
      _showAttachmentError(context.sharedL10n.composer_file_missing);
      return;
    }
    await _intakeLocalFiles([local], owner: owner);
  }

  /// A short paste the editor's formatter saw, handled once the text is in
  /// the controller ([_onComposerChanged]): a formatter must not edit the
  /// field. Large pastes have their own path ([_onLargePaste]).
  PastedChunk? _pendingPathPaste;

  late final TextInputFormatter _pathPasteFormatter =
      TextInputFormatter.withFunction((oldValue, newValue) {
        final selection = oldValue.selection;
        if (!selection.isValid || !oldValue.composing.isCollapsed) {
          return newValue;
        }
        final chunk = PastedChunk.detect(
          oldValue.text,
          selection.start,
          selection.end,
          newValue.text,
        );
        _pendingPathPaste =
            chunk != null &&
                chunk.text.length <= largePasteAttachmentThreshold &&
                clipboardPath(chunk.text) != null
            ? chunk
            : null;
        return newValue;
      });

  /// A pasted path to a file on this device becomes a draft and leaves the
  /// draft text. Folders, missing paths and gateway paths stay text.
  Future<void> _consumePathPaste(PastedChunk chunk) async {
    final owner = _intakeOwner;
    final path = clipboardPath(chunk.text);
    if (path == null || !_attachIntakeOpen) return;
    final file = await localFileForPastedPath(path);
    if (file == null || !mounted) return;
    if (!looksLikeImagePath(path) && !_remoteDraftsAllowed) return;
    final staged = await _intakeLocalFiles([file], owner: owner);
    if (staged == 0 || !mounted || owner != _intakeOwner) return;
    // Edits since the paste stay; only the pasted path leaves, where it was
    // pasted rather than at an earlier copy of the same text.
    final next = chunk.removeFrom(_textController.text);
    if (next != null) _textController.value = next;
  }

  void _showAttachmentError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      hermesStatusSnackBar(
        context,
        message: message,
        status: HermesStatus.failed,
      ),
    );
  }

  Future<void> _removeAttachment(AttachmentDraft draft) async {
    if (!mounted) return;
    setState(
      () => _attachmentDrafts.removeWhere((item) => item.id == draft.id),
    );
    if (_pastedDraftTexts.remove(draft.id) != null) {
      _draftWriter.edit(_composerTextWithPastes(_textController.text));
    }
    // The user intent and its draft authority precede asynchronous cleanup.
    // A late deletion must never reclaim a replacement route's newer writer.
    await _attachmentDraftService.removeCachedFile(draft);
  }

  void _moveAttachment(AttachmentDraft draft, int offset) {
    final index = _attachmentDrafts.indexOf(draft);
    setState(() {
      _attachmentDraftService.moveDraft(
        _attachmentDrafts,
        fromIndex: index,
        offset: offset,
      );
    });
  }

  Future<AttachmentUploadReceipt> _uploadAttachmentDraft(
    DesktopGatewayClient desktopGateway,
    AttachmentDraft draft,
    String dataUrl,
  ) async {
    final attachment = await desktopGateway.attachFile(
      sessionId: _normalLocalSessionKey,
      name: draft.name,
      dataUrl: dataUrl,
    );
    return AttachmentUploadReceipt(
      refText: attachment.refText,
      atlasIntakeAccepted: attachment.atlasIntakeAccepted,
    );
  }

  Future<void> _retryAttachment(AttachmentDraft draft) async {
    final desktopGateway = _desktopGateway;
    if (desktopGateway == null ||
        _sending ||
        _streaming ||
        _pendingReattachResync) {
      return;
    }
    setState(() {
      _sending = true;
      _gatewayTurnStatus = GatewayTurnStatus(
        kind: 'upload',
        text: context.l10n.retrying(draft.name),
      );
    });
    try {
      final receipt = await _attachmentSendCoordinator.retryFailed(
        draft: draft,
        upload: ({required draft, required dataUrl}) =>
            _uploadAttachmentDraft(desktopGateway, draft, dataUrl),
        onChanged: (_) {
          if (mounted) setState(() {});
        },
      );
      if (!mounted) return;
      if (receipt.atlasIntakeAccepted == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context
                  .l10n
                  .file_attached_document_catalog_registration_is_pending,
            ),
          ),
        );
      }
    } catch (error) {
      _showAttachmentError(
        context.l10n.retry_failed_for_the_draft_and_prompt_were_kept(
          draft.name,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
          _gatewayTurnStatus = null;
        });
      }
    }
  }

  Future<void> _showModelSelector({
    VoidCallback? onOpened,
    bool Function()? canOpen,
  }) async {
    if (_pendingReattachResync || _loadingModelOptions) return;
    final l10n = context.sharedL10n;
    setState(() => _loadingModelOptions = true);
    try {
      await _sessionModelRestore;
      if (!mounted || _pendingReattachResync || canOpen?.call() == false) {
        return;
      }
      final desktopGateway = _desktopGateway;

      // API-server-only connections deliberately stay on port 8642. The API
      // server exposes both the model inventory and the current session model;
      // no Dashboard client or :9119 transport is needed for the picker.
      late final Map<String, dynamic> sessionOrModelInfo;
      late final Map<String, dynamic> modelOptions;
      if (desktopGateway != null) {
        final results = await Future.wait([
          desktopGateway.getModelInfo(),
          desktopGateway.getModelOptions(),
        ]);
        sessionOrModelInfo = results[0];
        modelOptions = results[1];
      } else if (widget.session.isLocalDraft) {
        // A new chat deliberately has no server row until its first turn (or
        // until a selected model is persisted below), so an exact-session GET
        // would be a guaranteed 404. The API model inventory contains the
        // profile default needed to initialise the picker.
        sessionOrModelInfo = const {};
        modelOptions = await _client.getModelOptions();
      } else {
        final results = await Future.wait([
          _client.getSession(widget.session.id),
          _client.getModelOptions(),
        ]);
        sessionOrModelInfo = results[0];
        modelOptions = results[1];
      }
      if (!mounted || _pendingReattachResync || canOpen?.call() == false) {
        return;
      }
      final modelInfo = desktopGateway != null
          ? sessionOrModelInfo
          : modelOptions;
      final choices = _parseModelChoices(modelOptions);
      if (choices.isEmpty) {
        throw UiMessageException(
          l10n.the_active_profile_did_not_return_any_selectable_models,
        );
      }

      var currentEffort =
          _sessionReasoningEffort ??
          WsClient.normalizeReasoningEffort(modelInfo['reasoning_effort']);
      try {
        if (desktopGateway != null) {
          currentEffort = await desktopGateway.getSessionReasoning(
            widget.session.id,
          );
        }
      } catch (_) {
        // Older gateways may not expose session-scoped config.get. The model
        // selector remains usable with the profile/default effort.
      }
      if (!mounted || _pendingReattachResync || canOpen?.call() == false) {
        return;
      }

      final apiSessionModel =
          desktopGateway == null && !widget.session.isLocalDraft
          ? sessionOrModelInfo['model']?.toString().trim()
          : null;
      final selectedModel = apiSessionModel?.isNotEmpty == true
          ? apiSessionModel!
          : (_sessionModel ??
                (widget.session.isLocalDraft
                    ? modelOptions['model']?.toString().trim()
                    : null) ??
                widget.session.model);
      final providerHint =
          _sessionProvider ??
          (widget.session.isLocalDraft
              ? modelOptions['provider']?.toString().trim()
              : desktopGateway != null
              ? modelInfo['provider']?.toString().trim()
              : null);
      final selectedChoice = _initialModelChoice(
        choices,
        selectedModel: selectedModel,
        provider: providerHint,
      );
      // The picker lists only providers the gateway actually has configured
      // (custom_providers entries and the profile's current provider). A
      // session pinned to a model from a hidden provider keeps that row
      // visible so the picker still reflects real session state. The keep-
      // alive trusts only a choice that actually matches the session's
      // model: _initialModelChoice falls back to an arbitrary first row
      // when the session's model is absent from the inventory, and that
      // phantom must not masquerade as the session's model. The full
      // inventory is shown only when the gateway exposes no configured-
      // provider flags at all (legacy payload) or when filtering would
      // leave the picker with nothing usable.
      final configuredSlugs = _configuredProviderSlugs(modelOptions);
      final configuredChoices = choices
          .where((choice) => configuredSlugs.contains(choice.provider))
          .toList(growable: false);
      final pinnedChoice =
          selectedChoice != null && selectedChoice.model == selectedModel
          ? selectedChoice
          : null;
      final visibleChoices = <_ModelChoice>[
        ...configuredChoices,
        if (pinnedChoice != null &&
            !configuredChoices.any(
              (choice) =>
                  choice.provider == pinnedChoice.provider &&
                  choice.model == pinnedChoice.model,
            ))
          pinnedChoice,
      ];
      final pickerChoices = configuredSlugs.isEmpty || visibleChoices.isEmpty
          ? choices
          : visibleChoices;
      // Only a choice that provably matches the session's model may be
      // pre-selected: a phantom fallback row (session model absent from the
      // inventory) must never masquerade as the current model, even when it
      // happens to be a configured row.
      final initialChoice = pinnedChoice;
      // The "choose a provider" banner only makes sense while the displayed
      // list actually offers the same model id under multiple providers.
      final providerChoiceRequired =
          selectedChoice == null &&
          pickerChoices.where((c) => c.model == selectedModel).length > 1;
      final selectionFuture = showModalBottomSheet<_ModelSelection>(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (_) => _ChatModelPickerSheet(
          choices: pickerChoices,
          modelInfo: modelInfo,
          initialChoice: initialChoice,
          initialEffort: currentEffort,
          providerChoiceRequired: providerChoiceRequired,
        ),
      );
      onOpened?.call();
      final selection = await selectionFuture;
      if (selection != null && mounted && !_pendingReattachResync) {
        await _setSessionModel(selection);
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.could_not_load_models_for_this_profile(error),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loadingModelOptions = false);
    }
  }

  /// Provider slugs the gateway reports as configured: user-defined
  /// (custom_providers) entries plus the profile's current provider.
  /// Returns an empty set when the gateway exposes no such flags.
  Set<String> _configuredProviderSlugs(Map<String, dynamic> options) {
    final providers = options['providers'];
    if (providers is! List) return const {};
    final slugs = <String>{};
    for (final rawProvider in providers) {
      if (rawProvider is! Map) continue;
      final provider =
          (rawProvider['slug'] ?? rawProvider['id'])?.toString().trim() ?? '';
      if (provider.isEmpty) continue;
      // Mirror the gateway's explicit-only semantics (hermes_cli/inventory.py
      // _filter_explicit_provider_rows): managed local models are configured
      // by existence and the MoA row only exists when the user opted in, so
      // both stay even without a configured flag.
      final source = rawProvider['source']?.toString();
      if (rawProvider['is_user_defined'] == true ||
          rawProvider['is_current'] == true ||
          source == 'local-runtime' ||
          source == 'virtual') {
        slugs.add(provider);
      }
    }
    return slugs;
  }

  List<_ModelChoice> _parseModelChoices(Map<String, dynamic> options) {
    final providers = options['providers'];
    if (providers is! List) return const [];
    final choices = <_ModelChoice>[];
    for (final rawProvider in providers) {
      if (rawProvider is! Map) continue;
      final provider =
          (rawProvider['slug'] ?? rawProvider['id'])?.toString().trim() ?? '';
      final models = rawProvider['models'];
      if (provider.isEmpty || models is! List) continue;
      for (final rawModel in models) {
        final model = rawModel is String
            ? rawModel.trim()
            : rawModel is Map
            ? (rawModel['id'] ?? rawModel['model'] ?? rawModel['name'])
                      ?.toString()
                      .trim() ??
                  ''
            : '';
        if (model.isNotEmpty) {
          choices.add(_ModelChoice(provider: provider, model: model));
        }
      }
    }
    return choices;
  }

  _ModelChoice? _initialModelChoice(
    List<_ModelChoice> choices, {
    required String selectedModel,
    String? provider,
  }) {
    final candidates = choices
        .where((choice) => choice.model == selectedModel)
        .toList(growable: false);
    final cleanProvider = provider?.trim() ?? '';
    if (cleanProvider.isNotEmpty) {
      for (final choice in candidates) {
        if (choice.provider == cleanProvider) return choice;
      }
    }
    if (candidates.length == 1) return candidates.single;
    if (candidates.length > 1) {
      // GET /api/sessions/{id} intentionally omits model_config, so an API
      // session whose model id exists under multiple providers has no
      // authoritative provider unless this client saved one. Never guess the
      // first provider: require an explicit tap before Apply is enabled.
      return null;
    }
    return choices.isEmpty ? null : choices.first;
  }

  /// Applies [selection] to this chat. True once the gateway took it.
  Future<bool> _setSessionModel(_ModelSelection selection) async {
    final desktopGateway = _desktopGateway;
    if (_changingModel || _pendingReattachResync) return false;
    final choice = selection.choice;
    final effort = selection.reasoningEffort;
    setState(() => _changingModel = true);
    try {
      if (desktopGateway != null) {
        await desktopGateway.setSessionModel(
          sessionId: _normalLocalSessionKey,
          provider: choice.provider,
          model: choice.model,
        );
        if (!mounted || _pendingReattachResync) return false;
        if (effort != null) {
          await desktopGateway.setSessionReasoning(
            sessionId: _normalLocalSessionKey,
            effort: effort,
          );
        }
      } else {
        // The API Server owns this session, so persist the same per-session
        // lock over :8642 instead of activating the Dashboard transport.
        // Reasoning effort remains a Desktop Gateway-only control.
        await _client.setSessionModel(
          sessionId: widget.session.id,
          provider: choice.provider,
          model: choice.model,
          createSessionIfMissing: widget.session.isLocalDraft,
        );
      }
      final store = await _chatModelStore;
      await store.save(
        connectionIdentity: _connectionIdentity,
        sessionId: widget.session.id,
        provider: choice.provider,
        model: choice.model,
        reasoningEffort: effort ?? _sessionReasoningEffort,
      );
      if (!mounted) return false;
      setState(() {
        _sessionModel = choice.model;
        _sessionProvider = choice.provider;
        if (effort != null) {
          _sessionReasoningEffort = effort;
          _sessionReasoningWire = '';
        }
        _sessionModelOverride = true;
      });
      // With no effort chosen or known, the model row shows the switch.
      final shownEffort = effort ?? _sessionReasoningEffort;
      if (shownEffort != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.model_scope_applied(
                _reasoningEffortLabel(context, shownEffort),
                choice.model,
              ),
            ),
          ),
        );
      }
      return true;
    } catch (error) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.model_was_not_changed(error))),
      );
      return false;
    } finally {
      if (mounted) setState(() => _changingModel = false);
    }
  }

  /// The failure card's Switch to (model): Desktop's switchAndRetry and
  /// NextGen's. The suggested model becomes this chat's model, then the
  /// failed turn runs again on it, exactly once, through Retry's regenerate
  /// (a newer draft stays). With no provider to pair the model with, the
  /// picker opens. Where no regenerate is possible (REST) the card already
  /// said the switch will not re-run the turn, so it only switches. A
  /// screen left mid-switch sends nothing.
  Future<void> _switchToSuggested(ModelSuggestion suggestion) async {
    if (_switchingToSuggested) return;
    final provider = suggestion.provider?.trim().isNotEmpty == true
        ? suggestion.provider!.trim()
        : _sessionProvider?.trim() ?? '';
    if (provider.isEmpty) {
      await _showModelSelector();
      return;
    }
    final prompt = _lastPromptText;
    _switchingToSuggested = true;
    try {
      final switched = await _setSessionModel(
        _ModelSelection(
          choice: _ModelChoice(provider: provider, model: suggestion.model),
          reasoningEffort: null,
        ),
      );
      if (!switched || !mounted) return;
      setState(() {
        _recoveryMessage = null;
        _recoverySurface = null;
      });
      if (prompt != null && _canRegenerate) {
        _modelOverrideFresh = true;
        await _retryPrompt(prompt);
      }
    } finally {
      _switchingToSuggested = false;
      _modelOverrideFresh = false;
    }
  }

  bool _switchingToSuggested = false;

  /// Set by Switch to for the retry right behind it; see
  /// [_applySessionModelOverride].
  bool _modelOverrideFresh = false;

  /// Send message via SSE streaming (Gateway API Server).
  Future<void> _startRecordedVoice() async {
    if (isParkedAutomotive) return;
    final authority = _captureVoiceAuthority();
    if (!_isVoiceAuthorityCurrent(authority) || _sending || _streaming) return;
    try {
      await _handsFree.stop(reason: HandsFreeStopReason.manualSend);
      if (widget.testVoiceComposerAdapter == null ||
          widget.testVoiceReplySpeaker != null) {
        await _replySpeaker.stop();
      }
    } catch (_) {
      return;
    }
    if (_isVoiceAuthorityCurrent(authority)) await _voiceRecording.start();
  }

  Future<void> _sendRecordedVoice() async {
    if (_sending ||
        _streaming ||
        _pendingReattachResync ||
        _voiceComposer.listening) {
      return;
    }
    final authority = _captureVoiceAuthority();
    if (!_isVoiceAuthorityCurrent(authority)) return;
    await _voiceRecording.send(
      submit: (path, accepted) async {
        final transcribe = widget.testVoiceTranscription;
        final transcript = transcribe != null
            ? await transcribe(path)
            : await _transcribeWithClientDirectFallback(path);
        if (!_isVoiceAuthorityCurrent(authority) || transcript.trim().isEmpty) {
          return;
        }
        final receipt = Completer<void>();
        final sending = _sendMessage(
          textOverride: transcript.trim(),
          onAccepted: () {
            if (receipt.isCompleted) return;
            accepted();
            receipt.complete();
          },
        );
        // Free the voice UI after a proven receipt, while the ordinary chat
        // transport continues owning the response. No transport write is retried.
        await Future.any([sending, receipt.future]);
      },
    );
  }

  /// Provider-direct transcription when the gateway's profile config says the
  /// client may call it; otherwise the existing authenticated audio relay.
  /// Provider rejections are surfaced, never retried through the relay.
  Future<String> _transcribeWithClientDirectFallback(String path) async {
    final connection = widget.connection;
    final store = VoiceClientRuntime.storeFor(
      connection,
      connectionId: connection.id,
      profile: connection.gatewayProfile,
    );
    try {
      final direct = await store.transcribe(
        path,
        fileName: 'recording.m4a',
        mimeType: 'audio/mp4',
      );
      if (direct != null) return direct;
    } on ClientDirectVoiceException catch (error) {
      if (mounted) {
        ScaffoldMessenger.maybeOf(
          context,
        )?.showSnackBar(SnackBar(content: Text(error.message)));
      }
      throw const VoiceTranscriptionException();
    }
    return transcribeVoiceRecording(
      _voiceDashboard ??= DashboardClient.fromConnection(connection),
      path,
    );
  }

  Future<void> _sendMessage({
    bool speakResponse = false,
    String? textOverride,
    VoidCallback? onAccepted,
    HandsFreePrompt? handsFreePrompt,
    _HandsFreeTurnBinding? voiceBinding,
    Map<String, Object?> promptParams = const {},
    bool hiddenIntent = false,
  }) async {
    final keepComposer = textOverride != null || voiceBinding != null;
    if (textOverride == null &&
        (_voiceRecording.recording || _voiceRecording.busy)) {
      return;
    }
    if (handsFreePrompt == null && _handsFree.active) {
      await _handsFree.stop(reason: HandsFreeStopReason.manualSend);
      if (!mounted) return;
    }
    if (handsFreePrompt != null &&
        !_handsFree.isCurrent(handsFreePrompt.authority)) {
      return;
    }
    if (_voiceComposer.listening ||
        _startingVoiceInput ||
        _preparingPaste ||
        _preparingSend ||
        _archiving ||
        _stopResponseInFlight ||
        _midTurnSendInFlight ||
        _normalChat?.snapshot.steering == true) {
      return;
    }
    var text =
        textOverride ??
        handsFreePrompt?.transcript ??
        _textController.text.trim();
    if (_setupBeat != null &&
        !hiddenIntent &&
        text.isNotEmpty &&
        slashCommandName(text) == null) {
      final yielded = await _yieldSetupBeatToMessage();
      if (!mounted) return;
      // The card's turn ends on that answer, so a typed message waits for
      // it in the held queue and runs as the next turn, never a steer.
      if (yielded &&
          _streaming &&
          textOverride == null &&
          handsFreePrompt == null &&
          !_usesNormalInputOwner) {
        _queueHeldFromComposer();
        return;
      }
    }
    if (_streaming) {
      if (text.isNotEmpty) {
        await _sendWhileWorking(text);
      } else if (handsFreePrompt == null &&
          textOverride == null &&
          _attachmentDrafts.isEmpty &&
          !_usesNormalInputOwner &&
          _held.entries.isNotEmpty) {
        // Empty Enter while busy is Desktop's double-send. The head is
        // admitted once after the interrupt. Nothing queued does not stop.
        await _sendHeldNow(_held.entries.first.id);
      } else if (_attachmentDrafts.isNotEmpty) {
        // Active-turn guidance is text-only. Do not silently drop an explicit
        // attachments-only Send, interrupt work, or consume the staged files.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.running_message_not_accepted)),
        );
      }
      return;
    }
    final attachments = handsFreePrompt == null && textOverride == null
        ? List<AttachmentDraft>.from(_attachmentDrafts)
        : <AttachmentDraft>[];
    if (text.isEmpty && attachments.isEmpty) {
      if (!_usesNormalInputOwner && _held.entries.isNotEmpty) {
        _held.unpark();
        if (mounted) setState(() {});
        await _drainHeldIfIdle();
      }
      return;
    }
    if (_sending || _streaming || _pendingReattachResync) return;
    if (_transcriptLoadBlocksComposer) return;
    // Once sent, all failures are handled by slash dispatch itself. Null is
    // only literal/unknown slash prose or a non-RPC transport; a returned
    // send/skill directive is the only command result that becomes a prompt.
    if (textOverride == null &&
        handsFreePrompt == null &&
        voiceBinding == null &&
        _attachmentDrafts.isEmpty) {
      final slashRevision = _composerRevision;
      final slashGeneration = _slashController.generation;
      final slashGateway = _slashGateway;
      final slashEpoch = slashGateway?.slashRefusals.epoch;
      final slashPrompt = await _dispatchSlashCommand(text);
      if (!mounted) return;
      // Returning a directive and this caller resuming are separate async
      // boundaries. Never let a late fallback/expanded prompt clear new text
      // or borrow a replacement socket's authority.
      if (slashCommandName(text) != null &&
          (slashRevision != _composerRevision ||
              slashGeneration != _slashController.generation ||
              !identical(slashGateway, _slashGateway) ||
              slashEpoch != slashGateway?.slashRefusals.epoch ||
              !_draftWriter.isCurrent ||
              !widget.active)) {
        return;
      }
      if (slashPrompt != null) {
        if (slashPrompt.isEmpty) return;
        text = slashPrompt;
      }
    }
    if (_loading || _error != null) {
      // Remote transports own their session history server-side. Let a prompt
      // proceed independently of a slow or failed visible transcript request.
      setState(() {
        _loading = false;
        _error = null;
      });
    }
    final usesRemoteTransport =
        (_turnApplicationSession != null && !_legacyTransportFallback) ||
        _desktopGateway != null ||
        widget.testRemotePromptSubmit != null;
    try {
      if (usesRemoteTransport) {
        _attachmentDraftService.validateRemoteDrafts(attachments);
      } else {
        _attachmentDraftService.validateRestDrafts(attachments);
      }
    } on AttachmentDraftException catch (error) {
      _showAttachmentError(error.message);
      return;
    }

    // Own this submission before the first await. Only the captured prompt is
    // consumed; setup, uploads and stream callbacks must not clear newer text.
    if (_normalChat != null &&
        (_turnApplicationSession == null ||
            _legacyTransportFallback ||
            promptParams.isNotEmpty)) {
      final reservation = _normalChat!.reserve();
      if (reservation == null) return;
      _normalReservation = reservation;
      if (voiceBinding != null) {
        voiceBinding.clientTurnId = _normalChat!.snapshot.turnId!;
        voiceBinding.transportTurnId = voiceBinding.clientTurnId;
      }
    }
    _preparingSend = true;
    if (_turnApplicationSession == null || _legacyTransportFallback) {
      voiceBinding?.admitted.complete(true);
    }
    setState(() {
      _sending = true;
      // A new turn supersedes the last failure's recovery card.
      _recoveryMessage = null;
      _recoverySurface = null;
    });
    if (!keepComposer) _clearComposerForSend(text);
    try {
      await _sessionModelRestore;
    } catch (error) {
      if (!mounted) return;
      if (!keepComposer) _restoreComposerAfterRejectedSend(text);
      voiceBinding?.finish(HandsFreeTurnStatus.failed);
      _handleSendError(error);
      final reservation = _normalReservation;
      if (reservation != null) _normalChat?.cancelPreparation(reservation);
      _normalReservation = null;
      return;
    } finally {
      _preparingSend = false;
    }
    if (!mounted) return;
    if (voiceBinding != null &&
        !_handsFree.isCurrent(voiceBinding.prompt.authority)) {
      final reservation = _normalReservation;
      if (reservation != null) _normalChat?.cancelPreparation(reservation);
      _normalReservation = null;
      voiceBinding.finish(HandsFreeTurnStatus.unknown);
      setState(() => _sending = false);
      return;
    }
    await _submitMessage(
      text: text,
      attachments: attachments,
      speakResponse: speakResponse,
      voiceBinding: voiceBinding,
      preserveComposer: keepComposer,
      onAccepted: onAccepted,
      promptParams: promptParams,
      hiddenIntent: hiddenIntent,
    );
  }

  /// Null is reserved for literal/unknown slash prose or a non-RPC transport.
  /// Once dispatched, a failure never grants permission for a second send.
  Future<String?> _dispatchSlashCommand(String text) async {
    final name = slashCommandName(text);
    if (name == null) return null;
    if (_sending || _streaming || _preparingSend) return '';
    final bareName = name.toLowerCase().replaceFirst(RegExp(r'^/+'), '');
    final screenOwner = _kanbanOwner;
    if (bareName == 'kanban' &&
        _slashCommandArgument(text).isEmpty &&
        screenOwner != null) {
      final owner = screenOwner;
      final connection = widget.connection;
      _setRestoredComposer('');
      _commitComposerForSend();
      unawaited(
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => KanbanBoardScreen(
              owner: owner,
              route: owner.route(),
              connection: connection,
            ),
          ),
        ),
      );
      return '';
    }
    if (bareName == 'bots' &&
        _slashCommandArgument(text).isEmpty &&
        screenOwner != null) {
      final owner = screenOwner;
      final connection = widget.connection;
      _setRestoredComposer('');
      _commitComposerForSend();
      unawaited(
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BotsScreen(
              owner: owner,
              route: owner.route(),
              connection: connection,
            ),
          ),
        ),
      );
      return '';
    }
    if (_localNewSessionNames.contains(bareName)) {
      if (widget.singleSession) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.sharedL10n.release_chat_start_new_main_window,
            ),
          ),
        );
        return '';
      }
      unawaited(_openFreshDraftChat(_slashCommandArgument(text)));
      _setRestoredComposer('');
      _commitComposerForSend();
      return '';
    }
    final revision = _composerRevision;
    final l10n = context.l10n;
    final unsupportedText = l10n.slash_command_unsupported;
    final sessionId = widget.session.id;
    final gateway = _slashGateway;
    final generation = _slashController.generation;
    final memoryEpoch = gateway?.slashRefusals.epoch;
    bool current() =>
        mounted &&
        widget.active &&
        widget.session.id == sessionId &&
        identical(gateway, _slashGateway) &&
        generation == _slashController.generation &&
        memoryEpoch == gateway?.slashRefusals.epoch;
    void consume() {
      if (current() &&
          _draftWriter.isCurrent &&
          revision == _composerRevision) {
        _setRestoredComposer('');
        _commitComposerForSend();
      }
    }

    _preparingSend = true;
    var sent = false;
    try {
      // These are classic ChatScreen surfaces, not NextGen routes. Argument
      // forms are not implemented locally: preserve the exact requested line.
      if (bareName == 'resume' ||
          bareName == 'sessions' ||
          bareName == 'switch') {
        final query = _slashCommandArgument(text);
        _slashController.close();
        final open = widget.onOpenSession;
        if (open == null) {
          // No host path to open a chat from here: never replace the route
          // blindly. Say so and keep the line, arguments included.
          _appendSlashCommandNotice(text, l10n.slash_sessions_inline);
          return '';
        }
        consume();
        unawaited(_openResumePicker(text, query, open));
        return '';
      }
      if (bareName == 'btw' ||
          bareName == 'bg' ||
          bareName == 'background' ||
          bareName == 'handoff') {
        if (gateway is DesktopGatewayClient) {
          final arg = _slashCommandArgument(text);
          final shared = context.sharedL10n;
          if (arg.isNotEmpty && !gateway.hasLiveSession(sessionId)) {
            // Classic binds the gateway session with the first message; a
            // side question needs that session, so say so and keep the line.
            _appendSlashCommandNotice(
              text,
              shared.composer_command_needs_gateway_session,
            );
            return '';
          }
          final run = await runDedicatedCommand(
            name: bareName,
            arg: arg,
            sessionId: sessionId,
            l10n: shared,
            rpc: gateway.requestSessionRpc,
          );
          if (!current()) return '';
          final answer = run?.answer;
          if (answer?.fallbackToExec != true) {
            final notice = answer?.notice ?? run?.plan.notice;
            if (notice != null && notice.isNotEmpty) {
              _appendSlashCommandNotice(text, notice);
            }
            if (answer != null && answer.taskId.isNotEmpty) {
              _startedSideTasks.add(answer.taskId);
            }
            if (answer?.failed != true) consume();
            if (answer?.watchHandoff == true) {
              unawaited(_watchClassicHandoff(gateway, sessionId, arg));
            }
            return '';
          }
        }
      }
      if (bareName == 'model') {
        if (_slashCommandArgument(text).isNotEmpty) {
          _appendSlashCommandNotice(text, l10n.slash_local_arguments);
        } else {
          unawaited(
            _showModelSelector(
              onOpened: consume,
              canOpen: () => current() && _voiceRoute?.isCurrent != false,
            ),
          );
        }
        return '';
      }
      if (gateway == null || !gateway.slashCommandsSupported) return null;
      final catalogReady = await _slashController.ensureCatalog().timeout(
        const Duration(seconds: 3),
        onTimeout: () => false,
      );
      if (!current() ||
          !_draftWriter.isCurrent ||
          _voiceRoute?.isCurrent == false ||
          _sending ||
          _streaming) {
        return '';
      }
      if (catalogReady && !_slashController.isExecutable(name)) {
        if (!_slashController.knowsCommand(name)) return null;
        _appendSlashCommandNotice(text, unsupportedText);
        return '';
      }
      final result = await gateway.runSlashCommand(
        sessionId: sessionId,
        command: text,
        onSent: () => sent = true,
      );
      if (!current()) return '';
      if (result.isPrefill) {
        if (_draftWriter.isCurrent && revision == _composerRevision) {
          _editComposerAsUser(result.text);
        } else {
          _appendSlashCommandNotice(text, result.text);
        }
        return '';
      }
      if (result.isPrompt) {
        // Never clear a newer edit via the ordinary prompt path.
        if (!_draftWriter.isCurrent || revision != _composerRevision) {
          _appendSlashCommandNotice(text, result.text);
          return '';
        }
        return result.text;
      }
      consume();
      _appendSlashCommandNotice(text, result.text);
      return '';
    } on JsonRpcError catch (error) {
      if (!current()) return '';
      if (_isSlashCommandRefusal(error)) {
        // A refusal proves this invocation did not run even without a loaded
        // catalogue. With arguments it says nothing about the bare command.
        if (_slashCommandArgument(text).isEmpty) {
          _slashController.markRefused(name);
        }
        final detail = error.data['detail'];
        _appendSlashCommandNotice(
          text,
          detail is String && detail.trim().isNotEmpty
              ? detail.trim()
              : unsupportedText,
        );
      } else if (sent && _isSlashDeliveryUnknown(error)) {
        _showSlashDeliveryUnknown();
      } else {
        _showSlashCommandFailure(error.message);
      }
      return '';
    } catch (_) {
      if (current()) {
        if (sent) {
          _showSlashDeliveryUnknown();
        } else {
          _showSlashCommandFailure('');
        }
      }
      return '';
    } finally {
      _preparingSend = false;
    }
  }

  ApiClient? _ownedResumeClient;
  String? _recoveryMessage;
  FailureSurface? _recoverySurface;

  /// Desktop's resume picker over the chats Desktop lists (no cron, kanban,
  /// one-shot, tool or subagent runs, nor this chat). The pick opens through
  /// [open], the host's own path; cancelling gives back [typed].
  Future<void> _openResumePicker(
    String typed,
    String query,
    Future<void> Function(Session session) open,
  ) async {
    if (!mounted) return;
    final loaded = <Session>[];
    final picked = await showResumePicker(
      context: context,
      initialQuery: query,
      listAvailable: true,
      load: (q) async {
        final client =
            widget.testApiClient ??
            (_ownedResumeClient ??= ApiClient.forConnection(widget.connection));
        final page = await client.getSessionsPage(
          limit: 50,
          title: q.trim().isEmpty ? null : q.trim(),
        );
        final rows = [
          for (final row in page.sessions)
            if (!isMachineSession(row) &&
                !isInternalListingSession(row, showSubagents: false) &&
                row.id != widget.session.id &&
                row.id != _storedSessionKey)
              row,
        ];
        loaded
          ..clear()
          ..addAll(rows);
        return [
          for (final row in rows)
            ResumeCandidate(id: row.id, title: row.title, preview: row.preview),
        ];
      },
    );
    if (!mounted) return;
    if (picked == null) {
      // Cancelled: the typed command comes back to an empty composer.
      if (_draftWriter.isCurrent && _textController.text.isEmpty) {
        _editComposerAsUser(typed);
      }
      return;
    }
    Session? session;
    for (final row in loaded) {
      if (row.id == picked.id) session = row;
    }
    if (session == null) return;
    await open(session);
  }

  Future<void> _watchClassicHandoff(
    DesktopGatewayClient gateway,
    String sessionId,
    String platform,
  ) async {
    final sharedL10n = context.sharedL10n;
    final outcome = await watchHandoff(
      rpc: gateway.requestSessionRpc,
      sessionId: sessionId,
      timeoutMessage: sharedL10n.composer_handoff_timeout,
      alive: () => mounted && widget.session.id == sessionId,
    );
    final text = switch (outcome.phase) {
      HandoffPhase.pending => null,
      HandoffPhase.completed => sharedL10n.composer_handoff_done(platform),
      HandoffPhase.failed =>
        outcome.error.isEmpty
            ? sharedL10n.composer_handoff_failed
            : outcome.error,
      HandoffPhase.timedOut => sharedL10n.composer_handoff_timeout,
    };
    if (text == null || !mounted) return;
    _appendSlashCommandNotice('/handoff $platform', text);
  }

  /// Side questions and background tasks this chat started (`/btw`,
  /// `/background`): their answers belong in this transcript.
  final Set<String> _startedSideTasks = {};

  /// Desktop's dispatcher shows the answer to `/btw` and to a `/background`
  /// task this chat started as a persistent line in the chat. Classic shows
  /// it the way it shows command output: in quiet and verbose chat alike.
  bool _showSideAnswer(StreamEvent event) {
    final answer = SideAnswer.fromEvent(event.type, event.data);
    if (answer == null) return false;
    if (answer.kind == DedicatedSlash.background &&
        !_startedSideTasks.contains(answer.taskId)) {
      return false; // someone else's task: the gateway notice path shows it
    }
    if (answer.kind == DedicatedSlash.background) {
      _notifyBackgroundNotice(
        GatewayNotice(
          kind: GatewayNoticeKind.background,
          text: answer.text,
          taskId: answer.taskId.isEmpty ? null : answer.taskId,
        ),
      );
    }
    final seen = _slashNotices.any(
      (notice) =>
          notice.command == answer.header && notice.output == answer.text,
    );
    if (!seen) _appendSlashCommandNotice(answer.header, answer.text);
    return true;
  }

  StatusBarLayout _statusLayout = StatusBarLayout.defaults();
  ContextReading? _statusBreakdown;
  bool _statusBreakdownLoading = false;
  bool _statusLayoutLoaded = false;

  /// Applies and keeps the status bar choice (shared with NextGen).
  void _setStatusLayout(StatusBarLayout layout) {
    setState(() => _statusLayout = layout);
    unawaited(saveStatusLayout(layout));
    if (layout.visible('context-usage')) unawaited(_loadStatusBreakdown());
  }

  /// Where the composer's gateway calls go: the Desktop gateway client.
  ComposerSessionRpc? get _composerGateway =>
      widget.testComposerRpc ?? _desktopGateway;

  bool _statusRefreshQueued = false;

  /// Reads the breakdown again once each turn ends, as NextGen does. Turns
  /// end inside setState, so the read waits for the frame.
  void _statusAfterTurn() {
    if (_statusRefreshQueued || !_statusLayout.visible('context-usage')) {
      return;
    }
    _statusRefreshQueued = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _statusRefreshQueued = false;
      if (mounted) unawaited(_loadStatusBreakdown());
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  Future<void> _loadStatusBreakdown() async {
    if (!_statusLayout.visible('context-usage')) return;
    final gateway = _composerGateway;
    if (gateway == null || !gateway.hasLiveSession(widget.session.id)) {
      setState(() => _statusBreakdown = ContextReading.empty);
      return;
    }
    setState(() => _statusBreakdownLoading = true);
    try {
      final result = await gateway.requestSessionRpc(
        'session.context_breakdown',
        {'session_id': widget.session.id},
      );
      if (!mounted) return;
      setState(() {
        _statusBreakdown = parseContextBreakdown(result);
        _statusBreakdownLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _statusBreakdown = ContextReading.empty;
        _statusBreakdownLoading = false;
      });
    }
  }

  /// A composer RPC: session-scoped once the chat has a live gateway
  /// session, otherwise connection-level (never a stored id in its place).
  Future<Map<String, dynamic>> _composerRpc(
    String method,
    Map<String, dynamic> params,
  ) {
    final gateway = _composerGateway;
    if (gateway == null) {
      throw UiMessageException(
        context.sharedL10n.release_chat_no_desktop_gateway,
      );
    }
    if (gateway.hasLiveSession(widget.session.id)) {
      return gateway.requestSessionRpc(method, {
        ...params,
        'session_id': widget.session.id,
      });
    }
    return gateway.call(method, params);
  }

  /// The failure card's Compress: the gateway's session.compress, then the
  /// transcript again. A failure is shown, never swallowed.
  Future<void> _compressClassicChat() async {
    final gateway = _composerGateway;
    final shared = context.sharedL10n;
    if (gateway == null || !gateway.hasLiveSession(widget.session.id)) {
      _showRetryNotice(shared.composer_command_needs_gateway_session);
      return;
    }
    try {
      await gateway.requestSessionRpc('session.compress', {
        'session_id': widget.session.id,
      });
      if (!mounted) return;
      setState(() {
        _recoveryMessage = null;
        _recoverySurface = null;
      });
      _appendSlashCommandNotice('/compress', shared.composer_compress_done);
      unawaited(_loadStatusBreakdown());
    } catch (error) {
      if (!mounted) return;
      _showRetryNotice(
        error is JsonRpcError ? error.message : error.toString(),
      );
    }
  }

  Widget _modelRowButton(BuildContext context) {
    if (!_statusLayoutLoaded) {
      _statusLayoutLoaded = true;
      unawaited(
        loadStatusLayout().then((layout) {
          if (!mounted) return;
          setState(() => _statusLayout = layout);
          if (layout.visible('context-usage')) {
            unawaited(_loadStatusBreakdown());
          }
        }),
      );
    }
    final busy =
        _sending ||
        _streaming ||
        _pendingReattachResync ||
        _loadingModelOptions ||
        _changingModel;
    return Semantics(
      label: context.l10n.choose_chat_model,
      value: _sessionModel ?? widget.session.model,
      button: true,
      enabled: !busy,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: TextButton.icon(
          onPressed: busy ? null : _showModelSelector,
          icon: _loadingModelOptions || _changingModel
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.tune, size: 18),
          label: Text(
            context.l10n.model_scope_label(
              _sessionModel ?? widget.session.model,
              _sessionModelOverride
                  ? context.l10n.this_chat
                  : context.l10n.profile_default,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  /// A turn is live on this screen: being prepared, sent, streamed,
  /// recovered or owned by the stock application owner.
  bool get _hasLiveTurn =>
      _sending ||
      _streaming ||
      _preparingSend ||
      _recoveringTurn ||
      _pendingReattachResync ||
      _normalChat?.snapshot.hasActiveTurn == true;

  /// The stock owner's failure frame raises the failure card once its turn
  /// has settled as failed, or at once for a detached turn that failed on
  /// the server. Each frame is shown once per screen.
  void _cardNormalFailure(NormalGatewayChatSnapshot snapshot) {
    final failure = snapshot.failureFrame;
    if (failure == null ||
        failure.serial == _cardedFailureSerial ||
        snapshot.hasActiveTurn ||
        !(failure.detached ||
            snapshot.responseFailure != null ||
            snapshot.phase == NormalGatewayTurnPhase.failed)) {
      return;
    }
    _cardedFailureSerial = failure.serial;
    // Snapshots also arrive while this screen is being set up.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // A newer turn may have cleared it in the meantime.
      if (mounted && _normalSnapshot?.failureFrame?.serial == failure.serial) {
        _noteRecovery(failure.data);
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  int? _cardedFailureSerial;

  /// A recovery-v2 turn's failure frame that arrived while the turn was
  /// still live here: the card shows it once that turn settles as failed.
  Map<String, dynamic>? _liveFailureFrame;

  void _noteRecovery(Map<String, dynamic> data) {
    final message = data['message']?.toString().trim();
    final surface = FailureSurface.parse(
      data['surface'] ?? data['error_surface'] ?? data,
    );
    final text = message == null || message.isEmpty
        ? surface?.message
        : message;
    if (text == null || text.isEmpty) return;
    setState(() {
      _recoveryMessage = text;
      _recoverySurface = surface;
    });
  }

  static const Set<String> _localNewSessionNames = {'new', 'reset'};

  /// The trailing argument of a slash line (`/new My title`), empty when none.
  static String _slashCommandArgument(String text) {
    final parts = text.split(RegExp(r'\s+'));
    return parts.skip(1).join(' ').trim();
  }

  /// Opens a fresh local draft chat above this one — the mobile mirror of the
  /// desktop's local `/new`: a new session id carrying the current chat's
  /// model and project context. Like the New-chat affordance's draft, it
  /// commits to the gateway on its first prompt. Unlike the conversation
  /// browser's New button, a chat screen has no chat-space context, so the
  /// draft is not assigned to any space.
  ///
  /// With [owner], the chat belongs to another saved connection (a wake
  /// phrase of that profile): it shares nothing of this chat's project,
  /// archive or host callbacks.
  Future<void> _openFreshDraftChat(
    String title, {
    SavedConnection? owner,
  }) async {
    final now = DateTime.now();
    final sameOwner = owner == null;
    final draft = Session(
      id: GatewayChatClient.generateSessionId(),
      title: title.isEmpty ? context.l10n.new_chat : title,
      model: sameOwner ? widget.session.model : '',
      source: 'mobile',
      messageCount: 0,
      isActive: true,
      preview: '',
      startedAt: now.millisecondsSinceEpoch / 1000.0,
      isLocalDraft: true,
    );
    // /resume in the new chat opens the pick the way this chat's host opens
    // one: the new chat's route leaves first, so the pick takes the place
    // the host gives a pick from this chat (a pane, this route, the window).
    final hostOpen = widget.onOpenSession;
    late final MaterialPageRoute<void> route;
    Future<void> openFromDraft(Session picked) async {
      final navigator = route.navigator;
      if (navigator != null && route.isActive) navigator.removeRoute(route);
      await hostOpen!(picked);
    }

    // Pushed, not awaited: the returned Future completes when the new chat
    // is popped, and the command is already handled.
    Navigator.of(context).push<void>(
      route = MaterialPageRoute<void>(
        // The draft is the same product surface, so it inherits the parent's
        // archive ownership and the test seams that are safe to share. The
        // desktop connection/async-event hooks are deliberately NOT
        // forwarded: they are single-slot holders, so a second live screen
        // would steal the parent's handler in its initState and null it in
        // its dispose. Only the parent's staged attachments and its
        // session-ensure observer stay behind — both are scoped to the
        // parent session.
        builder: (_) => ChatScreen(
          connection: owner ?? widget.connection,
          session: draft,
          projectName: sameOwner ? widget.projectName : null,
          projectWorkingDirectory: sameOwner
              ? widget.projectWorkingDirectory
              : null,
          turnApplicationController: widget.turnApplicationController,
          onOpenSession: hostOpen == null || !sameOwner ? null : openFromDraft,
          onArchiveChanged: sameOwner ? widget.onArchiveChanged : null,
          sessionArchiver: sameOwner ? widget.sessionArchiver : null,
          testTurnApplicationSession: widget.testTurnApplicationSession,
          testApiClient: widget.testApiClient,
          testVoiceLiveMode: widget.testVoiceLiveMode,
          testVoiceLiveEngineFactory: widget.testVoiceLiveEngineFactory,
          testWakeController: widget.testWakeController,
          testSavedConnections: widget.testSavedConnections,
          testAttachmentDraftService: widget.testAttachmentDraftService,
          testRemotePromptSubmit: widget.testRemotePromptSubmit,
          testNormalResume: widget.testNormalResume,
          testServerFilePicker: widget.testServerFilePicker,
          testRemoteAttachmentUpload: widget.testRemoteAttachmentUpload,
          testComposerDraftReader: widget.testComposerDraftReader,
          testVoiceComposerAdapter: widget.testVoiceComposerAdapter,
          testVoiceRecorder: widget.testVoiceRecorder,
          testVoiceTranscription: widget.testVoiceTranscription,
          testHandsFreePlatform: widget.testHandsFreePlatform,
          testVoiceReplySpeaker: widget.testVoiceReplySpeaker,
          testBargeInMonitor: widget.testBargeInMonitor,
          testTurnNotifications: widget.testTurnNotifications,
          testProjectOverviewLoader: widget.testProjectOverviewLoader,
          testLegacyProjectSessionEnsure: widget.testLegacyProjectSessionEnsure,
          testStoredSessionKey: widget.testStoredSessionKey,
          testMediaFilesClient: widget.testMediaFilesClient,
          testTaskHistorySource: widget.testTaskHistorySource,
          testSlashGateway: widget.testSlashGateway,
        ),
      ),
    );
  }

  /// 4018 is also used for quick-command failures and dispatch-required
  /// skills. Learn only an explicit verdict or the legacy not-a-command form.
  /// Shared with NextGen ([isSlashCommandRefusal]).
  static bool _isSlashCommandRefusal(JsonRpcError error) =>
      isSlashCommandRefusal(error);

  /// The transport timed out or dropped after the write: the gateway may still
  /// be running the command. Same uncertainty rule as `session.steer` (#191).
  static bool _isSlashDeliveryUnknown(JsonRpcError error) =>
      isSlashDeliveryUnknown(error);

  void _showSlashDeliveryUnknown() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.slash_command_delivery_unknown)),
    );
  }

  void _showSlashCommandFailure(String message) {
    if (!mounted) return;
    final text = message.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text.isEmpty ? context.l10n.slash_command_failed : text),
      ),
    );
  }

  /// Command output is local context, never an assistant turn: it is rendered
  /// as a notice card and never enters request history.
  void _appendSlashCommandNotice(String command, String output) {
    final notice = SlashCommandNotice(
      command: command,
      output: output,
      observedAt: DateTime.now().millisecondsSinceEpoch,
    );
    setState(() {
      _slashNotices.add(notice);
      if (_slashNotices.length > 20) _slashNotices.removeAt(0);
      _savedSlashNotices[_gatewayNoticeIdentity] = List.unmodifiable(
        _slashNotices,
      );
    });
    _scheduleStreamingFollow();
  }

  Future<void> _sendWhileWorking(String text) async {
    final normal = _normalChat;
    if (normal?.snapshot.hasActiveTurn == true) {
      if (!normal!.canSteer) return;
      final revision = _composerRevision;
      setState(() => _midTurnSendInFlight = true);
      try {
        final accepted = await normal.steer(text);
        if (!mounted) return;
        if (accepted) {
          // An acknowledgement consumes only the submitted edit. Typing,
          // clearing or changing route ownership while it waits wins.
          if (_draftWriter.isCurrent && revision == _composerRevision) {
            _setRestoredComposer('');
          }
          _commitComposerForSend();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              accepted
                  ? context.l10n.message_queued_for_running_turn
                  : context.l10n.running_message_not_accepted,
            ),
          ),
        );
      } catch (error) {
        if (!mounted) return;
        final rejected =
            error is JsonRpcError &&
            const [-32601, 4001, 4002, 4010].contains(error.code);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              rejected
                  ? context.l10n.running_message_not_accepted
                  : context.l10n.running_message_delivery_unknown,
            ),
          ),
        );
      } finally {
        if (mounted) setState(() => _midTurnSendInFlight = false);
      }
      return;
    }

    // The OpenAI-compatible SSE transport has no steerable run handle.
    // Use the existing explicit Stop contract before sending a new prompt;
    // never start a second stream over the active response. The button names
    // this fallback "Stop and send" rather than claiming non-interruption.
    setState(() => _midTurnSendInFlight = true);
    var ownsHandoff = true;
    _clearComposerForSend(text);
    try {
      _parkHeldOnStop = false;
      final stopped = await _stopResponse();
      if (!mounted) return;
      if (!stopped) {
        _restoreComposerAfterRejectedSend(text);
        return;
      }
      // _submitMessage synchronously takes ownership of the next stream.
      // Release this short handoff flight, not the lifetime of the new run.
      _midTurnSendInFlight = false;
      ownsHandoff = false;
      await _submitMessage(
        text: text,
        attachments: const [],
        speakResponse: false,
      );
    } finally {
      if (mounted && ownsHandoff) {
        setState(() => _midTurnSendInFlight = false);
      }
    }
  }

  Future<WidgetHtmlSource?> _readWidgetHtml(String path) async {
    final client = _newMediaFilesClient();
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

  Future<void> _deliverWidgetIntent(String prompt) async {
    if (_sending || _streaming || _preparingSend || _voiceComposer.listening) {
      throw StateError('undelivered');
    }
    await _sendMessage(textOverride: prompt, hiddenIntent: true);
  }

  Future<void> _submitMessage({
    required String text,
    required List<AttachmentDraft> attachments,
    required bool speakResponse,
    _HandsFreeTurnBinding? voiceBinding,
    bool preserveComposer = false,
    VoidCallback? onAccepted,
    bool hiddenIntent = false,
    bool heldUntilAccepted = false,
    Map<String, Object?> promptParams = const {},
  }) async {
    final keepComposer = preserveComposer || voiceBinding != null;
    // A remote-gateway profile uses one transport for every prompt. Images and
    // arbitrary files are both attached with the official `file.attach` RPC.
    // A regenerate (truncation params) always goes through the stock owner:
    // the recovery-v2 submit has no truncation.
    if (_turnApplicationSession != null &&
        !_legacyTransportFallback &&
        promptParams.isEmpty) {
      await _sendRecoverableGatewayMessage(
        text: text,
        attachments: attachments,
        speakResponse: speakResponse,
        voiceBinding: voiceBinding,
        preserveComposer: keepComposer,
        onAccepted: onAccepted,
        hiddenIntent: hiddenIntent,
        heldUntilAccepted: heldUntilAccepted,
      );
      return;
    }
    if (_desktopGateway != null || widget.testRemotePromptSubmit != null) {
      await _sendDesktopGatewayMessage(
        text: text,
        attachments: attachments,
        speakResponse: speakResponse,
        voiceBinding: voiceBinding,
        preserveComposer: keepComposer,
        onAccepted: onAccepted,
        heldUntilAccepted: heldUntilAccepted,
        promptParams: promptParams,
      );
      return;
    }
    // Only the Desktop gateway truncates: _retryPrompt never sends a
    // regenerate down another transport.
    assert(promptParams.isEmpty);

    final pendingImage = attachments.firstOrNull;
    String? imageDataUrl;
    if (pendingImage != null) {
      setState(() => _sending = true);
      try {
        imageDataUrl = await _attachmentDraftService.readDataUrl(pendingImage);
      } catch (_) {
        if (mounted) setState(() => _sending = false);
        if (!mounted) return;
        if (!heldUntilAccepted) _restoreComposerAfterRejectedSend(text);
        _showAttachmentError(
          context.l10n.unable_to_read_the_selected_image_the_selection_was_kept,
        );
        return;
      }
      if (!mounted) return;
    }

    final localContent = pendingImage == null
        ? text
        : <Map<String, dynamic>>[
            if (text.isNotEmpty) {'type': 'text', 'text': text},
            {
              'type': 'image_url',
              'image_url': {'url': imageDataUrl},
            },
          ];

    if (!keepComposer) _commitComposerForSend();
    _expectVoiceReply(speakResponse);
    final responseGeneration = ++_responseGeneration;
    voiceBinding?.responseGeneration = responseGeneration;
    _activeResponseTransport = _ResponseTransport.rest;

    // The server returns oldest-to-newest history. Preserve that order; the
    // gateway client appends the current prompt exactly once.
    final history = buildRestChatHistory(_messages);
    final replyRetention = RestChatReplyRetention.admit(
      _messages,
      historyKnown: _hasSuccessfulHistoryRead,
    );
    _scrollCoordinator.beginStreaming(isNearEnd: _isNearEnd());

    setState(() {
      _sending = true;
      _streaming = true;
      _terminalTurnNotice = null;
      _gatewayTurnStatus = GatewayTurnStatus(
        kind: 'starting',
        text: context.l10n.starting_hermes,
      );
      _messages.add({
        'role': 'user',
        'content': localContent,
        AndroidPromptContext.localUserTextKey: true,
        ChatMessageTime.observedAtKey: DateTime.now().millisecondsSinceEpoch,
        ChatMessageTime.sourceKey: 'sent',
        AndroidPromptContext.wireContentKey: GatewayChatClient.buildUserContent(
          message: text,
          imageDataUrl: imageDataUrl,
        ),
        if (hiddenIntent) 'display_kind': 'hidden',
      });
      // Insert a placeholder streaming message
      _messages.add({
        'role': 'assistant',
        'content': '',
        '_gateway_pending_response': true,
      });
    });

    _scheduleStreamingFollow();

    // Keep the exact admitted SSE output, not the latest assistant after a GET.
    final voiceResponse = StringBuffer();
    // Accumulate tokens into the streaming placeholder.
    // Register this API-server send as app-wide turn activity so
    // Settings → Background work can engage the foreground service on the
    // stock-gateway REST transport (issue #225). The token is released when
    // the stream settles — terminal, error, superseded or cancelled.
    final legacyTurn = _viewController.beginLegacyTurn();
    try {
      await _gateway.sendMessageStreaming(
        message: text,
        sessionId: widget.session.id,
        // The OpenAI-compatible endpoint does not consume the API session's
        // persisted Browser lock. Carry both ids on API-only turns so duplicate
        // model names cannot silently fall back to another provider. Desktop
        // Gateway keeps its existing model-only request behaviour.
        model: _sessionModelOverride ? _sessionModel : null,
        provider: _desktopGateway == null && _sessionModelOverride
            ? _sessionProvider
            : null,
        history: history,
        imageDataUrl: imageDataUrl,
        onToken: (token) {
          if (!mounted || responseGeneration != _responseGeneration) return;
          if (token.isNotEmpty) onAccepted?.call();
          voiceResponse.write(token);
          setState(() {
            _gatewayTurnStatus = null;
            if (_messages.isNotEmpty && _messages.last['role'] == 'assistant') {
              final assistant = _messages.last;
              final current = assistant['content'] as String;
              if (current.isEmpty && token.isNotEmpty) {
                _registerMaterializedAssistantMessage();
              }
              assistant['content'] = current + token;
              if (token.isNotEmpty) {
                ChatMessageTime.observe(
                  assistant,
                  source: ChatMessageTimeSource.received,
                );
              }
              _timeline = _timeline.appendText(assistant, token);
              _retainReceiptPresentation();
            }
          });
          _scheduleStreamingFollow();
        },
        onToolProgress: (progress) {
          if (!mounted || responseGeneration != _responseGeneration) return;
          if (progress.isNotEmpty) onAccepted?.call();
          _upsertToolProgress(
            progress,
            eventType: progress['status'] == 'running'
                ? 'tool.start'
                : 'tool.update',
          );
        },
        onReasoning: (text) => _handleDesktopGatewayEvent(
          StreamEvent(type: 'reasoning.delta', data: {'text': text}),
          responseGeneration,
        ),
        onStatus: (status) => _handleDesktopGatewayEvent(
          StreamEvent(type: 'status.update', data: status),
          responseGeneration,
        ),
        onApproval: (approval) {
          if (!mounted || responseGeneration != _responseGeneration) return;
          _showGatewayApproval(approval, responseGeneration);
        },
        onDone: () async {
          if (!mounted || responseGeneration != _responseGeneration) return;
          onAccepted?.call();
          _playCompletionCue();
          // The SSE client requires an explicit successful protocol completion.
          final assistant = _lastAssistantMessage();
          setState(() {
            assistant?['_chat_response_complete'] = true;
            if (assistant != null) {
              ChatMessageTime.observe(
                assistant,
                source: ChatMessageTimeSource.received,
              );
            }
            assistant?['_gateway_pending_response'] = false;
            replyRetention.complete(_messages);
            _restReplyRetention = replyRetention;
            _sending = false;
            _streaming = false;
            _gatewayTurnStatus = null;
          });
          if (voiceBinding != null &&
              voiceBinding.responseGeneration == responseGeneration) {
            _finishVoiceTurn(
              voiceBinding,
              HandsFreeTurnStatus.completed,
              stripToolResultText(voiceResponse.toString()).trim(),
            );
          }
          // Refresh messages to get the final server-side state. The token is
          // retained across both HTTP and attachment cleanup, including failure.
          final read = _beginHistoryRead(widget.session.id);
          try {
            final messages = await _getRecentMessages(read);
            if (!_canApplyHistoryRead(read)) return;
            if (pendingImage != null) {
              await _attachmentDraftService.removeCachedFile(pendingImage);
            }
            if (!_acceptHistoryRead(read, messages)) return;
            _acceptRecentMessages(messages);
            setState(() {
              _messages = _restHistoryForPresentation();
              if (pendingImage != null) {
                _attachmentDrafts.removeWhere(
                  (draft) => draft.id == pendingImage.id,
                );
              }
              _streaming = false;
              _sending = false;
              _gatewayTurnStatus = null;
              _activeResponseTransport = _ResponseTransport.none;
            });
            _scheduleScrollTarget(_scrollCoordinator.endStreaming());
            var voiceSpoke = false;
            if (_awaitingVoiceReply) {
              _awaitingVoiceReply = false;
              final assistant = messages.reversed.firstWhere(
                (message) => message['role'] == 'assistant',
                orElse: () => const <String, dynamic>{},
              );
              final assistantText = assistant['content']?.toString();
              if (assistantText != null) {
                if (assistant['id'] case final id?) {
                  AutoReadLedger.claim(_autoReadChatKey, ['row:$id']);
                }
                await _speakAssistantText(assistantText);
                voiceSpoke = true;
              }
            }
            if (!voiceSpoke && autoSpeakRepliesEnabled.value) {
              // Ordinary typed turn: auto-read the terminal reply, once by
              // its durable id. (This runs once per finished send; a row
              // with no id is still read that once.)
              final assistant = messages.reversed.firstWhere(
                (message) => message['role'] == 'assistant',
                orElse: () => const <String, dynamic>{},
              );
              final rawContent = assistant['content'];
              String? assistantText;
              if (rawContent is String) {
                assistantText = rawContent.trim();
              } else if (rawContent != null) {
                assistantText = rawContent.toString().trim();
              }
              final rowId = assistant['id'];
              if (assistantText != null &&
                  assistantText.isNotEmpty &&
                  (rowId == null ||
                      AutoReadLedger.claim(_autoReadChatKey, ['row:$rowId']))) {
                await _speakAssistantText(assistantText);
              }
            }
          } catch (_) {
            if (!_canApplyHistoryRead(read)) return;
            _scrollCoordinator.cancelStreaming();
            setState(() {
              if (_messages.isNotEmpty &&
                  _messages.last['role'] == 'assistant') {
                _messages.last['_gateway_pending_response'] = false;
              }
              _streaming = false;
              _sending = false;
              _gatewayTurnStatus = null;
              _activeResponseTransport = _ResponseTransport.none;
            });
            // The SSE response completed, so the server accepted the prompt.
            // A follow-up history read failing must not resurrect it as a draft.
            _deferHistoryRefresh();
          } finally {
            // Completing this REST operation is independent of the freshness of
            // its history GET. If a newer success superseded that GET, release
            // only the still-owned stream latch, without touching its transcript,
            // error, status or scroll. Never strand Send behind a discarded read.
            if (_historyReadAttached(read) &&
                responseGeneration == _responseGeneration &&
                _activeResponseTransport == _ResponseTransport.rest) {
              setState(() {
                _streaming = false;
                _sending = false;
                _activeResponseTransport = _ResponseTransport.none;
              });
            }
          }
          await _drainHeldIfIdle();
        },
        onError: (error) {
          if (!mounted || responseGeneration != _responseGeneration) return;
          // No streamed content means the request never reached the server
          // (connection failure, non-200): restore the draft so nothing typed
          // is lost. Content already flowing means the prompt was accepted.
          final hadContent =
              _messages.isNotEmpty &&
              _messages.last['role'] == 'assistant' &&
              (_messages.last['content']?.toString().isNotEmpty ?? false);
          // Remove the placeholder assistant message
          setState(() {
            if (_messages.isNotEmpty && _messages.last['role'] == 'assistant') {
              _messages.removeLast();
            }
          });
          if (!hadContent && !keepComposer && !heldUntilAccepted) {
            _restoreComposerAfterRejectedSend(text);
          }
          if (voiceBinding != null) {
            _finishVoiceTurn(voiceBinding, HandsFreeTurnStatus.failed);
          }
          _held.park();
          if (mounted) setState(() {});
          _handleSendError(error, removePendingUserMessage: true);
        },
      );
    } finally {
      _viewController.endLegacyTurn(legacyTurn);
    }
  }

  String _clearedImageText = '';

  PreparedImageTarget? get _imageTarget {
    if (!_usesNormalInputOwner ||
        _desktopGateway == null ||
        _normalSession?.hasCurrentAccount != true) {
      return null;
    }
    final stored =
        _normalChat?.storedSessionId ??
        _desktopGateway?.storedSessionKeyFor(_normalLocalSessionKey) ??
        (widget.session.isLocalDraft ? null : widget.session.id);
    return stored == null
        ? null
        : PreparedImageTarget(
            widget.connection,
            stored,
            PreparedImageTransport.classicRefs,
          );
  }

  ImageRecoveryGap? get _imageRecoveryGap {
    if (_usesNormalInputOwner) return null;
    if (_turnApplicationSession != null && !_legacyTransportFallback) {
      return ImageRecoveryGap.recoveryV2;
    }
    return ImageRecoveryGap.restSse;
  }

  bool get _quietImageComposer =>
      mounted &&
      widget.active &&
      _draftWriter.isCurrent &&
      !_sending &&
      !_streaming &&
      !_preparingSend &&
      !_preparingPaste &&
      !_pendingReattachResync &&
      !_voiceRecording.hasDraft &&
      !_voiceRecording.recording &&
      !_voiceRecording.busy &&
      !_voiceComposer.listening &&
      !_startingVoiceInput &&
      _attachmentDrafts.any((d) => d.isImage);

  Object? _imageRestoreRevision() =>
      mounted &&
          widget.active &&
          _draftWriter.isCurrent &&
          !_sending &&
          !_streaming &&
          !_preparingSend &&
          !_preparingPaste &&
          !_pendingReattachResync &&
          !_voiceRecording.hasDraft &&
          !_voiceRecording.recording &&
          !_voiceRecording.busy &&
          !_voiceComposer.listening &&
          !_startingVoiceInput &&
          _textController.text.isEmpty &&
          _attachmentDrafts.isEmpty &&
          _imageTarget != null
      ? (
          _normalChat,
          _imageTarget!.key,
          _composerRevision,
          _draftWriter.revision,
        )
      : null;

  Future<void> _sendDesktopGatewayMessage({
    required String text,
    required List<AttachmentDraft> attachments,
    required bool speakResponse,
    _HandsFreeTurnBinding? voiceBinding,
    bool preserveComposer = false,
    VoidCallback? onAccepted,
    bool heldUntilAccepted = false,
    Map<String, Object?> promptParams = const {},
  }) async {
    final l10n = context.sharedL10n;
    final keepComposer = preserveComposer || voiceBinding != null;
    final chat = _normalChat;
    if (chat == null) return;
    final reservation = _normalReservation ?? chat.reserve();
    if (reservation == null) {
      if (!keepComposer) _restoreComposerAfterRejectedSend(text);
      voiceBinding?.finish(HandsFreeTurnStatus.failed);
      return;
    }
    _normalReservation = reservation;
    _noteGitTurnStarted();
    final desktopGateway = _desktopGateway;
    final responseGeneration = _responseGeneration;
    final pastedIds = attachments
        .where((draft) => _pastedDraftTexts.containsKey(draft.id))
        .map((draft) => draft.id)
        .toSet();
    final recoveryText = keepComposer ? text : _composerTextWithPastes(text);
    final imageText = _clearedImageText;
    final journalImages =
        !keepComposer &&
        desktopGateway != null &&
        PreparedImageStore.supports(imageText, attachments);
    PreparedImageCapture? capture;
    var handedOff = false;
    _expectVoiceReply(speakResponse);
    try {
      final projectCwd = widget.projectWorkingDirectory?.trim();
      if (widget.session.isLocalDraft && projectCwd?.isNotEmpty == true) {
        if (desktopGateway != null) {
          await desktopGateway.ensureSession(
            _normalLocalSessionKey,
            workingDirectory: projectCwd,
          );
        } else {
          await widget.testLegacyProjectSessionEnsure?.call(
            widget.session.id,
            projectCwd!,
          );
        }
      }
      if (!mounted || responseGeneration != _responseGeneration) return;
      if (desktopGateway != null) {
        await _applySessionModelOverride(desktopGateway);
      }
      if (!mounted || responseGeneration != _responseGeneration) return;
      if (journalImages &&
          _imageTarget == null &&
          widget.session.isLocalDraft) {
        await desktopGateway.ensureSession(_normalLocalSessionKey);
        if (!mounted || responseGeneration != _responseGeneration) return;
      }
      final beforeUpload = _imageTarget;
      final adopted = journalImages && beforeUpload != null
          ? await PreparedImageStore.shared.adopt(
              beforeUpload,
              imageText,
              attachments,
            )
          : null;
      if (journalImages && adopted == null) {
        if (beforeUpload == null) throw const PreparedImageException();
        capture = await PreparedImageStore.shared.capture(
          attachments,
          beforeUpload: (target: beforeUpload, text: imageText),
        );
      }
      if (!mounted || responseGeneration != _responseGeneration) return;
      await _attachmentSendCoordinator.uploadThenSubmit(
        drafts: adopted == null ? capture?.drafts ?? attachments : const [],
        retainUploadedFiles: capture != null,
        upload: ({required draft, required dataUrl}) async {
          if (!mounted || responseGeneration != _responseGeneration) {
            throw UiMessageException(
              l10n.release_chat_attachment_preparation_cancelled,
            );
          }
          if (desktopGateway == null) {
            final upload = widget.testRemoteAttachmentUpload;
            if (upload == null) {
              throw StateError('Test remote transport does not upload files');
            }
            return upload(draft: draft, dataUrl: dataUrl);
          }
          return _uploadAttachmentDraft(desktopGateway, draft, dataUrl);
        },
        onChanged: (draft) {
          if (!mounted || responseGeneration != _responseGeneration) return;
          setState(() {
            _gatewayTurnStatus = GatewayTurnStatus(
              kind: 'upload',
              text: context.l10n.preparing_attachments,
            );
          });
        },
        submitPrompt: (refTexts) async {
          if (!mounted || responseGeneration != _responseGeneration) return;
          if (voiceBinding != null &&
              !_handsFree.isCurrent(voiceBinding.prompt.authority)) {
            voiceBinding.finish(HandsFreeTurnStatus.unknown);
            return;
          }
          final prompt =
              adopted?.entry.prompt ??
              [
                text,
                refTexts.join('\n'),
              ].where((part) => part.trim().isNotEmpty).join('\n\n');
          final target = _imageTarget;
          PreparedImageAttempt? attempt = adopted;
          if (journalImages) {
            if (target == null ||
                (adopted != null && adopted.entry.target.key != target.key)) {
              throw const PreparedImageException();
            }
            attempt ??= await PreparedImageStore.shared.prepare(
              target,
              imageText,
              capture!,
              prompt: prompt,
            );
            if (!mounted ||
                responseGeneration != _responseGeneration ||
                _imageTarget?.key != target.key) {
              return;
            }
          }
          final labels = attachments
              .map((file) => '[${context.l10n.attached_file}: ${file.name}]')
              .join('\n');
          final localContent = [
            text,
            labels,
            // Keep gateway audio references in the optimistic user row too;
            // filename-only labels cannot resolve playback before hydration.
            for (final ref in refTexts)
              if (audioPromptFileRefs(ref).isNotEmpty) ref,
          ].where((part) => part.trim().isNotEmpty).join('\n\n');
          final testSubmit = widget.testRemotePromptSubmit;
          final knownStored =
              widget.testStoredSessionKey?.call(widget.session.id) ??
              _storedSessionId ??
              (widget.session.isLocalDraft && desktopGateway != null
                  ? null
                  : widget.session.id);
          if (!keepComposer) {
            _attachmentDrafts.clear();
            _pastedDraftTexts.removeWhere((id, _) => pastedIds.contains(id));
            _commitComposerForSend();
          }
          handedOff = true;
          _normalReservation = null;
          // All post-handoff callbacks and error/recovery handling live on the
          // app owner. This await's UI continuation is fenced on reattachment.
          final submitted = chat.submitPrepared(
            reservation: reservation,
            imageAttempt: attempt,
            onAccepted: onAccepted,
            text: prompt,
            localContent: localContent,
            submit: testSubmit,
            knownStoredSessionId: knownStored,
            rawDraftText: keepComposer ? null : recoveryText,
            canRestoreDraft:
                !keepComposer && _composerRevision == _clearedComposerRevision,
            draftHandle: keepComposer ? null : _draftWriter.draftHandle,
            maySubmit: voiceBinding == null
                ? null
                : () => _handsFree.isCurrent(voiceBinding.prompt.authority),
            promptParams: promptParams,
          );
          final submittedTurn = chat.snapshot.turnId;
          await submitted;
          // submitPrepared throws for definitely pre-wire failures (the catch
          // below keeps the originals). Otherwise the journal owns recovery.
          if (attempt != null) {
            await _attachmentDraftService.removeAll(attachments);
          }
          final terminal = chat.snapshot.terminal;
          if (terminal?.turnId == submittedTurn &&
              terminal?.completed == true) {
            onAccepted?.call();
          }
        },
      );
      if (!mounted || responseGeneration != _responseGeneration) return;
    } catch (error) {
      if (!mounted || responseGeneration != _responseGeneration) return;
      // Only definitely pre-wire rejection restores this route's captured
      // revision. Post-wire errors are absorbed as unresolved by the owner.
      if (!chat.snapshot.wireEmitted) {
        if (!keepComposer) {
          setState(() {
            _attachmentDrafts
              ..clear()
              ..addAll(
                attachments.where(
                  (draft) => !handedOff || !pastedIds.contains(draft.id),
                ),
              );
          });
        }
        if (!keepComposer && !heldUntilAccepted) {
          _restoreComposerAfterRejectedSend(handedOff ? recoveryText : text);
        }
        voiceBinding?.finish(HandsFreeTurnStatus.failed);
        _handleSendError(error);
        unawaited(_refreshDeferredHistoryIfIdle());
      }
    } finally {
      if (!handedOff) {
        chat.cancelPreparation(reservation);
        voiceBinding?.finish(HandsFreeTurnStatus.failed);
      }
      if (identical(_normalReservation, reservation)) _normalReservation = null;
      await capture?.close();
    }
  }

  Future<void> _sendRecoverableGatewayMessage({
    required String text,
    required List<AttachmentDraft> attachments,
    required bool speakResponse,
    _HandsFreeTurnBinding? voiceBinding,
    bool preserveComposer = false,
    VoidCallback? onAccepted,
    bool hiddenIntent = false,
    bool heldUntilAccepted = false,
  }) async {
    final keepComposer = preserveComposer || voiceBinding != null;
    final turnSession = _turnApplicationSession;
    if (turnSession == null) return;
    _noteGitTurnStarted();
    _expectVoiceReply(speakResponse);
    final responseGeneration = ++_responseGeneration;
    _activeResponseTransport = _ResponseTransport.desktop;
    final staged = <GatewayTurnAttachmentReceipt>[];
    var attachmentCacheReleased = false;

    void releaseAcceptedAttachmentCache(GatewayTurnRecoveryState state) {
      if (attachmentCacheReleased ||
          state.turnId == null ||
          state.ackUncertain) {
        return;
      }
      attachmentCacheReleased = true;
      onAccepted?.call();
      unawaited(_attachmentDraftService.removeAll(attachments));
    }

    void onState(GatewayTurnRecoveryState state) {
      if (voiceBinding != null) _bindRecoveryVoiceTurn(voiceBinding, state);
      releaseAcceptedAttachmentCache(state);
      if (!mounted || responseGeneration != _responseGeneration) return;
      _applyGatewayTurnState(state);
    }

    setState(() {
      _sending = true;
      _gatewayTurnStatus = GatewayTurnStatus(
        kind: 'upload',
        text: context.l10n.preparing_attachments,
      );
    });

    try {
      for (var index = 0; index < attachments.length; index++) {
        final draft = attachments[index];
        setState(() {
          draft
            ..status = AttachmentDraftStatus.uploading
            ..error = null;
          _gatewayTurnStatus = GatewayTurnStatus(
            kind: 'upload',
            text: context.l10n.uploading(
              index + 1,
              draft.name,
              attachments.length,
            ),
          );
        });
        final dataUrl = await _attachmentDraftService.readDataUrl(draft);
        final receipt = await turnSession.stageAttachment(
          localSessionId: widget.session.id,
          clientAttachmentId: draft.id,
          name: draft.name,
          dataUrl: dataUrl,
          byteLength: draft.byteLength,
          mediaType: draft.mediaType,
          kind: draft.isImage
              ? GatewayTurnAttachmentKind.image
              : GatewayTurnAttachmentKind.file,
        );
        staged.add(receipt);
        if (!mounted || responseGeneration != _responseGeneration) return;
        setState(() => draft.status = AttachmentDraftStatus.attached);
      }
    } catch (error) {
      if (staged.isNotEmpty) {
        try {
          await turnSession.detachAttachments(
            localSessionId: widget.session.id,
            attachments: staged,
          );
        } catch (_) {
          // Closing or quarantining the coordinator also invalidates receipts.
        }
      }
      if (!mounted || responseGeneration != _responseGeneration) return;
      for (final draft in attachments) {
        draft
          ..status = AttachmentDraftStatus.ready
          ..error = null;
      }
      if (!heldUntilAccepted) _restoreComposerAfterRejectedSend(text);
      _handleSendError(error);
      unawaited(_refreshDeferredHistoryIfIdle());
      return;
    }

    final attachmentLabels = attachments
        .map(
          (attachment) => '[${context.l10n.attached_file}: ${attachment.name}]',
        )
        .join('\n');
    final localContent = [
      text,
      attachmentLabels,
    ].where((part) => part.trim().isNotEmpty).join('\n\n');
    if (!keepComposer) {
      _attachmentDrafts.clear();
      _commitComposerForSend();
    }
    _scrollCoordinator.beginStreaming(isNearEnd: _isNearEnd());
    final firstState = Completer<void>();
    _recoverableSubmissionState = firstState;
    setState(() {
      _streaming = true;
      _gatewayTurnStatus = GatewayTurnStatus(
        kind: 'starting',
        text: context.l10n.starting_hermes,
      );
      _messages.add({
        'role': 'user',
        'content': localContent,
        AndroidPromptContext.localUserTextKey: true,
        ChatMessageTime.observedAtKey: DateTime.now().millisecondsSinceEpoch,
        ChatMessageTime.sourceKey: 'sent',
        if (hiddenIntent) 'display_kind': 'hidden',
      });
      _messages.add({
        'role': 'assistant',
        'content': '',
        '_gateway_pending_response': true,
      });
    });
    _scheduleStreamingFollow();

    try {
      final state = await (voiceBinding == null
          ? turnSession.submit(
              localSessionId: widget.session.id,
              text: text,
              attachments: staged,
              onState: onState,
            )
          : submitGuardedGatewayTurn(
              turnSession,
              localSessionId: widget.session.id,
              text: text,
              onState: onState,
              maySubmit: () =>
                  _handsFree.isCurrent(voiceBinding.prompt.authority),
            ));
      if (voiceBinding != null) _bindRecoveryVoiceTurn(voiceBinding, state);
      releaseAcceptedAttachmentCache(state);
      if (!mounted || responseGeneration != _responseGeneration) return;
      _applyGatewayTurnState(state);
    } catch (error) {
      if (!mounted || responseGeneration != _responseGeneration) return;
      if (voiceBinding != null) {
        _finishVoiceTurn(
          voiceBinding,
          error is GatewayTurnAdmissionRevoked
              ? HandsFreeTurnStatus.interrupted
              : HandsFreeTurnStatus.failed,
        );
      }
      if (error is GatewayTurnAdmissionRevoked ||
          gatewayTurnSubmissionWasDefinitelyRejected(error)) {
        setState(() {
          if (_messages.isNotEmpty &&
              _messages.last['role'] == 'assistant' &&
              _messages.last['_gateway_pending_response'] == true) {
            _messages.removeLast();
          }
          if (_messages.isNotEmpty && _messages.last['role'] == 'user') {
            _messages.removeLast();
          }
          for (final draft in attachments) {
            draft
              ..status = AttachmentDraftStatus.ready
              ..error = null;
          }
          if (!keepComposer) {
            _attachmentDrafts
              ..clear()
              ..addAll(attachments);
          }
        });
        if (!keepComposer && !heldUntilAccepted) {
          _restoreComposerAfterRejectedSend(text);
        }
        _handleSendError(error);
        unawaited(_refreshDeferredHistoryIfIdle());
        return;
      }
      setState(() {
        _gatewayTurnStatus = GatewayTurnStatus(
          kind: 'recovery',
          text: context.l10n.delivery_is_uncertain_recovering_without_resending,
        );
      });
      await _recoverPendingTurn();
    } finally {
      // Definite rejection or failed recovery may produce no callback. Release
      // a queued Stop without inventing an identity or issuing a legacy RPC.
      if (!firstState.isCompleted) firstState.complete();
      if (identical(_recoverableSubmissionState, firstState)) {
        _recoverableSubmissionState = null;
      }
    }
  }

  /// Context compression moves the chat to a continuation session, and
  /// `session.info` names it (`stored_session_id`). Cards made from then on
  /// carry that id, cards made before keep the old one: the Kanban strip
  /// counts both as this chat's.
  void _adoptCompressedSessionId(Map<String, dynamic> data) {
    final info = data['info'] is Map ? data['info'] as Map : data;
    final stored = info['stored_session_id'];
    if (stored is String && stored.trim().isNotEmpty) {
      _kanbanDock.setChat(primaryId: null, aliases: [stored]);
    }
  }

  void _adoptRouteEffort(Map<String, dynamic> data) {
    final info = data['info'] is Map
        ? Map<String, dynamic>.from(data['info'] as Map)
        : data;
    if (!info.containsKey('reasoning_effort') &&
        !info.containsKey('reasoning_effort_wire')) {
      return;
    }
    setState(() {
      final effort = info['reasoning_effort']?.toString();
      if (effort != null && effort.isNotEmpty) {
        _sessionReasoningEffort = effort;
      }
      if (info.containsKey('reasoning_effort_wire')) {
        _sessionReasoningWire = info['reasoning_effort_wire']?.toString() ?? '';
      } else if (info.containsKey('reasoning_effort')) {
        _sessionReasoningWire = '';
      }
    });
  }

  void _handleDesktopGatewayEvent(StreamEvent event, int responseGeneration) {
    if (!mounted || responseGeneration != _responseGeneration) return;
    if (event.type == 'session.info') {
      _adoptCompressedSessionId(event.data);
      _adoptRouteEffort(event.data);
      return;
    }
    final reasoning = GatewayReasoningUpdate.fromGatewayEvent(
      event.type,
      event.data,
    );
    if (reasoning != null) {
      setState(() {
        _gatewayTurnStatus = const GatewayTurnStatus(
          kind: 'reasoning',
          text: '',
        );
        final assistant = _lastAssistantMessage();
        if (assistant == null) return;
        final current = assistant['_gateway_reasoning']?.toString() ?? '';
        assistant['_gateway_reasoning'] = reasoning.applyTo(current);
        _timeline = _timeline.reasoning(assistant, reasoning);
        _retainReceiptPresentation();
        assistant['_gateway_reasoning_verbose'] = reasoning.verbose;
        assistant['_gateway_reasoning_replaces'] =
            assistant['_gateway_reasoning_replaces'] == true ||
            reasoning.mode == GatewayReasoningEventMode.replace;
      });
      _scheduleStreamingFollow();
      return;
    }
    final turnStatus = GatewayTurnStatus.fromGatewayEvent(
      event.type,
      event.data,
    );
    if (turnStatus != null) {
      setState(() => _gatewayTurnStatus = turnStatus);
      _scheduleStreamingFollow();
      return;
    }
    if (event.type == 'approval.request') {
      _showGatewayApproval(event.data, responseGeneration);
      return;
    }
    if (event.type == 'clarify.request') {
      _queueClarifyPrompt(event.data, responseGeneration);
      return;
    }
    if (event.type == 'connection.request' ||
        event.type == 'connection.update') {
      final next = CatalogOperation.merge(
        _catalog,
        event.data,
        opens: event.type == 'connection.request',
      );
      if (!identical(next, _catalog) && mounted) {
        setState(() => _catalog = next);
      }
      return;
    }
    if (event.type == 'setup_beat.request') {
      final id =
          (event.data['server_request_id'] ?? event.data['request_id'])
              ?.toString() ??
          '';
      final request = SetupBeatRequest.parse(id, event.data);
      if (request != null && mounted) setState(() => _setupBeat = request);
      return;
    }
    if (event.type == 'clarify.remaining') {
      _reconcileClarifyPrompts(event);
      return;
    }
    if (event.type == 'sudo.request' || event.type == 'secret.request') {
      _queueSensitivePrompt(event, responseGeneration);
      return;
    }
    if (event.type == 'sudo.expire' || event.type == 'secret.expire') {
      _expireSensitivePrompt(event);
      return;
    }
    if (event.type == 'request.cancel') {
      _cancelGatewayServerRequest(event);
      return;
    }
    if (event.type == 'message.start') {
      _lastAssistantMessage()?.remove('_gateway_interim_boundary');
      return;
    }
    if (event.type == 'message.delta') {
      final token = event.data['text']?.toString() ?? '';
      if (token.isEmpty) return;
      setState(() {
        _gatewayTurnStatus = null;
        final assistant = _lastAssistantMessage();
        if (assistant == null) return;
        final current = assistant['content']?.toString() ?? '';
        if (current.isEmpty) _registerMaterializedAssistantMessage();
        assistant['content'] = '$current$token';
        _timeline = _timeline.appendText(assistant, token);
        _retainReceiptPresentation();
      });
      _scheduleStreamingFollow();
      return;
    }
    if (event.type == 'message.interim') {
      final interim = event.data['text']?.toString() ?? '';
      setState(() {
        _gatewayTurnStatus = null;
        final assistant = _lastAssistantMessage();
        if (assistant == null) return;
        final current = assistant['content']?.toString() ?? '';
        final transition = GatewayInterimTransition.resolve(
          currentText: current,
          interimText: interim,
          alreadyStreamed: event.data['already_streamed'] == true,
        );
        if (current.isEmpty && transition.sealedText.isNotEmpty) {
          _registerMaterializedAssistantMessage();
        }
        assistant['content'] = transition.sealedText;
        _timeline = _timeline.textSnapshot(assistant, transition.sealedText);
        _retainReceiptPresentation();
        if (transition.startsNewMessage) {
          assistant['_gateway_interim'] = true;
          assistant['_gateway_pending_response'] = false;
          _messages.add({
            'role': 'assistant',
            'content': '',
            '_gateway_pending_response': true,
            '_gateway_interim_boundary': true,
          });
        }
      });
      _scheduleStreamingFollow();
      return;
    }
    if (event.type == 'message.complete') {
      final completeText =
          event.data['rendered']?.toString() ??
          event.data['text']?.toString() ??
          '';
      setState(() {
        final pending = _lastAssistantMessage();
        final assistant = _completionAssistantMessage(
          event.data,
          event.data['text']?.toString() ?? completeText,
        );
        if (assistant != null) {
          assistant['_gateway_pending_response'] = false;
          assistant['_chat_response_complete'] = isSuccessfulResponseReceipt(
            event.data,
          );
          if (completeText.isNotEmpty) {
            final current = assistant['content']?.toString() ?? '';
            if (current.isEmpty) _registerMaterializedAssistantMessage();
            assistant['content'] = completeText;
            _timeline = _timeline.textSnapshot(
              assistant,
              completeText,
              preservePosition: !identical(assistant, pending),
            );
            _retainReceiptPresentation();
          }
        }
      });
      if (completeText.isNotEmpty) {
        _scheduleStreamingFollow();
      }
      return;
    }
    if (event.type.startsWith('tool.')) {
      if (event.type == 'tool.complete') {
        _kanbanDock.observeToolCall(
          name: event.data['name']?.toString() ?? '',
          args: event.data['args'],
          result: event.data['result'],
        );
      }
      _upsertToolProgress(event.data, eventType: event.type);
      return;
    }
    if (event.type.startsWith('subagent.')) {
      _upsertSubagent(event.type, event.data);
    }
  }

  Map<String, dynamic>? _completionAssistantMessage(
    Map<String, dynamic> data,
    String rawCompleteText,
  ) {
    final pendingIndex = _messages.lastIndexWhere(
      (message) => message['role'] == 'assistant',
    );
    if (pendingIndex < 0) return null;
    final pending = _messages[pendingIndex];
    if (pending['_gateway_pending_response'] != true ||
        (pending['content']?.toString() ?? '').isNotEmpty ||
        pending['_gateway_interim_boundary'] != true) {
      return pending;
    }
    // Flags describe the final response, but do not identify which interim
    // it settles. Only an exact raw-text match may consume a sealed interim.
    if (data['response_previewed'] != true &&
        data['response_transformed'] != true &&
        data['response_reused'] != true) {
      return pending;
    }
    if (rawCompleteText.isEmpty) return pending;

    // A completion settles a matching preview from this turn, not the empty
    // bubble prepared for a continuation or distinct interim commentary.
    for (var index = pendingIndex - 1; index >= 0; index--) {
      final candidate = _messages[index];
      if (candidate['role'] == 'user') break;
      if (candidate['role'] != 'assistant' ||
          candidate['_gateway_interim'] != true ||
          candidate['content'] != rawCompleteText) {
        continue;
      }
      final pendingReasoning = pending['_gateway_reasoning']?.toString() ?? '';
      if (pendingReasoning.isNotEmpty) {
        final currentReasoning =
            candidate['_gateway_reasoning']?.toString() ?? '';
        candidate['_gateway_reasoning'] = GatewayReasoningUpdate(
          text: pendingReasoning,
          mode: pending['_gateway_reasoning_replaces'] == true
              ? GatewayReasoningEventMode.replace
              : GatewayReasoningEventMode.append,
          verbose: pending['_gateway_reasoning_verbose'] == true,
        ).applyTo(currentReasoning);
        candidate['_gateway_reasoning_verbose'] =
            pending['_gateway_reasoning_verbose'] == true;
      }
      _timeline = _timeline.reassignScope(
        pending,
        candidate,
        replaceReasoning: pending['_gateway_reasoning_replaces'] == true,
      );
      _messages.removeAt(pendingIndex);
      _retainReceiptPresentation();
      candidate.remove('_gateway_interim');
      return candidate;
    }
    return pending;
  }

  Map<String, dynamic>? _lastAssistantMessage() {
    for (var index = _messages.length - 1; index >= 0; index--) {
      if (_messages[index]['role'] == 'assistant') return _messages[index];
    }
    return null;
  }

  void _handleDesktopAsyncEvent(String mobileSessionId, StreamEvent event) {
    if (!mounted || mobileSessionId != widget.session.id) return;
    const interactiveTypes = {
      'approval.request',
      'setup_beat.request',
      'connection.request',
      'connection.update',
      'clarify.request',
      'clarify.remaining',
      'sudo.request',
      'secret.request',
      'request.cancel',
    };
    if (interactiveTypes.contains(event.type)) {
      _handleDesktopGatewayEvent(event, _responseGeneration);
      return;
    }
    if (event.type == 'error' || event.type == 'turn.error') {
      // The client hands every terminal frame to this async path BEFORE the
      // live turn's own stream, which reports and settles it. A frame with
      // no live turn (a detached turn settling later) goes to the card now;
      // a live turn's frame carries its failure surface, so the card shows
      // it once that turn settles as failed (_applyGatewayTurnState).
      if (_hasLiveTurn) {
        _liveFailureFrame = event.data;
      } else {
        _noteRecovery(event.data);
      }
      return;
    }
    if (const {'message.complete', 'turn.end'}.contains(event.type)) {
      return;
    }
    if (event.type == 'notification.show') {
      final notification = GatewayNotification.fromEventData(event.data);
      if (notification == null) return;
      _notifyGatewayNotice(notification);
      _notificationTimers.remove(notification.key)?.cancel();
      setState(() => _gatewayNotifications[notification.key] = notification);
      _scheduleStreamingFollow();
      if (notification.ttl case final ttl?) {
        _notificationTimers[notification.key] = Timer(ttl, () {
          if (!mounted) return;
          setState(() => _gatewayNotifications.remove(notification.key));
          _notificationTimers.remove(notification.key);
        });
      }
      return;
    }
    if (event.type == 'notification.clear') {
      final key = event.data['key']?.toString().trim();
      setState(() {
        if (key == null || key.isEmpty) {
          _gatewayNotifications.clear();
          for (final timer in _notificationTimers.values) {
            timer.cancel();
          }
          _notificationTimers.clear();
        } else {
          _gatewayNotifications.remove(key);
          _notificationTimers.remove(key)?.cancel();
        }
      });
      _scheduleStreamingFollow();
      return;
    }
    if (event.type.startsWith('subagent.')) {
      _upsertSubagent(event.type, event.data);
      return;
    }
    if (_showSideAnswer(event)) return;
    final notice = GatewayNotice.fromGatewayEvent(event.type, event.data);
    if (notice == null) return;
    if (_gatewayNotices.any((item) => item.identity == notice.identity)) return;
    _notifyBackgroundNotice(notice);
    setState(() {
      _gatewayNotices.add(notice);
      if (_gatewayNotices.length > 20) _gatewayNotices.removeAt(0);
      _savedGatewayNotices[_gatewayNoticeIdentity] = List.unmodifiable(
        _gatewayNotices,
      );
    });
    _scheduleStreamingFollow();
  }

  GatewaySubagentActivity _mergeSubagentActivity(
    GatewaySubagentActivity update,
  ) {
    final index = _subagentActivities.indexWhere(
      (activity) => activity.matchesTask(update),
    );
    final merged = index < 0
        ? update
        : _subagentActivities[index].merge(update);
    if (index < 0) {
      _subagentActivities.add(merged);
    } else {
      _subagentActivities[index] = merged;
    }
    _openTaskController?.updateTask(merged);
    return merged;
  }

  void _upsertSubagent(String eventType, Map<String, dynamic> data) {
    final update = GatewaySubagentActivity.fromGatewayEvent(eventType, data);
    if (update == null || !mounted) return;
    setState(() {
      final merged = _mergeSubagentActivity(update);
      if ((_sending || _streaming) &&
          (!merged.isComplete || _gatewayTurnStatus?.kind == 'subagent')) {
        final active = _subagentActivities
            .where((task) => !task.isComplete)
            .lastOrNull;
        _gatewayTurnStatus = active == null
            ? null
            : GatewayTurnStatus(
                kind: 'subagent',
                text: delegatedTaskGoal(context.l10n, active),
              );
      }
    });
    if (_openTaskController == null) _scheduleStreamingFollow();
  }

  Future<void> _openDelegatedTask(GatewaySubagentActivity task) async {
    if (_openTaskController != null) return;
    final controller = DelegatedTaskController(
      task: task,
      history:
          widget.testTaskHistorySource?.call() ??
          DashboardTaskHistory.fromConnection(widget.connection),
    );
    _openTaskController = controller;
    _openingScrollInterrupted = true;
    // Fence queued callbacks too, without changing the parent's sticky follow
    // intent or deferring a jump until dismissal. Content keeps arriving.
    _automaticScrollGeneration++;
    _initialEndFramesRemaining = 0;
    try {
      // Freeze parent follow synchronously, then let its pending layout and
      // semantics flush before inserting the modal's separate semantics tree.
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || !identical(_openTaskController, controller)) return;
      await showDelegatedTaskTimeline(context, controller);
    } finally {
      controller.dispose();
      if (identical(_openTaskController, controller)) {
        _openTaskController = null;
      }
    }
  }

  Future<void> _respondToGatewayApproval(
    String choice, {
    String? requestId,
    String? runId,
    Object? executionGeneration,
    bool canonicalControl = false,
    bool Function()? isCurrent,
  }) async {
    final l10n = context.sharedL10n;
    final normal = _normalSession;
    final recovery = _turnApplicationSession;
    final gateway = _desktopGateway;
    final sessionId = widget.session.id;
    final localSessionId = _normalLocalSessionKey;
    void check() {
      if (isCurrent != null && !isCurrent()) {
        throw UiMessageException(l10n.release_chat_approval_authority_revoked);
      }
    }

    check();
    if (requestId != null &&
        await normal?.tryRespondToApproval(
              sessionId: sessionId,
              requestId: requestId,
              choice: choice,
            ) ==
            true) {
      return;
    }
    check();
    final handled =
        await recovery?.tryRespondToApproval(
          sessionId: sessionId,
          choice: choice,
          requestId: requestId,
        ) ??
        false;
    if (handled) return;
    check();
    if (gateway != null) {
      await gateway.respondToApproval(
        sessionId: localSessionId,
        choice: choice,
        serverRequestId: requestId,
      );
      return;
    }
    if (runId != null) {
      await _client.respondToRunApproval(
        runId: runId,
        choice: choice,
        requestId: requestId,
        executionGeneration: executionGeneration,
        canonicalControl: canonicalControl,
        isCurrent: isCurrent,
      );
      return;
    }
    throw UiMessageException(l10n.release_chat_gateway_session_disconnected);
  }

  /// Answers approvals that notification actions left pending for this
  /// connection. Entries are removed only after the gateway confirms the
  /// answer: a cold start (no route-local session yet) or a throw keeps the
  /// tap pending for a later retry instead of losing it.
  void _consumePendingNotificationApproval() {
    prunePendingNotificationApprovals();
    final mine = [
      for (final approval in pendingNotificationApprovals.value)
        if (approval.connectionId == widget.connection.id &&
            approval.sessionId == widget.session.id &&
            approval.authority?.isCurrentFor(widget.connection) == true)
          approval,
    ];
    for (final approval in mine) {
      unawaited(_answerPendingNotificationApproval(approval));
    }
  }

  /// Approvals whose answer is in flight, so a notifier change cannot
  /// dispatch the same request twice.
  Future<void> _answerPendingNotificationApproval(
    PendingNotificationApproval approval,
  ) async {
    if (!claimNotificationApproval(approval)) return;
    final account = _historyAccountKey;
    final sessionId = widget.session.id;
    bool current() =>
        mounted &&
        account == _historyAccountKey &&
        sessionId == widget.session.id &&
        approval.authority?.isCurrentFor(widget.connection) == true &&
        pendingNotificationApprovals.value.any(
          (item) => identical(item, approval),
        );
    try {
      if (!await approval.authority!.validate() || !current()) return;
      // The normal approval path: route-local turn session first, then the
      // desktop gateway. A throw means the route-local gateway is not up
      // yet (cold start/reconnect) — keep the entry and retry later.
      await _respondToGatewayApproval(
        approval.choice,
        requestId: approval.requestId,
        isCurrent: current,
      );
      removePendingNotificationApproval(approval);
    } catch (_) {
      // Unresolved, not answered: keep the entry for a later retry.
    } finally {
      releaseNotificationApproval(approval);
    }
  }

  /// Sends the answer the user submitted from a clarify card.
  ///
  /// Records the prompt as self-answered for the duration of the send so the
  /// remaining-questions reconcile does not close the card's route a second
  /// time (see [_selfAnsweredClarifyIdentities]).
  Future<void> _answerClarifyPrompt(
    GatewayClarifyRequest request,
    String answer,
  ) async {
    _selfAnsweredClarifyIdentities.add(request.identityKey);
    try {
      await _respondToGatewayClarify(
        requestId: request.requestId,
        questionId: request.questionId,
        answer: answer,
      );
    } catch (_) {
      // A failed send keeps the card open for a retry, so the reconcile may
      // own the route again.
      _selfAnsweredClarifyIdentities.remove(request.identityKey);
      rethrow;
    }
  }

  /// Whether the open clarify card still belongs to [request].
  ///
  /// A `request.cancel` arriving while `clarify.lock` is pending closes the
  /// card itself, and the drain can open the next question's card before the
  /// late answer (the gateway reports `status: expired`) resolves. A card may
  /// only close the route it still owns: popping otherwise takes whatever is
  /// on top — the chat screen, or the next question's card — with it.
  bool _ownsClarifyPromptRoute(GatewayClarifyRequest request) {
    return _clarifyPromptRouteOpen &&
        !_clarifyPromptClosing &&
        _activeClarifyPrompt?.request.identityKey == request.identityKey;
  }

  void _closeClarifyPromptRoute() {
    if (_clarifyPromptClosing) return;
    final route = _clarifyPromptRoute;
    if (route == null) {
      // showDialog pushed the route but its builder has not run yet.
      // Wait for its identity rather than popping an unrelated top route.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _clarifyPromptRouteOpen && _clarifyPromptRoute != null) {
          _closeClarifyPromptRoute();
        }
      });
      return;
    }
    _clarifyPromptClosing = true;
    final navigator = route.navigator;
    if (navigator == null) return;
    if (route.isCurrent) {
      navigator.pop(false);
    } else {
      // A newer approval may be above clarify. Expiring clarify must not
      // dismiss that independent request or send an unintended denial.
      navigator.removeRoute(route, false);
    }
  }

  /// Answers this chat's catalog card with `connection.respond` through the
  /// owner that holds this chat's runtime session. Nothing is sent for an
  /// operation that is not this chat's open one.
  Future<bool> _respondCatalog(
    CatalogOperation operation,
    Map<String, dynamic> answer,
  ) async {
    final current = _catalog;
    if (!mounted ||
        current == null ||
        current.opId != operation.opId ||
        current.settled) {
      return false;
    }
    final sessionId = widget.session.id;
    if (await (_normalSession?.tryRespondToConnection(
          sessionId: sessionId,
          opId: operation.opId,
          result: answer,
        ) ??
        Future.value(false))) {
      return true;
    }
    final turnSession = _turnApplicationSession;
    if (turnSession is GatewaySetupBeatResponder &&
        await (turnSession as GatewaySetupBeatResponder).tryRespondToConnection(
          sessionId: sessionId,
          opId: operation.opId,
          result: answer,
        )) {
      return true;
    }
    return await _desktopGateway?.respondToConnection(
          sessionId: sessionId,
          opId: operation.opId,
          result: answer,
        ) ??
        false;
  }

  /// Installs a failed catalog plugin again after its operation settled,
  /// through this connection's capabilities install into the row's own
  /// target profile.
  Future<CatalogRetryResult> _retryCatalogRow(CatalogRow row) async {
    final gateway = _desktopGateway ?? _normalSession?.client;
    if (gateway == null) {
      return CatalogRetryResult(
        ok: false,
        message: context.l10n.catalog_send_failed,
      );
    }
    final admin = CapabilityAdmin(
      profile: widget.connection.gatewayProfile,
      rest: (method, path, {query, body, timeout}) =>
          throw const CapabilityException('Not used for a catalog install.'),
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

  /// Answers this chat's waiting setup card through whichever owner holds
  /// the request (the stock gateway's chat owner, the recovery session or
  /// the Desktop gateway client). Nothing is sent for a card that is no
  /// longer open here, or for another chat. The card closes only once the
  /// answer went out: one that did not, while an owner still holds the
  /// request, keeps the card to be answered again, as on the Desktop.
  /// [quiet] skips the "no longer waiting" note (a message sent instead).
  Future<SetupBeatSend> _answerSetupBeat(
    SetupBeatRequest request,
    Map<String, dynamic> result, {
    bool quiet = false,
  }) async {
    if (!mounted || _setupBeat?.requestId != request.requestId) {
      return SetupBeatSend.closed;
    }
    final sessionId = widget.session.id;
    final requestId = request.requestId;
    var sent =
        _normalSession?.tryRespondToSetupBeat(
          sessionId: sessionId,
          requestId: requestId,
          result: result,
        ) ??
        false;
    final turnSession = _turnApplicationSession;
    if (!sent && turnSession is GatewaySetupBeatResponder) {
      sent = (turnSession as GatewaySetupBeatResponder).tryRespondToSetupBeat(
        sessionId: sessionId,
        requestId: requestId,
        result: result,
      );
    }
    if (!sent) {
      sent =
          _desktopGateway?.respondToSetupBeat(
            sessionId: sessionId,
            requestId: requestId,
            result: result,
          ) ??
          false;
    }
    if (!mounted || _setupBeat?.requestId != request.requestId) {
      return sent ? SetupBeatSend.sent : SetupBeatSend.closed;
    }
    if (!sent) {
      final held =
          (_normalSession?.holdsSetupBeat(
                sessionId: sessionId,
                requestId: requestId,
              ) ??
              false) ||
          (turnSession is GatewaySetupBeatResponder &&
              (turnSession as GatewaySetupBeatResponder).holdsSetupBeat(
                sessionId: sessionId,
                requestId: requestId,
              )) ||
          (_desktopGateway?.holdsSetupBeat(
                sessionId: sessionId,
                requestId: requestId,
              ) ??
              false);
      if (held) return SetupBeatSend.failed;
    }
    setState(() => _setupBeat = null);
    if (!sent && !quiet) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(context.l10n.setup_beat_not_waiting)),
      );
    }
    return sent ? SetupBeatSend.sent : SetupBeatSend.closed;
  }

  /// A message sent while a setup card waits closes the card unanswered
  /// with `{wrote_instead: true}` before the message goes out: the backend
  /// ends the card's turn and the message runs as the next one (Desktop's
  /// yieldSetupBeatToMessage). True when the card closed.
  Future<bool> _yieldSetupBeatToMessage() async {
    final card = _setupBeat;
    if (card == null) return false;
    return await _answerSetupBeat(card, const {
          'wrote_instead': true,
        }, quiet: true) ==
        SetupBeatSend.sent;
  }

  Future<void> _respondToGatewayClarify({
    required String requestId,
    required String answer,
    String? questionId,
  }) async {
    final l10n = context.sharedL10n;
    final handled =
        await _turnApplicationSession?.tryRespondToClarify(
          requestId: requestId,
          answer: answer,
          questionId: questionId,
        ) ??
        false;
    if (handled) return;
    final gateway = _desktopGateway;
    if (gateway == null) {
      throw UiMessageException(l10n.release_chat_gateway_session_disconnected);
    }
    await gateway.respondToClarify(
      requestId: requestId,
      answer: answer,
      questionId: questionId,
    );
  }

  Future<void> _respondToGatewaySudo({
    required String requestId,
    required String password,
  }) async {
    final l10n = context.sharedL10n;
    final handled =
        await _turnApplicationSession?.tryRespondToSudo(
          requestId: requestId,
          password: password,
        ) ??
        false;
    if (handled) return;
    final gateway = _desktopGateway;
    if (gateway == null) {
      throw UiMessageException(l10n.release_chat_gateway_session_disconnected);
    }
    await gateway.respondToSudo(requestId: requestId, password: password);
    _normalSession?.forgetAnsweredInput(requestId);
  }

  Future<void> _respondToGatewaySecret({
    required String requestId,
    required String value,
  }) async {
    final l10n = context.sharedL10n;
    final handled =
        await _turnApplicationSession?.tryRespondToSecret(
          requestId: requestId,
          value: value,
        ) ??
        false;
    if (handled) return;
    final gateway = _desktopGateway;
    if (gateway == null) {
      throw UiMessageException(l10n.release_chat_gateway_session_disconnected);
    }
    await gateway.respondToSecret(requestId: requestId, value: value);
    _normalSession?.forgetAnsweredInput(requestId);
  }

  bool _ownsGatewayApproval(String requestId) {
    if (_normalSession?.ownsApprovalRequest(
          sessionId: widget.session.id,
          requestId: requestId,
        ) ==
        true) {
      return true;
    }
    final turnSession = _turnApplicationSession;
    if (turnSession != null &&
        turnSession.ownsApprovalRequest(
          sessionId: widget.session.id,
          requestId: requestId,
        )) {
      return true;
    }
    return _desktopGateway?.ownsApprovalRequest(
          widget.session.id,
          requestId: requestId,
        ) ??
        false;
  }

  void _showGatewayApproval(
    Map<String, dynamic> eventData,
    int responseGeneration,
  ) {
    if (_approvalDialogOpen) return;
    final request = GatewayApprovalRequest.fromEventData(eventData);
    final rawServerRequestId = eventData['server_request_id']
        ?.toString()
        .trim();
    final serverRequestId = rawServerRequestId?.isEmpty == true
        ? null
        : rawServerRequestId;
    _approvalDialogOpen = true;
    _activeApprovalServerRequestId = serverRequestId;
    _notifyApprovalRequest(serverRequestId);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_usesNormalInputOwner &&
          mounted &&
          ModalRoute.of(context)?.isCurrent != true) {
        _normalInputSeen.clear();
        _approvalDialogOpen = false;
        _activeApprovalServerRequestId = null;
        return;
      }
      final wasCancelledBeforeOpen =
          serverRequestId != null &&
          _cancelledInteractiveRequestIds.remove(serverRequestId);
      if (!mounted ||
          responseGeneration != _responseGeneration ||
          wasCancelledBeforeOpen) {
        _approvalDialogOpen = false;
        _activeApprovalServerRequestId = null;
        return;
      }
      if (serverRequestId != null && !_ownsGatewayApproval(serverRequestId)) {
        _approvalDialogOpen = false;
        _activeApprovalServerRequestId = null;
        return;
      }
      final approvalRunId = request.runId;
      if (_desktopGateway == null &&
          _turnApplicationSession == null &&
          approvalRunId == null) {
        _approvalDialogOpen = false;
        _activeApprovalServerRequestId = null;
        return;
      }

      _approvalRouteOpen = true;
      final approvalRoute = DialogRoute<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => GatewayApprovalDialog(
          request: request,
          onRespond: (choice) => _respondToGatewayApproval(
            choice.wireValue,
            requestId: approvalRunId == null
                ? serverRequestId
                : request.requestId,
            runId: approvalRunId,
            executionGeneration: request.executionGeneration,
            canonicalControl: request.canonicalControl,
            isCurrent: () =>
                mounted && responseGeneration == _responseGeneration,
          ),
        ),
      );
      _approvalPromptRoute = approvalRoute;
      final responded = await Navigator.of(context).push(approvalRoute);
      _approvalPromptRoute = null;
      _approvalRouteOpen = false;
      _approvalDialogOpen = false;
      final wasCancelled =
          serverRequestId != null &&
          _cancelledInteractiveRequestIds.remove(serverRequestId);
      _activeApprovalServerRequestId = null;
      _drainClarifyPromptQueue();
      _drainSensitivePromptQueue();

      // System Back is treated as a denial. This prevents a dismissed mobile
      // dialog from leaving the gateway turn blocked indefinitely. A gateway
      // cancellation closes the same route but must not emit a late denial.
      if (responded != true &&
          !wasCancelled &&
          mounted &&
          responseGeneration == _responseGeneration) {
        try {
          await _respondToGatewayApproval(
            GatewayApprovalChoice.deny.wireValue,
            requestId: approvalRunId == null
                ? serverRequestId
                : request.requestId,
            runId: approvalRunId,
            executionGeneration: request.executionGeneration,
            canonicalControl: request.canonicalControl,
            isCurrent: () =>
                mounted && responseGeneration == _responseGeneration,
          );
        } catch (error) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            hermesStatusSnackBar(
              context,
              message: context.l10n.could_not_deny_the_command(error),
              status: HermesStatus.failed,
            ),
          );
        }
      }
    });
  }

  void _queueSensitivePrompt(StreamEvent event, int responseGeneration) {
    final kind = event.type == 'sudo.request'
        ? GatewaySensitivePromptKind.sudo
        : GatewaySensitivePromptKind.secret;
    final request = GatewaySensitivePromptRequest.fromEventData(
      kind: kind,
      data: event.data,
      l10n: context.l10n,
    );
    if (request == null) return;
    final duplicate =
        _expiredSensitivePromptIds.contains(request.requestId) ||
        _activeSensitivePrompt?.request.requestId == request.requestId ||
        _sensitivePromptQueue.any(
          (pending) => pending.request.requestId == request.requestId,
        );
    if (duplicate) return;
    _sensitivePromptQueue.add(
      _PendingSensitivePrompt(request, responseGeneration),
    );
    _drainSensitivePromptQueue();
  }

  void _drainSensitivePromptQueue() {
    if (!mounted ||
        _approvalDialogOpen ||
        _activeClarifyPrompt != null ||
        _activeSensitivePrompt != null ||
        _sensitivePromptQueue.isEmpty) {
      return;
    }
    final pending = _sensitivePromptQueue.removeAt(0);
    _activeSensitivePrompt = pending;
    _notifyInputRequest(eventId: pending.request.requestId);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_usesNormalInputOwner &&
          mounted &&
          ModalRoute.of(context)?.isCurrent != true) {
        _normalInputSeen.clear();
        _activeSensitivePrompt = null;
        return;
      }
      if (!mounted ||
          pending.responseGeneration != _responseGeneration ||
          _expiredSensitivePromptIds.contains(pending.request.requestId) ||
          _activeSensitivePrompt?.request.requestId !=
              pending.request.requestId) {
        _expiredSensitivePromptIds.remove(pending.request.requestId);
        _activeSensitivePrompt = null;
        _drainSensitivePromptQueue();
        return;
      }
      final desktopGateway = _desktopGateway;
      if (desktopGateway == null) {
        _activeSensitivePrompt = null;
        _drainSensitivePromptQueue();
        return;
      }

      _sensitivePromptRouteOpen = true;
      final sensitiveRoute = DialogRoute<GatewaySensitivePromptDialogResult>(
        context: context,
        barrierDismissible: true,
        builder: (_) => GatewaySensitivePromptDialog(
          request: pending.request,
          onRespond: (value) => switch (pending.request.kind) {
            GatewaySensitivePromptKind.sudo => _respondToGatewaySudo(
              requestId: pending.request.requestId,
              password: value,
            ),
            GatewaySensitivePromptKind.secret => _respondToGatewaySecret(
              requestId: pending.request.requestId,
              value: value,
            ),
          },
        ),
      );
      _sensitivePromptRoute = sensitiveRoute;
      final result = await Navigator.of(context).push(sensitiveRoute);
      _sensitivePromptRoute = null;
      _sensitivePromptRouteOpen = false;
      _expiredSensitivePromptIds.remove(pending.request.requestId);

      if (_activeSensitivePrompt?.request.requestId ==
          pending.request.requestId) {
        _activeSensitivePrompt = null;
      }
      if (result == null &&
          mounted &&
          pending.responseGeneration == _responseGeneration) {
        try {
          switch (pending.request.kind) {
            case GatewaySensitivePromptKind.sudo:
              await _respondToGatewaySudo(
                requestId: pending.request.requestId,
                password: '',
              );
              break;
            case GatewaySensitivePromptKind.secret:
              await _respondToGatewaySecret(
                requestId: pending.request.requestId,
                value: '',
              );
              break;
          }
        } catch (_) {
          // The request may have expired while the route was closing. Never
          // include a sensitive value in an error message or diagnostic.
        }
      }
      _drainClarifyPromptQueue();
      _drainSensitivePromptQueue();
    });
  }

  void _expireSensitivePrompt(StreamEvent event) {
    final requestId = event.data['request_id']?.toString().trim() ?? '';
    if (requestId.isEmpty) return;
    _expiredSensitivePromptIds.add(requestId);
    _sensitivePromptQueue.removeWhere(
      (pending) => pending.request.requestId == requestId,
    );
    if (_activeSensitivePrompt?.request.requestId == requestId &&
        _sensitivePromptRouteOpen) {
      final route = _sensitivePromptRoute;
      if (route != null && route.isActive) {
        route.navigator?.removeRoute(
          route,
          GatewaySensitivePromptDialogResult.expired,
        );
      }
    } else if (_activeSensitivePrompt?.request.requestId != requestId) {
      _expiredSensitivePromptIds.remove(requestId);
    }
  }

  void _cancelGatewayServerRequest(StreamEvent event) {
    final requestId = event.data['id']?.toString().trim() ?? '';
    final method = event.data['method']?.toString().trim() ?? '';
    if (requestId.isEmpty) return;

    if (_setupBeat?.requestId == requestId) {
      // Withdrawn (timeout, Stop, Skip setup, answered in another window)
      // or its socket went: the card can no longer be answered.
      setState(() => _setupBeat = null);
      return;
    }

    if (method == 'sudo' || method == 'secret') {
      _expireSensitivePrompt(
        StreamEvent(type: '$method.expire', data: {'request_id': requestId}),
      );
      return;
    }

    _cancelledInteractiveRequestIds.add(requestId);
    if (method == 'clarify') {
      _clarifyPromptQueue.removeWhere(
        (pending) => pending.request.requestId == requestId,
      );
      if (_activeClarifyPrompt?.request.requestId == requestId &&
          _clarifyPromptRouteOpen) {
        _closeClarifyPromptRoute();
      } else if (_activeClarifyPrompt?.request.requestId != requestId) {
        _cancelledInteractiveRequestIds.remove(requestId);
      }
      return;
    }

    if (method == 'approval') {
      if (_activeApprovalServerRequestId == requestId && _approvalRouteOpen) {
        final route = _approvalPromptRoute;
        if (route != null && route.isActive) {
          route.navigator?.removeRoute(route, false);
        }
      } else if (_activeApprovalServerRequestId != requestId) {
        _cancelledInteractiveRequestIds.remove(requestId);
      }
    }
  }

  void _reconcileClarifyPrompts(StreamEvent event) {
    final requestId = event.data['id']?.toString().trim() ?? '';
    final rawRemaining = event.data['remaining'];
    if (requestId.isEmpty || rawRemaining is! List) return;
    final remaining = rawRemaining.map((value) => value.toString()).toSet();
    _clarifyPromptQueue.removeWhere(
      (pending) =>
          pending.request.requestId == requestId &&
          !remaining.contains(pending.request.questionId),
    );
    final active = _activeClarifyPrompt;
    if (active?.request.requestId != requestId ||
        remaining.contains(active?.request.questionId)) {
      return;
    }
    // An answer the user sent from this card closes its own route once the
    // lock lands. The reconcile is for questions resolved elsewhere, so leave
    // the route alone here instead of popping it twice.
    if (_selfAnsweredClarifyIdentities.remove(active!.request.identityKey)) {
      return;
    }
    _cancelledInteractiveRequestIds.add(requestId);
    if (_clarifyPromptRouteOpen) {
      _closeClarifyPromptRoute();
    } else {
      _activeClarifyPrompt = null;
      _cancelledInteractiveRequestIds.remove(requestId);
      _drainClarifyPromptQueue();
    }
  }

  void _queueClarifyPrompt(
    Map<String, dynamic> eventData,
    int responseGeneration,
  ) {
    final requests = GatewayClarifyRequest.fromEventDataList(eventData);
    if (requests.isEmpty) return;
    for (final request in requests) {
      final duplicate =
          _activeClarifyPrompt?.request.identityKey == request.identityKey ||
          _clarifyPromptQueue.any(
            (pending) => pending.request.identityKey == request.identityKey,
          );
      if (duplicate) continue;
      _clarifyPromptQueue.add(
        _PendingClarifyPrompt(request, responseGeneration),
      );
    }
    _drainClarifyPromptQueue();
  }

  void _drainClarifyPromptQueue() {
    if (!mounted ||
        _approvalDialogOpen ||
        _activeSensitivePrompt != null ||
        _activeClarifyPrompt != null ||
        _clarifyPromptQueue.isEmpty) {
      return;
    }
    final pending = _clarifyPromptQueue.removeAt(0);
    _activeClarifyPrompt = pending;
    _notifyInputRequest(eventId: pending.request.identityKey);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_usesNormalInputOwner &&
          mounted &&
          ModalRoute.of(context)?.isCurrent != true) {
        _normalInputSeen.clear();
        _activeClarifyPrompt = null;
        return;
      }
      if (!mounted ||
          pending.responseGeneration != _responseGeneration ||
          _cancelledInteractiveRequestIds.remove(pending.request.requestId) ||
          _activeClarifyPrompt?.request.identityKey !=
              pending.request.identityKey) {
        _activeClarifyPrompt = null;
        _drainSensitivePromptQueue();
        _drainClarifyPromptQueue();
        return;
      }
      final desktopGateway = _desktopGateway;
      if (desktopGateway == null) {
        _activeClarifyPrompt = null;
        _drainSensitivePromptQueue();
        _drainClarifyPromptQueue();
        return;
      }

      _clarifyPromptRouteOpen = true;
      final responded = await showDialog<bool>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: true,
        builder: (dialogContext) {
          _clarifyPromptRoute = ModalRoute.of<bool>(dialogContext);
          return GatewayClarifyDialog(
            request: pending.request,
            onRespond: (answer) =>
                _answerClarifyPrompt(pending.request, answer),
            canCloseRoute: () => _ownsClarifyPromptRoute(pending.request),
          );
        },
      );
      _clarifyPromptRouteOpen = false;
      _clarifyPromptRoute = null;
      _clarifyPromptClosing = false;
      _selfAnsweredClarifyIdentities.remove(pending.request.identityKey);
      final wasCancelled = _cancelledInteractiveRequestIds.remove(
        pending.request.requestId,
      );
      if (_activeClarifyPrompt?.request.identityKey ==
          pending.request.identityKey) {
        _activeClarifyPrompt = null;
      }

      // System Back or a barrier dismiss maps to the official empty answer,
      // matching Hermes Desktop's Skip behavior. Batch questions skip
      // per-question so the remaining questions can still be answered. A
      // gateway cancellation closes the same route without answering it.
      if (responded != true &&
          !wasCancelled &&
          mounted &&
          pending.responseGeneration == _responseGeneration) {
        try {
          await _respondToGatewayClarify(
            requestId: pending.request.requestId,
            questionId: pending.request.questionId,
            answer: '',
          );
        } catch (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            hermesStatusSnackBar(
              context,
              message: context.l10n.could_not_skip_the_hermes_question,
              status: HermesStatus.failed,
            ),
          );
        }
      }
      _drainSensitivePromptQueue();
      _drainClarifyPromptQueue();
    });
  }

  Future<bool> _stopRecoverableGatewayResponse() async {
    final l10n = context.sharedL10n;
    final turnSession = _turnApplicationSession!;
    final responseGeneration = _responseGeneration;
    final pendingSubmission = _recoverableSubmissionState;
    setState(() {
      _stopResponseInFlight = true;
      _awaitingVoiceReply = false;
    });
    try {
      if (_activeClientTurnId == null) await pendingSubmission?.future;
      if (!mounted || responseGeneration != _responseGeneration) return false;
      final clientTurnId = _activeClientTurnId;
      // A first terminal callback or definite pre-ACK rejection needs no
      // interrupt. Unknown admission must never borrow the legacy route.
      if (clientTurnId == null) return false;
      final state = await turnSession.interrupt(
        localSessionId: widget.session.id,
        clientTurnId: clientTurnId,
      );
      if (!mounted || responseGeneration != _responseGeneration) return false;
      // A real terminal may have arrived while interrupt was pending. Its
      // cleared identity wins over an older, nonterminal interrupt read-back.
      if (_activeClientTurnId == clientTurnId) _applyGatewayTurnState(state);
      final stopped = state.isTerminal && !state.isFailClosed && !_streaming;
      if (!stopped && _activeClientTurnId == clientTurnId) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.release_chat_stop_requested)),
        );
      }
      // Stop is an intent, not lifecycle settlement. A nonterminal reconcile
      // must keep the submit observer, scaffold and admission ownership alive;
      // in particular Stop and send cannot launch another prompt yet.
      return stopped;
    } catch (error) {
      if (mounted && responseGeneration == _responseGeneration) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.release_chat_stop_request_failed(error.toString()),
            ),
          ),
        );
      }
      return false;
    } finally {
      _finishStopInFlight();
      unawaited(_refreshDeferredHistoryIfIdle());
    }
  }

  bool get _heldIdle =>
      mounted &&
      !_usesNormalInputOwner &&
      !_held.parked &&
      _held.entries.isNotEmpty &&
      !_streaming &&
      !_sending &&
      !_preparingSend &&
      !_midTurnSendInFlight &&
      !_stopResponseInFlight &&
      !_pendingReattachResync;

  Future<void> _persistHeldQueue() {
    if (_usesNormalInputOwner) return Future<void>.value();
    if (!_heldTouched && _held.entries.isEmpty) return Future<void>.value();
    final handle = _draftWriter.draftHandle;
    return ComposerDraftStore.saveHeldPrompts(
      connectionId: handle.connectionId,
      sessionId: handle.sessionId,
      texts: [for (final entry in _held.entries) entry.text],
    );
  }

  Future<void> _restoreHeldQueue() async {
    if (_usesNormalInputOwner) return;
    final handle = _draftWriter.draftHandle;
    final texts = await ComposerDraftStore.readHeldPrompts(
      connectionId: handle.connectionId,
      sessionId: handle.sessionId,
    );
    if (!mounted || _heldTouched || texts.isEmpty || _held.entries.isNotEmpty) {
      return;
    }
    setState(() => _held.restoreParked(texts));
  }

  void _keepRefusedHeldPrompt(String id) {
    _held.promote(id);
    _held.park();
    if (!mounted) return;
    setState(() {
      _terminalTurnNotice ??= context.l10n.send_failed(
        context.sharedL10n.release_chat_queued_prompt_not_sent,
      );
    });
  }

  void _finishStopInFlight() {
    if (mounted) {
      setState(() => _stopResponseInFlight = false);
    } else {
      _stopResponseInFlight = false;
    }
    unawaited(_drainHeldIfIdle());
  }

  Future<void> _drainHeldIfIdle() async {
    if (_heldDrainBusy || !_heldIdle) return;
    final next = _held.peekAuto(skipId: _editingHeldId);
    if (next == null) return;
    _heldDrainBusy = true;
    if (mounted) setState(() {});
    var accepted = false;
    try {
      await _submitMessage(
        text: next.text,
        attachments: const [],
        speakResponse: false,
        heldUntilAccepted: true,
        onAccepted: () {
          if (accepted) return;
          accepted = true;
          _heldTouched = true;
          _held.remove(next.id);
          unawaited(_persistHeldQueue());
          if (mounted) setState(() {});
        },
      );
    } catch (_) {
      accepted = false;
    } finally {
      _heldDrainBusy = false;
    }
    if (!mounted) return;
    if (!accepted && _held.entries.any((entry) => entry.id == next.id)) {
      _keepRefusedHeldPrompt(next.id);
    }
  }

  void _queueHeldFromComposer() {
    if (_usesNormalInputOwner || !_streaming) return;
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _heldTouched = true;
    setState(() {
      _held.enqueue(text);
      _textController.clear();
    });
    _draftWriter.edit('');
    unawaited(_draftWriter.save(''));
    unawaited(_persistHeldQueue());
  }

  Future<void> _sendHeldNow(String id) async {
    if (!_held.promote(id)) return;
    if (_streaming) {
      _parkHeldOnStop = false;
      await _stopResponse();
    } else {
      _held.unpark();
      if (mounted) setState(() {});
    }
    await _drainHeldIfIdle();
  }

  Future<void> _editHeld(String id) async {
    final index = _held.entries.indexWhere((entry) => entry.id == id);
    if (index < 0) {
      _reportMissingHeldEdit();
      return;
    }
    var draft = _held.entries[index].text;
    _editingHeldId = id;
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
          onChanged: (value) => draft = value,
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
    try {
      if (!mounted || result == null) return;
      final saved = _held.edit(id, result);
      if (!saved) {
        _reportMissingHeldEdit();
        return;
      }
      _heldTouched = true;
      unawaited(_persistHeldQueue());
      if (mounted) setState(() {});
    } finally {
      if (_editingHeldId == id) _editingHeldId = null;
      if (mounted) unawaited(_drainHeldIfIdle());
    }
  }

  void _reportMissingHeldEdit() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.sharedL10n.release_chat_unsent_prompt_gone),
      ),
    );
  }

  Future<bool> _stopResponse() async {
    final l10n = context.sharedL10n;
    final parkHeld = _parkHeldOnStop;
    _parkHeldOnStop = true;
    // A row send unparks even when Stop is already in flight. Returning
    // first used to consume that request and leave the list parked.
    if (!_usesNormalInputOwner && !parkHeld) {
      _held.unpark();
      if (mounted) setState(() {});
    }
    if (!_streaming || _stopResponseInFlight) return false;
    if (!_usesNormalInputOwner && parkHeld) {
      _held.park();
      if (mounted) setState(() {});
    }
    if (_turnApplicationSession != null && !_legacyTransportFallback) {
      return _stopRecoverableGatewayResponse();
    }
    final voice = _voiceTurn;
    if (voice != null) _finishVoiceTurn(voice, HandsFreeTurnStatus.interrupted);
    final normal = _normalChat;
    if (normal?.snapshot.hasActiveTurn == true) {
      final turn = normal!.turnId;
      setState(() {
        _stopResponseInFlight = true;
        _hiddenActivityTurnId = turn;
        _awaitingVoiceReply = false;
      });
      try {
        final requested = await normal.interrupt();
        if (!mounted || turn != normal.turnId) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              requested
                  ? l10n.release_chat_stop_requested
                  : l10n.release_chat_running_turn_unreachable,
            ),
          ),
        );
        return requested;
      } catch (error) {
        if (mounted && turn == normal.turnId) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.release_chat_stop_request_failed(error.toString()),
              ),
            ),
          );
        }
      } finally {
        _finishStopInFlight();
      }
      return false;
    }

    final transport = _activeResponseTransport;
    // Capture the cancelled admission before its empty scaffold is removed.
    // Looking up the last assistant after cancellation can select an older
    // successful reply and incorrectly revoke its quiet-mode completion.
    final stoppedAssistant = _lastAssistantMessage();
    _stopResponseInFlight = true;
    ++_responseGeneration;
    _scrollCoordinator.cancelStreaming();
    setState(() {
      _streaming = false;
      _sending = false;
      _gatewayTurnStatus = null;
      _awaitingVoiceReply = false;
      _activeResponseTransport = _ResponseTransport.none;
      _activeClientTurnId = null;
      if (_messages.isNotEmpty &&
          _messages.last['role'] == 'assistant' &&
          (_messages.last['content']?.toString().isEmpty ?? true)) {
        _messages.removeLast();
      }
    });

    try {
      bool interrupted;
      switch (transport) {
        case _ResponseTransport.rest:
          interrupted = await _gateway.cancelActiveMessage();
        case _ResponseTransport.desktop:
          interrupted =
              await _desktopGateway?.interruptPrompt(
                sessionId: _normalLocalSessionKey,
              ) ??
              false;
        case _ResponseTransport.none:
          interrupted = false;
      }
      if (!mounted) return false;
      if (interrupted) {
        setState(() {
          stoppedAssistant?['_gateway_pending_response'] = false;
          stoppedAssistant?['_chat_response_complete'] = false;
        });
      }
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            interrupted
                ? context.l10n.response_stopped
                : context
                      .l10n
                      .response_closed_locally_no_active_gateway_turn_was_found,
          ),
        ),
      );
      return interrupted;
    } catch (error) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        hermesStatusSnackBar(
          context,
          message: context.l10n.response_closed_locally_gateway_stop_failed(
            error,
          ),
          status: HermesStatus.failed,
          duration: const Duration(seconds: 6),
        ),
      );
      return false;
    } finally {
      _finishStopInFlight();
      unawaited(_refreshDeferredHistoryIfIdle());
    }
  }

  /// Clear the visible draft immediately but retain the unsent prompt through
  /// cancellable setup. Leaving during an upload must not silently lose it.
  void _clearComposerForSend(String text) {
    _clearedImageText = _attachmentDrafts.isEmpty ? '' : _textController.text;
    _setRestoredComposer('');
    _clearedComposerRevision = _composerRevision;
    final recovery = _composerTextWithPastes(text);
    _draftWriter.edit(recovery);
    unawaited(_draftWriter.save(recovery));
  }

  /// Preparation finished: hand off the prompt without touching newer typing.
  void _commitComposerForSend() {
    unawaited(_draftWriter.save(_composerTextWithPastes(_textController.text)));
  }

  /// Restore only the send's untouched draft. A newer edit (including typing
  /// and then deleting) belongs to the user, not this failed submission.
  void _restoreComposerAfterRejectedSend(String text) {
    if (text.isEmpty &&
        !_attachmentDrafts.any(
          (draft) => _pastedDraftTexts.containsKey(draft.id),
        )) {
      return;
    }
    if (!_draftWriter.isCurrent) return;
    if (_composerRevision == _clearedComposerRevision) {
      _setRestoredComposer(text);
    }
    unawaited(_draftWriter.save(_composerTextWithPastes(_textController.text)));
  }

  void _handleSendError(Object e, {bool removePendingUserMessage = false}) {
    _scrollCoordinator.cancelStreaming();
    setState(() {
      _sending = false;
      _streaming = false;
      _gatewayTurnStatus = null;
      _activeResponseTransport = _ResponseTransport.none;
      _awaitingVoiceReply = false;
      // The server's own refusal stays verbatim in both strings; the API-only
      // variant only appends what to check. Nothing here resends or reroutes.
      _terminalTurnNotice = switch (e) {
        // The transport's own refusals, in the user's language.
        JsonRpcError(reason: rewindTargetUnsavedReason) =>
          context.sharedL10n.rewind_target_unsaved,
        JsonRpcError(reason: rewindFencesUnknownReason) =>
          context.sharedL10n.rewind_session_changed,
        _ =>
          shouldExplainApiOnlyPermissionDenial(widget.connection, '$e')
              ? context.l10n.send_failed_api_only_permission_denied(e)
              : context.l10n.send_failed(e),
      };
      if (removePendingUserMessage &&
          _messages.isNotEmpty &&
          _messages.last['role'] == 'user') {
        _messages.removeLast();
      }
    });

    // The persistent non-spinning bottom notice owns this failure. A transient
    // snackbar would duplicate it and disappear on route reattachment.
  }

  void _upsertToolProgress(
    Map<String, dynamic> progress, {
    String eventType = 'tool.start',
  }) {
    final update = GatewayToolActivity.fromGatewayEvent(
      eventType,
      progress,
      observedAt: DateTime.now(),
    );
    if (update == null || _timeline.excludesTool(update)) return;
    setState(() {
      final idx = toolActivityUpdateIndex(_toolActivities, update, eventType);
      if (idx >= 0) {
        final previous = _toolActivities[idx];
        _toolActivities[idx] = previous.merge(update);
      } else {
        _toolActivities.add(update);
      }
      final activity = idx >= 0 ? _toolActivities[idx] : update;
      final toolId = activity.toolId;
      if (toolId != null) {
        _presentation.aliasTool(activity.identity, 'tool:$toolId');
      }
      final assistant = _lastAssistantMessage();
      if (assistant != null) {
        _timeline = _timeline.tool(assistant, activity);
        // A late completion of an evicted tool is not a new receipt/card.
        _toolActivities.removeWhere(
          (a) =>
              a.identity == update.identity &&
              !_timeline.runs.any((r) => r.activity?.identity == a.identity),
        );
        _retainReceiptPresentation();
      }
      if (!activity.isTerminal || _gatewayTurnStatus?.kind == 'tool') {
        _gatewayTurnStatus = GatewayTurnStatus.forRunningTool(
          _timeline
              .forScope(assistant ?? Object())
              .where((run) => run.activity != null)
              .map((run) => run.activity!),
        );
      }
    });

    _scheduleStreamingFollow();
  }

  /// Retention belongs to receipt ingestion, before any ListView projection.
  /// Do not change canonical/request accumulators to trim this view-only tail.
  void _retainReceiptPresentation() {
    _timeline = _timeline.retainScopes(
      _messages.map((row) => row['_normal_projection_id'] ?? row),
    );
    _toolActivities.removeWhere(_timeline.excludesTool);
  }

  bool get _transcriptLoadBlocksComposer =>
      _loading &&
      _desktopGateway == null &&
      _turnApplicationSession == null &&
      widget.testRemotePromptSubmit == null;

  ChatConnectionStatus get _chatConnectionStatus {
    if (_desktopGateway == null) {
      if (_loading) return ChatConnectionStatus.connecting;
      return _error == null
          ? ChatConnectionStatus.connected
          : ChatConnectionStatus.offline;
    }
    return switch (_desktopConnectionState) {
      DesktopConnectionState.connected => ChatConnectionStatus.connected,
      DesktopConnectionState.connecting => ChatConnectionStatus.connecting,
      DesktopConnectionState.reconnecting => ChatConnectionStatus.reconnecting,
      DesktopConnectionState.disconnected => ChatConnectionStatus.offline,
    };
  }

  @override
  Widget build(BuildContext context) {
    _syncComposerKeyboardEndScroll();
    final screen = _preview.layout(
      chat: _buildChat(context),
      storedId: _storedSessionId ?? _storedSessionKey,
      service: _attachmentDraftService,
      existing: _attachmentDrafts,
      update: setState,
      commit: (text, crops) {
        if (_sending || _preparingSend || _pendingReattachResync) {
          throw AttachmentDraftException(
            context.sharedL10n.release_chat_wait_for_composer,
          );
        }
        // A drop or paste may have staged drafts while the crops prepared.
        _attachmentDraftService.validateRemoteDrafts([
          ..._attachmentDrafts,
          ...crops,
        ]);
        setState(() {
          _attachmentDrafts.addAll(crops);
          appendPreviewText(_textController, text);
        });
      },
    );
    // Render state is scoped per connection and chat; presence reports only
    // this chat's own socket.
    return ChatPresence(
      target: () => (_desktopGateway ?? _normalSession?.client)?.presenceFor(
        _normalLocalSessionKey,
      ),
      cueKey: () => _completionCueKey,
      child: RenderScope(
        connection: renderConnectionKey(widget.connection),
        chat: _storedSessionId ?? _storedSessionKey,
        child: screen,
      ),
    );
  }

  Widget _buildChat(BuildContext context) => ReactionScope(
    chat: _reactionChat,
    // Switching the radio on or off adds or drops its narrow-pane menu entry.
    child: ListenableBuilder(
      listenable: presentationToolsListenable(context),
      builder: (context, _) => LayoutBuilder(
        // Measure the pane, not the window: a phone, split view or parallel
        // workspace pane gets compact chrome so the app bar never overflows.
        builder: (context, box) =>
            _buildChatScaffold(context, box.maxWidth, box.maxHeight),
      ),
    ),
  );

  /// Reactions belong to this stored chat on this connection and profile:
  /// another chat or gateway can reuse the same message id.
  String get _reactionChat => [
    'classic',
    widget.connection.id,
    widget.connection.gatewayProfile ?? '',
    _storedSessionId ?? _storedSessionKey,
  ].join('\u0000');

  Widget _buildChatScaffold(
    BuildContext context,
    double paneWidth,
    double paneHeight,
  ) {
    final compactTools = paneWidth < 480;
    // With the keyboard up and little room above it (a landscape phone, a
    // small phone, a Parallel workspace pane), the context header folds so
    // the composer is never pushed under the keyboard. The pane may sit in
    // a Scaffold that has already resized for it: then the local inset is 0
    // and the pane height is what is left.
    final foldHeader =
        keyboardHeightOf(context) > 0 &&
        paneHeight - MediaQuery.viewInsetsOf(context).bottom <
            foldChatChromeBelow;
    final fileOwner = _desktopGateway?.workspace;
    final fileId = _fileSessionId;
    final gateway = _desktopGateway;
    // Captured per build so a menu selection uses the owner shown when it
    // is chosen (a capture from an earlier build may have been superseded).
    WorkspaceWorkersScreen? captureWorkers() {
      final gateway = _desktopGateway;
      final parentId = gateway?.storedSessionKeyFor(_normalLocalSessionKey);
      return _usesNormalInputOwner && gateway != null && parentId != null
          ? WorkspaceWorkersScreen.capture(
              gateway.workspace,
              widget.connection.label,
              storedSessionId: parentId,
            )
          : null;
    }

    final workers = captureWorkers();
    final showQueue = workers != null && gateway?.sessionAuthority == true;
    final radio = compactTools ? compactRadioTool(context) : null;
    void openGatewayQueue([WorkspaceWorkersScreen? fresh]) {
      final target = fresh ?? workers!;
      final writer = _draftWriter, revision = _composerRevision;
      final text = _attachmentDrafts.isEmpty ? _textController.text : '';
      GatewayQueueScreen.open(
        context,
        target.owner,
        target.route,
        draft: text,
        onAdmitted: (sent) {
          if (mounted &&
              writer == _draftWriter &&
              writer.isCurrent &&
              revision == _composerRevision &&
              sent == text &&
              text.isNotEmpty &&
              _attachmentDrafts.isEmpty) {
            _setRestoredComposer('');
            _commitComposerForSend();
          }
        },
      );
    }

    void openBrowserPreview() => setState(
      () => _preview.open(
        _desktopGateway!.workspace,
        _storedSessionId ?? _storedSessionKey,
      ),
    );
    final chat = Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: widget.onClose == null,
        leading: widget.onClose == null
            ? null
            : IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonLabel,
                onPressed: widget.onClose,
                icon: const Icon(Icons.close),
              ),
        title: Text(
          _sessionTitle.trim().isEmpty
              ? context.l10n.untitled_chat
              : _sessionTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        bottom: foldHeader
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: ChatContextHeader(
                  projectName: _projectName,
                  model: _sessionModel ?? widget.session.model,
                  reasoningEffort: _sessionReasoningEffort ?? 'default',
                  reasoningEffortWire: _sessionReasoningWire,
                  connectionLabel: widget.connection.label,
                  connectionStatus: _chatConnectionStatus,
                ),
              ),
        actions: [
          PresentationChrome(
            compact: compactTools,
            activity: (_sending || _streaming)
                ? PetActivity.working
                : _companionUnread
                ? PetActivity.completed
                : PetActivity.idle,
            unread: _companionUnread,
            onCompose: () {
              setState(() => _companionUnread = false);
              _composerFocus.requestFocus();
            },
          ),
          IconButton(
            tooltip: context.sharedL10n.release_chat_find_in_transcript,
            icon: const Icon(Icons.find_in_page_outlined),
            onPressed: () => _reader.currentState?.open(),
          ),
          if (fileOwner != null && fileId != null && !_showSessionFiles)
            IconButton(
              tooltip: context
                  .sharedL10n
                  .release_core_session_files_view_session_files,
              icon: const Icon(Icons.account_tree_outlined),
              onPressed: () => setState(() => _showSessionFiles = true),
            ),
          if (_archiving)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(
                child: SizedBox.square(
                  key: ValueKey('chat-archive-progress'),
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          if (!compactTools) ...[
            if (_voiceLiveMode?.hasStatus == true)
              IconButton(
                key: const ValueKey('voice-engine-toolbar'),
                tooltip: context.sharedL10n.voice_engine_title,
                icon: const Icon(Icons.graphic_eq),
                onPressed: () => unawaited(
                  showVoiceEngineSheet(
                    context,
                    controller: _voiceLiveMode!,
                    disabled: _liveEngine?.active == true,
                  ),
                ),
              ),
            if (widget.onOpenAppCommandPalette != null)
              IconButton(
                key: const ValueKey('app-command-palette-button'),
                tooltip: context.l10n.palette_open,
                icon: const Icon(Icons.keyboard_command_key),
                onPressed: widget.onOpenAppCommandPalette,
              ),
            if (_desktopGateway != null)
              IconButton(
                tooltip: context.sharedL10n.release_chat_open_browser_preview,
                icon: const Icon(Icons.web_asset),
                onPressed: openBrowserPreview,
              ),
            if (showQueue)
              IconButton(
                tooltip: context
                    .sharedL10n
                    .release_core_gateway_queue_screen_gateway_queue,
                icon: const Icon(Icons.queue),
                onPressed: openGatewayQueue,
              ),
            if (workers != null)
              IconButton(
                tooltip: context.l10n.workspace_workers,
                icon: const Icon(Icons.hub_outlined),
                onPressed: () => workers.open(context),
              ),
          ] else if (_desktopGateway != null ||
              _voiceLiveMode?.hasStatus == true ||
              _wake?.state.offered == true ||
              workers != null ||
              radio != null ||
              widget.onOpenAppCommandPalette != null)
            // One always-visible menu on narrow panes, also while a reply
            // streams (the gateway queue matters most then). The radio's
            // and the wake word's controls move here from the app bar and
            // the composer row.
            PopupMenuButton<String>(
              key: const ValueKey('chat-tools-menu'),
              tooltip: context.sharedL10n.release_chat_more_tools,
              icon: const Icon(Icons.widgets_outlined),
              onSelected: (tool) {
                if (tool == wakeWordToolValue) {
                  unawaited(_toggleWakeFromMenu());
                  return;
                }
                if (tool == voiceEngineToolValue && _voiceLiveMode != null) {
                  unawaited(
                    showVoiceEngineSheet(
                      context,
                      controller: _voiceLiveMode!,
                      disabled: _liveEngine?.active == true,
                    ),
                  );
                  return;
                }
                if (tool == 'app-command-palette') {
                  widget.onOpenAppCommandPalette?.call();
                  return;
                }
                if (tool == radioToolValue) {
                  final current = compactRadioTool(context);
                  if (current != null) {
                    unawaited(showAresRadioSheet(context, current));
                  }
                  return;
                }
                if (tool == 'browser' && _desktopGateway != null) {
                  openBrowserPreview();
                }
                if (tool == 'queue' || tool == 'workers') {
                  final fresh = captureWorkers();
                  if (fresh == null) return;
                  if (tool == 'workers') fresh.open(context);
                  if (tool == 'queue' &&
                      _desktopGateway?.sessionAuthority == true) {
                    openGatewayQueue(fresh);
                  }
                }
                if (tool == 'history') _openHistory();
              },
              itemBuilder: (_) => [
                if (_wake case final wake? when wake.state.offered)
                  wakeWordToolItem(context, wake.state),
                if (_voiceLiveMode?.hasStatus == true)
                  voiceEngineToolItem(context, _voiceLiveMode!),
                if (widget.onOpenAppCommandPalette != null)
                  PopupMenuItem(
                    value: 'app-command-palette',
                    child: ListTile(
                      leading: const Icon(Icons.keyboard_command_key),
                      title: Text(context.l10n.palette_open),
                    ),
                  ),
                if (_desktopGateway != null)
                  PopupMenuItem(
                    value: 'browser',
                    child: ListTile(
                      leading: const Icon(Icons.web_asset),
                      title: Text(
                        context.sharedL10n.release_chat_open_browser_preview,
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
                      title: Text(context.l10n.workspace_workers),
                    ),
                  ),
                if (_desktopGateway != null)
                  PopupMenuItem(
                    value: 'history',
                    child: ListTile(
                      leading: const Icon(Icons.account_tree_outlined),
                      title: Text(
                        _fileSessionId == null
                            ? context.l10n.import_claude_or_codex
                            : context.l10n.session_history,
                      ),
                    ),
                  ),
                if (radio != null) radioToolItem(context),
              ],
            ),
          if (_streaming)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: paneWidth * (compactTools ? 0.3 : 0.45),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        context.l10n.responding,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            IconButton(
              tooltip: context.l10n.command_palette,
              onPressed: _showCommandPalette,
              icon: const Icon(Icons.terminal_outlined),
            ),
            PopupMenuButton<String>(
              // Named: the pane holds other menus of this type (the narrow
              // pane's chat tools, the composer's Status).
              key: const ValueKey('chat-actions-menu'),
              tooltip: context.l10n.chat_actions,
              onOpened: () => unawaited(_refreshArchiveState()),
              onSelected: (action) {
                if (action == 'record-voice') unawaited(_startRecordedVoice());
                if (action == 'refresh' && !_pendingReattachResync) {
                  _fetchMessages(focusSavedHistory: true);
                }
                if (action == 'export') _exportConversation();
                if (action == 'history') _openHistory();
                if (action == 'received-output-info') {
                  unawaited(_showReceivedOutputDetails());
                }
                if (action == 'rename') unawaited(_renameSession());

                if (action == 'archive') unawaited(_setSessionArchived(true));
                if (action == 'unarchive') {
                  unawaited(_setSessionArchived(false));
                }
              },
              itemBuilder: (_) => [
                if (!isParkedAutomotive)
                  PopupMenuItem(
                    value: 'record-voice',
                    enabled:
                        !_voiceComposer.listening &&
                        !_voiceRecording.busy &&
                        !_voiceRecording.recording &&
                        !_voiceRecording.hasDraft &&
                        !_pendingReattachResync,
                    child: ListTile(
                      leading: const Icon(Icons.mic),
                      title: Text(context.l10n.voice_recording_start),
                    ),
                  ),
                PopupMenuItem(
                  value: 'rename',
                  enabled: _canRename,
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text(context.l10n.rename),
                  ),
                ),
                PopupMenuItem(
                  value: _sessionArchived ? 'unarchive' : 'archive',
                  enabled: _canArchive,
                  child: ListTile(
                    leading: Icon(
                      _sessionArchived
                          ? Icons.unarchive_outlined
                          : Icons.archive_outlined,
                    ),
                    title: Text(
                      _sessionArchived
                          ? context.l10n.unarchive_chat
                          : context.l10n.archive_chat,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'refresh',
                  enabled: !_pendingReattachResync,
                  child: ListTile(
                    leading: Icon(Icons.refresh),
                    title: Text(context.l10n.refresh),
                  ),
                ),
                PopupMenuItem(
                  value: 'export',
                  child: ListTile(
                    leading: Icon(Icons.ios_share_outlined),
                    title: Text(context.l10n.export_share),
                  ),
                ),
                if (_desktopGateway != null)
                  PopupMenuItem(
                    value: 'history',
                    child: ListTile(
                      leading: const Icon(Icons.account_tree_outlined),
                      title: Text(
                        _fileSessionId == null
                            ? context.l10n.import_claude_or_codex
                            : context.l10n.session_history,
                      ),
                    ),
                  ),
                if (_hasReceivedOutput)
                  PopupMenuItem(
                    value: 'received-output-info',
                    child: ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text(context.l10n.received_output_details),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
      body: SessionFilesLayout(
        files: !_showSessionFiles || fileOwner == null || fileId == null
            ? null
            : SessionFilesView(
                owner: fileOwner,
                route: fileOwner.route(storedSessionId: fileId),
                audioFilesClient: _newMediaFilesClient,
                startOnGit: _openGit,
                focusGitFile: _gitFocus,
                onGitClosed: () => setState(() => _openGit = false),
                onHandOff: (text) {
                  final current = _textController.text.trim();
                  _textController.text = current.isEmpty
                      ? text
                      : '$current\n$text';
                  setState(() {
                    _openGit = false;
                    _showSessionFiles = false;
                  });
                },
                onClose: () => setState(() => _showSessionFiles = false),
                onReference: (ref) {
                  if (fileOwner != _desktopGateway?.workspace ||
                      fileId != _fileSessionId) {
                    return;
                  }
                  appendWorkspaceReference(_textController, ref);
                  setState(() => _showSessionFiles = false);
                },
              ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              // Width belongs to each message, not the entire transcript:
              // a table can use this pane while ordinary prose stays capped.
              maxWidth: double.infinity,
            ),
            child: Column(
              children: [
                if (_verboseMode)
                  for (final notification in _gatewayNotifications.values)
                    _buildGatewayNotification(notification),
                if (_verboseMode && _legacyTransportFallback)
                  Container(
                    key: const ValueKey('legacy-transport-notice'),
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Text(
                      _stockGatewayFallback
                          ? context
                                .l10n
                                .this_server_doesn_t_offer_background_recovery_chats_run_live
                          : context
                                .l10n
                                .background_recovery_unavailable_legacy_transport,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, viewport) {
                      final slashOpen = _slashDropdownVisible;
                      final slashMax = (viewport.maxHeight * 0.4)
                          .clamp(0.0, 180.0)
                          .toDouble();
                      final slashHeight = slashOpen ? slashMax : 0.0;
                      return Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned.fill(child: _buildBody()),
                                if (_endAffordanceController.isVisible ||
                                    _canFocusSavedRecovery)
                                  Positioned(
                                    right: 12,
                                    bottom: 12,
                                    child: ChatEndAffordance(
                                      newMessageCount: _endAffordanceController
                                          .newMessageCount,
                                      onPressed: _goToEnd,
                                      label: _canFocusSavedRecovery
                                          ? context.l10n.saved_history_heading
                                          : null,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (slashOpen)
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: slashHeight,
                              ),
                              child: SlashCommandDropdown(
                                controller: _slashController,
                                onSelected: _applySlashCommand,
                              ),
                            ),
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 800),
                              child: _buildInputBar(
                                availableHeight:
                                    viewport.maxHeight - slashHeight,
                                compactTools: compactTools,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // A wide chat opens the Kanban board beside itself (the dock's rows).
    return KanbanPaneHost(
      key: _kanbanPane,
      child: transcriptShortcuts(_reader, chat),
    );
  }

  Widget _buildGatewayNotification(GatewayNotification notification) {
    final tokens = HermesTokens.of(context);
    final color = switch (notification.level) {
      GatewayNotificationLevel.success => tokens.success,
      GatewayNotificationLevel.warning => tokens.warning,
      GatewayNotificationLevel.error => tokens.danger,
      GatewayNotificationLevel.info => tokens.running,
    };
    return MaterialBanner(
      backgroundColor: color.withValues(alpha: 0.12),
      leading: Icon(Icons.notifications_outlined, color: color),
      content: SelectionArea(child: Text(notification.text)),
      actions: [
        TextButton(
          onPressed: () {
            _notificationTimers.remove(notification.key)?.cancel();
            setState(() => _gatewayNotifications.remove(notification.key));
          },
          child: Text(context.l10n.dismiss),
        ),
      ],
    );
  }

  String? get _currentActivityText {
    final snapshot = _normalSnapshot;
    if (snapshot != null) {
      if (!snapshot.hasActiveTurn ||
          snapshot.responseFailure != null ||
          snapshot.turnId != null && snapshot.turnId == _hiddenActivityTurnId) {
        return null;
      }
      if (snapshot.pendingInput.isNotEmpty) {
        return context.l10n.hermes_is_waiting_for_input;
      }
    } else if (!_sending && !_streaming && !_pendingReattachResync) {
      return null;
    }
    final status = _gatewayTurnStatus;
    return switch (status?.kind) {
      'tool' => context.l10n.using(status!.text),
      'reasoning' => context.l10n.reasoning,
      'subagent' => context.l10n.delegated_task(status!.text),
      _ => status?.text ?? context.l10n.hermes_is_responding,
    };
  }

  String? get _terminalNoticeText {
    final snapshot = _normalSnapshot;
    if (snapshot?.responseFailure case final failure?) {
      return context.l10n.send_failed(failure);
    }
    if (snapshot?.hasActiveTurn == true) return null;
    if (snapshot?.phase == NormalGatewayTurnPhase.failed) {
      return context.l10n.send_failed(
        snapshot?.error ?? context.l10n.turn_failed,
      );
    }
    if (snapshot?.phase == NormalGatewayTurnPhase.reconciledUnknown) {
      return snapshot?.status?.text;
    }
    return _terminalTurnNotice;
  }

  Widget _buildInputBar({
    required double availableHeight,
    bool compactTools = false,
  }) {
    final handsFreeAction = _buildHandsFreeComposerAction();
    final separateVoiceAction = MediaQuery.sizeOf(context).width < 400;
    // Also true in a pane whose host Scaffold already resized for the
    // keyboard (its MediaQuery then shows no inset).
    final keyboardOpen = keyboardHeightOf(context) > 0;
    // The model/status row is chrome: with the keyboard up and under
    // [foldComposerStatusBelow] for transcript and composer, it folds away
    // (and comes back when the keyboard closes).
    final foldStatus =
        keyboardOpen && availableHeight < foldComposerStatusBelow;
    final sendEnabled =
        !_voiceRecording.recording &&
        !_voiceRecording.busy &&
        (!_transcriptLoadBlocksComposer &&
            !_preparingPaste &&
            !_startingVoiceInput &&
            !_archiving &&
            !_preparingSend &&
            !_midTurnSendInFlight &&
            !_stopResponseInFlight &&
            !_pendingReattachResync &&
            !_voiceComposer.listening &&
            _normalChat?.snapshot.steering != true &&
            (_streaming
                ? (_normalChat?.snapshot.hasActiveTurn != true ||
                      _normalChat!.canSteer)
                : !_sending));
    final sendTooltip =
        _streaming && _normalChat?.snapshot.hasActiveTurn != true
        ? context.l10n.stop_and_send
        : context.l10n.send;
    const minimumControlsHeight = 56.0;
    final composerMaxHeight = availableHeight <= minimumControlsHeight
        ? availableHeight
        : (availableHeight * 0.85)
              .clamp(minimumControlsHeight, availableHeight)
              .toDouble();
    final composer = Container(
      key: const Key('chat-input-bar'),
      // Leave some transcript visible when space permits. At very small
      // heights, the fixed controls take priority and extras scroll away.
      constraints: BoxConstraints(maxHeight: composerMaxHeight),
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: keyboardOpen ? 0 : 2,
      ),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_catalog case final operation?)
                      CatalogInstallCard(
                        key: ValueKey(operation.opId),
                        operation: operation,
                        respond: (answer) => _respondCatalog(operation, answer),
                        retry: _retryCatalogRow,
                        onDismiss: () {
                          if (_catalog?.opId == operation.opId &&
                              operation.settled) {
                            setState(() => _catalog = null);
                          }
                        },
                      ),
                    if (_setupBeat != null)
                      SetupBeatCard(
                        request: _setupBeat!,
                        onAnswer: (result) =>
                            _answerSetupBeat(_setupBeat!, result),
                      ),
                    if (!isParkedAutomotive &&
                        (_voiceRecording.recording ||
                            _voiceRecording.hasDraft ||
                            _voiceRecording.busy ||
                            _voiceRecording.error != null))
                      VoiceRecordingControls(
                        controller: _voiceRecording,
                        canSend:
                            !_sending &&
                            !_streaming &&
                            !_pendingReattachResync &&
                            !_voiceComposer.listening,
                        onSend: () => unawaited(_sendRecordedVoice()),
                      ),
                    if (_imageRestoreRevision() != null)
                      PreparedImageRecovery(
                        target: _imageTarget!,
                        revision: () => _draftWriter.hasConfirmedEmptyDraft
                            ? _imageRestoreRevision()
                            : null,
                        install: (text, drafts) {
                          setState(() => _attachmentDrafts.addAll(drafts));
                          _editComposerAsUser(text);
                        },
                      )
                    else if (_quietImageComposer && _imageRecoveryGap != null)
                      ImageRecoveryCapabilityNotice(gap: _imageRecoveryGap!),
                    if (_recoveryMessage != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: FailureRecoveryCard(
                          message: _recoveryMessage!,
                          recovery: presentRecovery(
                            _recoverySurface,
                            nowMs: DateTime.now().millisecondsSinceEpoch,
                          ),
                          diagnosticsText: formatErrorDiagnostics(
                            errorText: _recoveryMessage!,
                            surface: _recoverySurface,
                          ),
                          showDiagnostics: showsDiagnostics(_recoverySurface),
                          resetsAt: _recoverySurface?.resetsAt,
                          onDismiss: () => setState(() {
                            _recoveryMessage = null;
                            _recoverySurface = null;
                          }),
                          onRetry: () {
                            final prompt = _lastPromptText;
                            setState(() {
                              _recoveryMessage = null;
                              _recoverySurface = null;
                            });
                            if (prompt != null) unawaited(_retryPrompt(prompt));
                          },
                          onCompress: _desktopGateway == null
                              ? null
                              : _compressClassicChat,
                          onChooseModel: () => _showModelSelector(),
                          onSwitchTo: _switchToSuggested,
                          // REST cannot regenerate: the card says so
                          // before the switch, not after it.
                          switchRetries: _canRegenerate,
                          onNewSession: widget.singleSession
                              ? null
                              : () => unawaited(_openFreshDraftChat('')),
                        ),
                      ),
                    if (!_usesNormalInputOwner && _held.entries.isNotEmpty)
                      ClientHeldQueueBar(
                        count: _held.entries.length,
                        parked: _held.parked,
                        rows: [
                          for (final entry in _held.entries)
                            ClientHeldQueueRow(id: entry.id, text: entry.text),
                        ],
                        onResume: () {
                          _held.unpark();
                          setState(() {});
                          unawaited(_drainHeldIfIdle());
                        },
                        onSend: (id) => unawaited(_sendHeldNow(id)),
                        onRemove: (id) {
                          _heldTouched = true;
                          setState(() => _held.remove(id));
                          unawaited(_persistHeldQueue());
                        },
                        onEdit: (id) => unawaited(_editHeld(id)),
                      ),
                    if (!_hasStoredArchiveTarget &&
                        _attachmentDrafts.isEmpty &&
                        !_sending &&
                        !_streaming)
                      OrphanDraftRecovery(
                        writer: _draftWriter,
                        editor: _textController,
                        lookup: _client.getSession,
                        isCurrent: () =>
                            _composerOwnerCurrent &&
                            !_hasStoredArchiveTarget &&
                            _attachmentDrafts.isEmpty &&
                            !_sending &&
                            !_streaming,
                      ),
                    ClassicKanbanDock(
                      dock: _kanbanDock,
                      availableHeight: availableHeight,
                      onOpen: (card) => unawaited(_openKanban(card)),
                      onShowAll: () => unawaited(_openKanban()),
                    ),
                    if (_currentActivityText case final activity?)
                      ChatActivityBar(text: activity)
                    else if (_terminalNoticeText case final notice?)
                      ChatActivityBar(text: notice, isTerminalNotice: true),
                    if (!foldStatus)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                        child: Row(
                          children: [
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _modelRowButton(context),
                              ),
                            ),
                            // Status shares the model row: no extra height.
                            ComposerStatusMenu(
                              layout: _statusLayout,
                              usage: const UsageReading(),
                              breakdown: _statusBreakdown,
                              onLayout: _setStatusLayout,
                            ),
                          ],
                        ),
                      ),
                    if (!foldStatus)
                      ComposerContextStatus(
                        layout: _statusLayout,
                        usage: const UsageReading(),
                        breakdown: _statusBreakdown,
                        breakdownLoading: _statusBreakdownLoading,
                        showMenu: false,
                        compact: MediaQuery.sizeOf(context).width < 480,
                        maxHeight:
                            availableHeight * (keyboardOpen ? 0.15 : 0.25),
                        onLayout: _setStatusLayout,
                      ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: availableHeight * (keyboardOpen ? 0.2 : 0.3),
                      ),
                      child: SingleChildScrollView(
                        child: ComposerReferenceAssist(
                          controller: _textController,
                          cacheScope: (_composerGateway, widget.session.id),
                          completePath: _composerGateway == null
                              ? null
                              : (query) async {
                                  final result = await _composerRpc(
                                    'complete.path',
                                    pathCompletionParams(query: query),
                                  );
                                  final rows = parseReferenceCompletions(
                                    result,
                                  );
                                  return rows.isEmpty
                                      ? starterSuggestions(query)
                                      : rows;
                                },
                          completeSlash: _composerGateway == null
                              ? null
                              : (text) async => parseArgumentCompletion(
                                  await _composerRpc('complete.slash', {
                                    'text': text,
                                  }),
                                ),
                        ),
                      ),
                    ),
                    if (_attachmentDrafts.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.fromLTRB(4, 4, 4, 8),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Semantics(
                          label: context.l10n.attachment_drafts,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              // Scaffold has already subtracted the keyboard and app bar.
                              maxHeight: availableHeight * 0.32,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _attachmentDrafts.length,
                              itemBuilder: (context, index) =>
                                  AttachmentDraftTile(
                                    key: ValueKey(_attachmentDrafts[index].id),
                                    previewOwner: _draftWriter,
                                    draft: _attachmentDrafts[index],
                                    index: index,
                                    total: _attachmentDrafts.length,
                                    busy: _sending || _preparingPaste,
                                    onMovePrevious: () => _moveAttachment(
                                      _attachmentDrafts[index],
                                      -1,
                                    ),
                                    onMoveNext: () => _moveAttachment(
                                      _attachmentDrafts[index],
                                      1,
                                    ),
                                    onRetry: () => _retryAttachment(
                                      _attachmentDrafts[index],
                                    ),
                                    onRemove: () => _removeAttachment(
                                      _attachmentDrafts[index],
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    if (handsFreeEnabled.value &&
                        _handsFreeSupported &&
                        !_voiceComposer.listening &&
                        (_handsFree.active ||
                            _handsFree.state == HandsFreeState.error))
                      HandsFreeVoiceControls(
                        controller: _handsFree,
                        onStart: () => unawaited(_startHandsFree()),
                        onStop: () => unawaited(
                          _handsFree
                              .stop(reason: HandsFreeStopReason.user)
                              .catchError((Object _) {}),
                        ),
                        followupTimeout: _followupTimeout,
                        onFollowupChanged: (seconds) =>
                            unawaited(_setFollowupSeconds(seconds)),
                      ),
                    if (_handsFreeSupported &&
                        _handsFree.permissionSetupComplete &&
                        !_handsFree.active)
                      Semantics(
                        liveRegion: true,
                        child: Text(context.l10n.hands_free_setup_complete),
                      ),
                    if (_voiceComposer.listening)
                      VoiceComposerIndicator(
                        controller: _voiceComposer,
                        onStop: () => unawaited(_voiceComposer.stop()),
                        onCancel: () => unawaited(_voiceComposer.cancel()),
                      ),
                    if (_wake case final wake?)
                      GatewayWakeListeningBanner(
                        controller: wake,
                        available: availableHeight,
                        sessionId: widget.session.id,
                      ),
                    // Barge-in keeps the mic on while a reply is read.
                    if (_bargeInLive != null)
                      BargeInMicLiveIndicator(
                        label: context.l10n.barge_in_mic_live,
                      ),
                  ],
                ),
              ),
            ),
            if (separateVoiceAction && handsFreeAction != null)
              Align(alignment: Alignment.centerRight, child: handsFreeAction),
            if (_preparingPaste)
              LinearProgressIndicator(
                key: const Key('paste-attachment-preparing'),
                semanticsLabel: context.l10n.preparing_attachments,
              ),
            Container(
              key: const Key('chat-composer-pill'),
              // The fixed 56 px control budget must hold with the IME open:
              // drop the outer insets then and keep only the pill's own.
              margin: keyboardOpen
                  ? const EdgeInsets.fromLTRB(4, 0, 4, 0)
                  : const EdgeInsets.fromLTRB(4, 0, 4, 4),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: HermesTokens.of(context).border),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    color: Theme.of(
                      context,
                    ).colorScheme.shadow.withValues(alpha: 0.45),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, box) {
                  // While a turn runs, Attach is disabled anyway; on a narrow
                  // row it steps aside for Queue so the editor keeps its
                  // width. It returns when the turn ends.
                  final showQueueHeld = _streaming && !_usesNormalInputOwner;
                  final showAttach = !(showQueueHeld && box.maxWidth < 360);
                  return Row(
                    children: [
                      if (showAttach)
                        Semantics(
                          label: context.l10n.add_attachment,
                          button: true,
                          enabled:
                              !_transcriptLoadBlocksComposer &&
                              !_preparingPaste &&
                              !_streaming &&
                              !_sending &&
                              !_pendingReattachResync,
                          excludeSemantics: true,
                          child: IconButton(
                            icon: const Icon(Icons.attach_file),
                            onPressed:
                                (!_transcriptLoadBlocksComposer &&
                                    !_preparingPaste &&
                                    !_streaming &&
                                    !_sending &&
                                    !_pendingReattachResync)
                                ? _showAttachmentPicker
                                : null,
                            tooltip: context.l10n.attach_image_or_file,
                            constraints: const BoxConstraints.tightFor(
                              width: 48,
                              height: 48,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Semantics(
                          label: context.l10n.message,
                          textField: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Formatting is a writing aid, not chrome: keep it
                              // out of the compact pill until there is a draft.
                              if (!keyboardOpen)
                                ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _textController,
                                  builder: (context, value, _) =>
                                      value.text.trim().isEmpty
                                      ? const SizedBox.shrink()
                                      : _composerFormatRow(context),
                                ),
                              if (!keyboardOpen) const SizedBox(height: 4),
                              // Files from the OS, the clipboard, a keyboard
                              // or the files panel become drafts, never sends.
                              OsFileDropTarget(
                                enabled: _attachIntakeOpen,
                                onFiles: (files) =>
                                    unawaited(_intakeLocalFiles(files)),
                                child: ClipboardAttachmentPaste(
                                  owner: _intakeOwner,
                                  enabled: _attachIntakeOpen,
                                  onAttachment: _intakeClipboard,
                                  child: ComposerDropSurface(
                                    onDrop: (drag) =>
                                        unawaited(_intakeComposerDrag(drag)),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: (availableHeight * 0.30)
                                            .clamp(48.0, 160.0),
                                      ),
                                      child: SendOnEnter(
                                        enabled: sendEnabled,
                                        onNavigate: (event) =>
                                            _composerOwnerCurrent &&
                                                _attachmentDrafts.isEmpty &&
                                                !_slashDropdownVisible
                                            ? _promptRecall.handle(
                                                event,
                                                _textController,
                                                _sentPrompts,
                                              )
                                            : KeyEventResult.ignored,
                                        onSend: () => unawaited(_sendMessage()),
                                        child: ChatPresenceComposer(
                                          builder: (_, input) => TextField(
                                            key: const Key(
                                              'chat-message-composer',
                                            ),
                                            onChanged: (_) => input(),
                                            focusNode: _composerFocus,
                                            controller: _textController,
                                            contextMenuBuilder:
                                                ClipboardAttachmentPaste
                                                    .contextMenuBuilder,
                                            inputFormatters: [
                                              _largePasteFormatter,
                                              _pathPasteFormatter,
                                            ],
                                            contentInsertionConfiguration:
                                                composerImageInsertion(
                                                  _intakeImageBytes,
                                                ),
                                            decoration: InputDecoration(
                                              hintText:
                                                  context.l10n.message_hermes,
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              border: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              isDense: true,
                                            ),
                                            minLines: 1,
                                            maxLines: 5,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            keyboardType:
                                                TextInputType.multiline,
                                            textInputAction:
                                                TextInputAction.newline,
                                            enabled:
                                                !_transcriptLoadBlocksComposer,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!separateVoiceAction && handsFreeAction != null)
                        handsFreeAction,
                      // A pane under 480 px has it in More chat tools, as
                      // NextGen does.
                      if (_wake case final wake? when !compactTools)
                        GatewayWakeToolbarButton(
                          controller: wake,
                          sessionId: widget.session.id,
                          onNotice: (msg) => ScaffoldMessenger.maybeOf(
                            context,
                          )?.showSnackBar(SnackBar(content: Text(msg))),
                        ),
                      if (!isParkedAutomotive &&
                          !_voiceComposer.listening &&
                          !_streaming &&
                          _liveEngine?.active != true)
                        VoiceComposerStartButton(
                          enabled:
                              !_transcriptLoadBlocksComposer &&
                              !_preparingPaste &&
                              !_startingVoiceInput &&
                              !_streaming &&
                              !_sending &&
                              !_pendingReattachResync,
                          onPressed: _startVoiceInput,
                        ),
                      if (!isParkedAutomotive)
                        Semantics(
                          label: context.l10n.spoken_replies,
                          value: _voiceReplyEnabled
                              ? context.l10n.on
                              : context.l10n.off,
                          toggled: _voiceReplyEnabled,
                          button: true,
                          excludeSemantics: true,
                          child: IconButton(
                            icon: Icon(
                              _voiceReplyEnabled
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                            ),
                            onPressed: () {
                              setState(
                                () => _voiceReplyEnabled = !_voiceReplyEnabled,
                              );
                              if (!_voiceReplyEnabled) {
                                _handsFree.revoke(
                                  HandsFreeStopReason.voiceReplyDisabled,
                                );
                                unawaited(
                                  _replySpeaker.stop().catchError(
                                    (Object _) {},
                                  ),
                                );
                              }
                            },
                            tooltip: _voiceReplyEnabled
                                ? context.l10n.spoken_replies_on
                                : context.l10n.spoken_replies_off,
                            constraints: const BoxConstraints.tightFor(
                              width: 48,
                              height: 48,
                            ),
                          ),
                        ),
                      const SizedBox(width: 4),
                      if (_streaming) ...[
                        if (showQueueHeld)
                          _buildComposerAction(
                            key: const Key('chat-queue-held'),
                            label: context.sharedL10n.ng_queue,
                            tooltip: context
                                .sharedL10n
                                .release_chat_queue_until_finished,
                            icon: Icons.queue,
                            onPressed: _queueHeldFromComposer,
                          ),
                        _buildComposerAction(
                          key: const Key('chat-stop-response'),
                          label: context.l10n.stop_response,
                          tooltip: context.l10n.stop_response,
                          icon: Icons.stop_rounded,
                          onPressed: _stopResponseInFlight
                              ? null
                              : _stopResponse,
                        ),
                        const SizedBox(width: 4),
                      ],
                      _buildSendFab(
                        sendEnabled: sendEnabled,
                        sendTooltip: sendTooltip,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    return PopScope(
      // Back closes the command list before it leaves the chat; the draft is
      // untouched either way.
      canPop: !_slashDropdownVisible,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _slashController.close();
        }
      },
      child: CallbackShortcuts(
        // Physical Esc closes the list without touching the draft.
        bindings: {
          const SingleActivator(LogicalKeyboardKey.escape): () {
            if (_slashDropdownVisible || _slashController.isOpen) {
              _slashController.close();
              return;
            }
            if (_streaming && !_stopResponseInFlight) {
              unawaited(_stopResponse());
            }
          },
        },
        child: ChatComposerSlashInfo(
          controller: _textController,
          focusNode: _composerFocus,
          commands: _slashController,
          isAvailable: () => _slashCommandsAvailable,
          dropdownOpen: _slashDropdownVisible,
          localCommands: _localNewSessionNames,
          scope: widget.session.id,
          child: composer,
        ),
      ),
    );
  }

  Widget? _buildHandsFreeComposerAction() {
    if (isParkedAutomotive) return null;
    if (_liveEngine case final live? when live.active) {
      return VoiceLiveInlineControls(
        engine: live,
        compact: MediaQuery.sizeOf(context).width < 480,
        onToggleMute: _toggleLiveMute,
        onInterrupt: _interruptLiveVoice,
        onStop: () => unawaited(_stopLiveVoice()),
      );
    }
    if (_voiceLiveMode case final mode?
        when mode.hasStatus && mode.selectedMode == 'gpt-live') {
      if (_voiceComposer.listening ||
          _streaming ||
          _sending ||
          _preparingSend) {
        return null;
      }
      return GestureDetector(
        onLongPress: () =>
            unawaited(showVoiceEngineSheet(context, controller: mode)),
        child: IconButton(
          key: const Key('voice-live-start'),
          tooltip: context.sharedL10n.voice_live_start,
          icon: const Icon(Icons.graphic_eq),
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          onPressed: () => unawaited(_startVoiceConversation()),
        ),
      );
    }
    // The feature is switched off in Settings: hide the control entirely. A
    // session that is still winding down after the switch keeps its Stop
    // reachable until the stop lands.
    if (!handsFreeEnabled.value && !_handsFree.active) return null;
    if (_handsFree.active || _handsFree.state == HandsFreeState.error) {
      return IconButton(
        key: const Key('hands-free-quick-stop'),
        tooltip: context.l10n.hands_free_stop,
        icon: const Icon(Icons.voice_over_off),
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        onPressed: () => unawaited(
          _handsFree
              .stop(reason: HandsFreeStopReason.user)
              .catchError((Object _) {}),
        ),
      );
    }
    // Starting hands-free is unavailable while a turn owns the composer. Do
    // not spend editor width on an inert Start; active Stop is never omitted.
    if (!_handsFreeSupported ||
        _voiceComposer.listening ||
        _streaming ||
        _sending ||
        _preparingSend) {
      return null;
    }
    return IconButton(
      key: const Key('hands-free-start'),
      tooltip: context.l10n.hands_free_start,
      icon: const Icon(Icons.record_voice_over_outlined),
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      onPressed: _handsFree.starting
          ? null
          : () => unawaited(_startHandsFree()),
    );
  }

  Widget _buildComposerAction({
    required Key key,
    required String label,
    required String tooltip,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    final tokens = HermesTokens.of(context);
    return Semantics(
      label: label,
      button: true,
      enabled: onPressed != null,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.accentContainer,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            key: key,
            icon: Icon(icon, size: 20),
            style: IconButton.styleFrom(
              foregroundColor: tokens.onAccentContainer,
            ),
            onPressed: onPressed,
            tooltip: tooltip,
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          ),
        ),
      ),
    );
  }

  /// M3 Expressive send control: filled accent FAB that morphs from a circle
  /// to a squircle while a turn runs, so mid-run steering reads as "send this
  /// now" without swapping the control away. The icon and key stay stable for
  /// assistive tech and the steer-contract tests; only shape and color move.
  Widget _buildSendFab({
    required bool sendEnabled,
    required String sendTooltip,
  }) {
    final tokens = HermesTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: sendTooltip == context.l10n.send
          ? context.l10n.send_message
          : sendTooltip,
      button: true,
      enabled: sendEnabled,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: 48,
        child: AnimatedContainer(
          duration: Duration.zero,
          curve: Curves.easeOutBack,
          decoration: BoxDecoration(
            color: sendEnabled ? tokens.accent : tokens.raised,
            borderRadius: BorderRadius.circular(_streaming ? 14 : 24),
            // Constant shadow list: BoxShadow.scale would lerp a removed
            // entry through negative blur under the overshoot curve.
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: const Offset(0, 3),
                color: scheme.shadow.withValues(alpha: 0.3),
              ),
            ],
          ),
          child: IconButton(
            key: const Key('chat-send-message'),
            icon: const Icon(Icons.send, size: 20),
            style: IconButton.styleFrom(
              foregroundColor: sendEnabled ? tokens.onAccent : tokens.muted,
            ),
            onPressed: sendEnabled ? _sendMessage : null,
            tooltip: sendTooltip,
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          ),
        ),
      ),
    );
  }

  Widget _composerFormatRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _composerFormatButton(
            tooltip: context.l10n.code_format,
            icon: Icons.code,
            onPressed: () => _insertFormatting('```\n', '\n```'),
          ),
          _composerFormatButton(
            tooltip: context.sharedL10n.release_chat_format_bold,
            icon: Icons.format_bold,
            onPressed: () => _insertFormatting('**', '**'),
          ),
          _composerFormatButton(
            tooltip: context.sharedL10n.release_chat_format_italic,
            icon: Icons.format_italic,
            onPressed: () => _insertFormatting('*', '*'),
          ),
        ],
      ),
    );
  }

  Widget _composerFormatButton({
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Semantics(
      label: tooltip,
      button: true,
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      ),
    );
  }

  void _insertFormatting(String before, String after) {
    final controller = _textController;
    final text = controller.text;
    final selection = controller.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final newText = text.replaceRange(
      start,
      end,
      '$before${text.substring(start, end)}$after',
    );
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: end + before.length + after.length,
      ),
    );
  }

  List<Map<String, dynamic>> _restHistoryForPresentation() =>
      _restReplyRetention?.reconcile(_historyWindow.rows) ??
      _historyWindow.rows;

  List<ChatDisplaySection> _normalDisplaySections({bool? verbose}) {
    final sections = buildNormalChatDisplaySections(
      canonicalRows: _messages,
      receivedRows: _normalSnapshot?.displayRows ?? const [],
      canonicalTools: _toolActivities,
      receivedTools: _normalSnapshot?.tools ?? const [],
      receivedTimeline: _normalSnapshot?.timeline ?? const ChatTimeline(),
      receivedOutcomes: _normalSnapshot?.receivedOutcomes ?? const [],
      subagentActivities: _subagentActivities,
      notices: _gatewayNotices,
      verbose: verbose ?? _verboseMode,
      conversationOnly: !(verbose ?? _verboseMode),
    );
    if (_slashNotices.isEmpty) return sections;
    // Command output is local context, shown in quiet and verbose chat alike.
    return [
      ...sections,
      ChatDisplaySection(
        source: ChatDisplaySource.auxiliary,
        items: List<SlashCommandNotice>.unmodifiable(_slashNotices),
      ),
    ];
  }

  bool get _canFocusSavedRecovery =>
      _normalSnapshot?.hasActiveTurn == false &&
      _normalSnapshot!.receivedOutcomes.any(
        (fact) =>
            fact.outcome == ReceivedLifecycleOutcome.unknown &&
            _historyObservedRecoveryOutcomeIds.contains(fact.id) &&
            !_retainedRecoveryOutcomeIds.contains(fact.id),
      );

  bool _retainIdleRecoveryForPresentation() {
    final snapshot = _normalSnapshot;
    if (snapshot == null || snapshot.hasActiveTurn) return false;
    final before = _retainedRecoveryOutcomeIds.length;
    _retainedRecoveryOutcomeIds.addAll(
      snapshot.receivedOutcomes
          .where(
            (fact) =>
                fact.outcome == ReceivedLifecycleOutcome.unknown &&
                _historyObservedRecoveryOutcomeIds.contains(fact.id),
          )
          .map((fact) => fact.id),
    );
    return _retainedRecoveryOutcomeIds.length != before;
  }

  ChatReceivedRecoveryProjection _normalRecoveryProjection() {
    ChatReceivedRecoveryProjection project(bool verbose) =>
        ChatReceivedRecoveryProjection.build(
          sections: _normalDisplaySections(verbose: verbose),
          timeline: _normalSnapshot?.timeline ?? const ChatTimeline(),
          outcomes: _normalSnapshot?.receivedOutcomes ?? const [],
          retainedOutcomeIds: _retainedRecoveryOutcomeIds,
        );
    return project(_verboseMode);
  }

  Future<void> _inspectRetainedRecovery(ChatDisplaySection section) async {
    if (_receivedRecoverySheetOpen) return;
    // Capture all rendering and media authority before opening another route.
    // The inspector never reads mutable ChatScreen state after construction.
    final connection = _normalSession?.connection ?? widget.connection;
    final sessionId = _storedSessionKey;
    final testFiles = widget.testMediaFilesClient;
    final verbose = _verboseMode;
    final density = _chatDensity;
    final sourceIdentity = (connection, sessionId, ChatDisplaySource.received);
    RemoteFilesDataSource filesClient() =>
        testFiles?.call(sessionId) ??
        RemoteFilesClient.fromConnection(
          connection,
          sessionId: sessionId,
          maxDownloadBytes: maxAttachmentDownloadBytes,
        );
    Widget buildMessage(
      Map<String, dynamic> message,
      bool expanded,
      ValueChanged<bool> onExpansionChanged,
    ) {
      final isUser = message['role'] == 'user';
      final content =
          (message['_display_content'] as String?) ??
          stripToolResultText(
            messageContentToText(
              AndroidPromptContext.displayContent(message, message['content']),
            ),
          );
      return MessageBubble(
        content: content,
        isUser: isUser,
        verbose: verbose,
        density: density,
        metadata: message,
        metadataExpanded: expanded,
        onMetadataExpansionChanged: onExpansionChanged,
        mediaReferencesFinal: message['_gateway_pending_response'] != true,
        mediaSourceIdentity: sourceIdentity,
        mediaFilesClient: filesClient,
        readWidgetHtml: _readWidgetHtml,
        onWidgetIntent: _deliverWidgetIntent,
      );
    }

    _receivedRecoverySheetOpen = true;
    _automaticScrollGeneration++;
    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => RenderScope(
          connection: renderConnectionKey(widget.connection),
          chat: _storedSessionId ?? sessionId,
          child: ReceivedRecoveryInspector(
            section: section,
            verbose: verbose,
            sourceIdentity: sourceIdentity,
            filesClient: filesClient,
            messageBuilder: buildMessage,
          ),
        ),
      );
    } finally {
      _receivedRecoverySheetOpen = false;
    }
  }

  Widget _buildSavedHistoryHeading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Semantics(
        header: true,
        child: Text(
          context.l10n.saved_history_heading,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }

  String _receivedOutcomeLabel(ReceivedLifecycleOutcome outcome) =>
      switch (outcome) {
        ReceivedLifecycleOutcome.completed => context.l10n.turn_completed,
        ReceivedLifecycleOutcome.failed => context.l10n.turn_failed,
        ReceivedLifecycleOutcome.unknown =>
          context.l10n.received_outcome_unknown,
      };

  Widget _buildReceivedCell(
    dynamic item,
    Widget child,
    ReceivedScopeOutcome? fact,
  ) {
    final localPrompt = item is Map<String, dynamic> && item['role'] == 'user';
    final provenance = localPrompt
        ? context.l10n.local_prompt_context
        : context.l10n.received_output_badge;
    final label = fact == null
        ? provenance
        : '${_receivedOutcomeLabel(fact.outcome)} · $provenance';
    // Separate semantics node: do not merge away ExpansionTile/actions, or put
    // changing streamed content into a live-region announcement.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          child: Semantics(
            container: true,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ),
        child,
      ],
    );
  }

  void _pinDetail(Object identity, bool expanded) {
    _detailExpansions.remove(identity);
    _detailExpansions[identity] = expanded;
    if (_detailExpansions.length > ToolActivityGroupPins.maxPins) {
      _detailExpansions.remove(_detailExpansions.keys.first);
    }
  }

  RemoteFilesDataSource _newMediaFilesClient() =>
      widget.testMediaFilesClient?.call(_storedSessionKey) ??
      RemoteFilesClient.fromConnection(
        widget.connection,
        sessionId: _storedSessionKey,
        maxDownloadBytes: maxAttachmentDownloadBytes,
      );

  String _transcriptText(Map<String, dynamic> msg) =>
      (msg['_display_content'] as String?) ??
      stripToolResultText(
        messageContentToText(
          AndroidPromptContext.displayContent(msg, msg['content']),
        ),
      );

  Widget _buildDisplayItem(
    dynamic item, {
    ChatDisplaySource? source,
    bool isLast = false,
  }) {
    if (item is SlashCommandNotice) {
      return SlashCommandNoticeCard(
        key: ValueKey<String>('slash-command-notice-${item.identity}'),
        command: item.command,
        output: item.output,
      );
    }
    if (item is ChatAttachmentItem) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MediaArtifactCard(
          key: ValueKey((
            widget.connection,
            _storedSessionKey,
            source,
            item.id,
          )),
          ref: item.ref,
          filesClient: _newMediaFilesClient,
          sourceIdentity: (widget.connection, _storedSessionKey, source),
        ),
      );
    }
    if (item is ChatToolActivityGroup) {
      return GatewayActivityCard(
        key: ValueKey<String>('tool-activity-${item.id}'),
        activities: item.activities,
        verbose: _verboseMode,
        pinnedExpansion: _toolActivityPins[item.id],
        onPinChanged: (expanded) {
          _toolActivityPins.pin(item.id, expanded);
          final toolId = item.activities.first.toolId;
          if (toolId != null && toolId.isNotEmpty) {
            _toolActivityPins.alias(item.id, 'tool:$toolId');
          }
        },
      );
    }
    if (item is List<GatewaySubagentActivity>) {
      return GatewaySubagentCard(
        key: ValueKey((_reasoningExpansionPins, 'delegation')),
        activities: item,
        pinnedExpansion: _delegationExpanded,
        onPinChanged: (expanded) => _delegationExpanded = expanded,
        onOpenTask: (task) => unawaited(_openDelegatedTask(task)),
      );
    }
    if (item is ChatReasoningItem) {
      // A same-State account/config replacement is a new preference scope.
      // Keep the public inner run key while dropping only that card's old
      // controller-local manual choice when its visit token changes.
      return KeyedSubtree(
        key: ValueKey((_reasoningExpansionPins, item.id)),
        child: GatewayReasoningCard(
          key: ValueKey<String>('reasoning-${item.id}'),
          id: item.id,
          pinnedExpansion: item.id == null
              ? null
              : _reasoningExpansionPins[item.id!],
          onPinChanged: (expanded) {
            if (item.id != null) {
              _reasoningExpansionPins.pin(item.id!, expanded);
            }
          },
          text: item.text,
          initiallyExpanded: item.initiallyExpanded,
        ),
      );
    }
    if (item is GatewayNotice) {
      final identity = (source, 'notice', item.identity);
      return GatewayNoticeCard(
        key: ValueKey((_detailExpansions, identity)),
        notice: item,
        initiallyExpanded: _detailExpansions[identity] ?? false,
        onExpansionChanged: (expanded) => _pinDetail(identity, expanded),
      );
    }

    final msg = item as Map<String, dynamic>;
    final report = BackgroundReport.fromMessage(msg);
    if (report != null) {
      final identity = (source, chatDisplayItemIdentity(msg));
      return BackgroundReportCard(
        key: ValueKey((_backgroundReportExpansions, identity)),
        report: report,
        initiallyExpanded: _backgroundReportExpansions[identity] ?? false,
        onExpansionChanged: (expanded) {
          _backgroundReportExpansions.remove(identity);
          _backgroundReportExpansions[identity] = expanded;
          if (_backgroundReportExpansions.length >
              ToolActivityGroupPins.maxPins) {
            _backgroundReportExpansions.remove(
              _backgroundReportExpansions.keys.first,
            );
          }
        },
      );
    }
    final role = (msg['role'] as String?) ?? 'assistant';
    final content = _transcriptText(msg);
    final isUser = role == 'user';

    return MessageBubble(
      key: msg['_timeline_id'] == null
          ? null
          : ValueKey<String>(msg['_timeline_id'] as String),
      content: content,
      isUser: isUser,
      verbose: _verboseMode,
      metadataExpanded:
          _detailExpansions[(source, chatDisplayItemIdentity(msg))] ?? false,
      onMetadataExpansionChanged: (expanded) =>
          _pinDetail((source, chatDisplayItemIdentity(msg)), expanded),
      density: _chatDensity,
      metadata: msg,
      mediaReferencesFinal: msg['_gateway_pending_response'] != true,
      mediaSourceIdentity: (widget.connection, _storedSessionKey, source),
      mediaFilesClient: _newMediaFilesClient,
      readWidgetHtml: _readWidgetHtml,
      onWidgetIntent: _deliverWidgetIntent,
      onReadAloud: isUser || isParkedAutomotive
          ? null
          : () => _readAssistantText(content, announce: true),
      // Where the transport truncates, Edit rewinds to this turn (Desktop's
      // edit-and-resend); elsewhere it loads the text back into the composer,
      // as it always has there.
      onEdit: !isUser
          ? null
          : _canRegenerate
          ? () => unawaited(
              _editAndResendTurn(content, rowId: _durableRowId(msg)),
            )
          : () => _editAndResend(content),
      onRestore: isUser && _canRegenerate
          ? () =>
                unawaited(_restoreUserTurn(content, rowId: _durableRowId(msg)))
          : null,
      // Every assistant reply offers Regenerate; whether it replaces the
      // turn or asks again is decided when it is chosen.
      onRetry: isUser
          ? null
          : () => _regenerateResponse(msg['_retry_prompt']?.toString() ?? ''),
      showQuickActions:
          !isUser &&
          isLast &&
          msg['_gateway_pending_response'] != true &&
          !_streaming &&
          !_sending &&
          _normalChat?.snapshot.hasActiveTurn != true,
    );
  }

  bool get _hasReceivedOutput =>
      _normalSnapshot?.displayRows.isNotEmpty == true ||
      _normalSnapshot?.timeline.runs.isNotEmpty == true ||
      _normalSnapshot?.tools.isNotEmpty == true;

  List<dynamic> _legacyDisplayItems() {
    final items = !_verboseMode
        ? buildConversationAttachmentItems(
            messages: _messages,
            toolActivities: _toolActivities,
            timeline: _timeline,
          )
        : buildChatDisplayItems(
            messages: _messages,
            toolActivities: _toolActivities,
            subagentActivities: _subagentActivities,
            notices: _gatewayNotices,
            verbose: _verboseMode,
            timeline: _timeline,
          );
    if (_slashNotices.isEmpty) return items;
    return [...items, ..._slashNotices];
  }

  Widget _buildBody() {
    final hasReceived = _hasReceivedOutput;
    if (_loading && _messages.isEmpty && !hasReceived) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _messages.isEmpty && !hasReceived) {
      // Scroll rather than overflow: a foldable's cover display with the IME
      // open leaves ~150 dp for this state, less than the icon + copy + retry.
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber,
                size: 48,
                color: HermesTokens.of(context).warning,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.failed_to_load_messages,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _fetchMessages,
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    final normal = _normalChat != null;
    final recovery = normal ? _normalRecoveryProjection() : null;
    final retained = recovery?.retained;
    final sections = normal ? recovery!.sections : const <ChatDisplaySection>[];
    final displayMessages = normal
        ? [for (final section in sections) ...section.items]
        : _legacyDisplayItems();
    final cells = <({ChatDisplaySource? source, dynamic item, Key key})>[
      if (normal)
        for (final section in sections) ...[
          if (_verboseMode && section.source == ChatDisplaySource.canonical)
            (
              source: section.source,
              item: null,
              key: ValueKey((section.source, 'heading')),
            ),
          for (final item in section.items)
            (
              source: section.source,
              item: item,
              key: ValueKey((section.source, chatDisplayItemIdentity(item))),
            ),
        ]
      else
        for (var i = 0; i < displayMessages.length; i++)
          (source: null, item: displayMessages[i], key: ValueKey(i)),
    ];
    final receivedOutcomes = <Object, ReceivedScopeOutcome>{
      for (final section in sections)
        if (section.source == ChatDisplaySource.received) ...section.outcomes,
    };
    // Retained owner content can be visible while the first HTTP read is still
    // pending, rejected by an active turn, or unavailable. Align that first
    // actual transcript, not the eventual completion of a network request.
    if (displayMessages.isNotEmpty &&
        !_scrollCoordinator.initialEndAlignmentConsumed) {
      _scheduleInitialEndAlignment();
    }
    final cellIndices = <Key, int>{
      for (var i = 0; i < cells.length; i++)
        cells[i].key: i + (_historyWindow.hasOlder ? 1 : 0),
    };

    // The stored row is the durable anchor once available. Carry a pin made
    // while this group was still streaming across the tool-id → row-id handoff.
    for (final group in displayMessages.whereType<ChatToolActivityGroup>()) {
      final toolId = group.activities.first.toolId;
      if (group.id.startsWith('message:') &&
          toolId != null &&
          toolId.isNotEmpty) {
        _toolActivityPins.alias('tool:$toolId', group.id);
      }
    }

    final list = NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        _syncEndAffordance(notification.metrics, clearUnreadAtEnd: false);
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.only(bottom: _chatDensity.listEndPadding),
          itemCount: cells.length + (_historyWindow.hasOlder ? 1 : 0),
          findChildIndexCallback: normal ? (key) => cellIndices[key] : null,
          itemBuilder: (context, index) {
            if (_historyWindow.hasOlder && index == 0) {
              return Center(
                child: TextButton(
                  key: const Key('chat-load-older'),
                  onPressed: _loadingOlder || _sending || _streaming
                      ? null
                      : _loadOlderMessages,
                  child: _loadingOlder
                      ? const CircularProgressIndicator()
                      : Text(context.l10n.load_more),
                ),
              );
            }
            final cell = cells[index - (_historyWindow.hasOlder ? 1 : 0)];
            if (cell.item == null) {
              return KeyedSubtree(
                key: cell.key,
                child: _buildSavedHistoryHeading(),
              );
            }
            final child = _buildDisplayItem(
              cell.item,
              source: cell.source,
              isLast:
                  index - (_historyWindow.hasOlder ? 1 : 0) == cells.length - 1,
            );
            if (cell.source == null) return child;
            return KeyedSubtree(
              key: cell.key,
              child: _verboseMode && cell.source == ChatDisplaySource.received
                  ? _buildReceivedCell(
                      cell.item,
                      child,
                      receivedOutcomes[chatDisplayItemIdentity(cell.item)],
                    )
                  : child,
            );
          },
        ),
      ),
    );
    // Keep the Scrollable mounted when loading/error chrome changes; replacing
    // its parent would discard the opening alignment or the reader's position.
    return Column(
      children: [
        if (retained != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: OutlinedButton.icon(
              key: const Key('chat-retained-received-output'),
              onPressed: () => unawaited(_inspectRetainedRecovery(retained)),
              icon: const Icon(Icons.history),
              label: Text(context.l10n.received_output_badge),
            ),
          ),
        if (_loading) const LinearProgressIndicator(),
        if (_turnChangedFiles case final changed when changed.isNotEmpty)
          TurnChangedFilesCard(
            files: changed,
            onOpen: (file) => setState(() {
              _showSessionFiles = true;
              _openGit = true;
              _gitFocus = file.path;
            }),
          ),
        if (_error != null)
          MaterialBanner(
            content: Text(context.l10n.failed_to_load_messages),
            actions: [
              TextButton(
                onPressed: () => unawaited(_fetchMessages()),
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        Expanded(
          child: TranscriptReader(
            key: _reader,
            owner: (_reasoningRegistry, widget.session.id),
            scroll: _scrollController,
            onLatest: _goToEnd,
            storageKey: widget.session.isLocalDraft && _storedSessionId == null
                ? null
                : readingPositionKey(
                    'classic',
                    widget.connection.id,
                    widget.connection.gatewayProfile,
                    _storedSessionId ?? _storedSessionKey,
                  ),
            onNavigate: () {
              _openingScrollInterrupted = true;
              _initialEndFramesRemaining = 0;
              ++_automaticScrollGeneration;
              _scrollCoordinator.updateFromUserScroll(isNearEnd: false);
            },
            entries: () => [
              for (final (i, cell) in cells.indexed)
                if (cell.item case final Map<String, dynamic> msg
                    when msg['role'] == 'user' || msg['role'] == 'assistant')
                  (
                    id: (cell.source, chatDisplayItemIdentity(msg)),
                    index: i + (_historyWindow.hasOlder ? 1 : 0),
                    text: _transcriptText(msg),
                    prompt: msg['role'] == 'user',
                  ),
            ],
            child: list,
          ),
        ),
      ],
    );
  }

  Future<void> _applySessionModelOverride(
    DesktopGatewayClient desktopGateway,
  ) async {
    if (_modelOverrideFresh) {
      // Switch to has just set it on this live session (one config.set, as
      // Desktop's switchAndRetry): its retry does not send it again.
      _modelOverrideFresh = false;
      return;
    }
    final provider = _sessionProvider;
    final model = _sessionModel;
    if (!_sessionModelOverride || provider == null || model == null) return;
    await desktopGateway.setSessionModel(
      sessionId: _normalLocalSessionKey,
      provider: provider,
      model: model,
    );
    final effort = _sessionReasoningEffort;
    if (effort != null) {
      await desktopGateway.setSessionReasoning(
        sessionId: _normalLocalSessionKey,
        effort: effort,
      );
    }
  }

  Future<void> _showCommandPalette() async {
    var query = '';
    final action = await showDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          scrollable: true,
          title: Text(context.l10n.command_palette),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                key: const Key('command-palette-query'),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: context.l10n.command_palette_hint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) => setDialogState(() => query = value),
              ),
              const SizedBox(height: 12),
              _CommandPaletteResults(
                query: query,
                onSelect: (action) => Navigator.of(dialogContext).pop(action),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.close),
            ),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    _executeCommand(action);
  }

  void _executeCommand(String action) {
    switch (action) {
      case 'copy-last-code':
        unawaited(_copyLastCodeBlock());
      case 'refresh':
        if (!_pendingReattachResync) _fetchMessages(focusSavedHistory: true);
      case 'export':
        _exportConversation();
      case 'rename':
        unawaited(_renameSession());
      case 'archive':
        unawaited(_setSessionArchived(true));
      case 'unarchive':
        unawaited(_setSessionArchived(false));
    }
  }

  Future<void> _copyLastCodeBlock() async {
    // Use the transcript's current presentation order and visibility, not raw
    // durable history. Received output remains independent until proven handoff;
    // recovery/task inspectors and hidden quiet-mode commentary are not targets.
    final items = _normalChat != null
        ? [
            for (final section in _normalRecoveryProjection().sections)
              ...section.items,
          ]
        : _legacyDisplayItems();
    String? code;
    for (final row in items.reversed.whereType<Map<String, dynamic>>()) {
      if (row['role'] != 'assistant' ||
          BackgroundReport.fromMessage(row) != null) {
        continue;
      }
      final content = row['_display_content'] as String? ?? '';
      final blocks = splitMarkdownCodeBlocks(
        content,
      ).whereType<MarkdownCodeBlock>();
      if (blocks.isEmpty) continue;
      // Match the renderer's fence grammar, omitting only the final line break.
      code = blocks.last.code.replaceFirst(RegExp(r'\r?\n$'), '');
      break;
    }
    if (code == null) return;
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.code_copied),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

class MessageBubble extends StatelessWidget {
  final String content;
  final bool isUser;
  final bool verbose;
  final ChatDensity density;
  final bool metadataExpanded;
  final ValueChanged<bool>? onMetadataExpansionChanged;
  final Map<String, dynamic> metadata;
  final Future<void> Function()? onReadAloud;
  final VoidCallback? onEdit;
  final VoidCallback? onRestore;
  final Future<void> Function()? onRetry;
  final bool mediaReferencesFinal;

  /// Always-visible quick actions under the newest completed assistant reply.
  final bool showQuickActions;

  /// Gateway files client factory for `MEDIA:` artifact cards. Assistant
  /// bubbles without it render `MEDIA:` tags as prose (e.g. transcript views
  /// with no session to resolve paths against — a same-path local file on
  /// the phone would be worse than a dead link).
  final RemoteFilesDataSource Function()? mediaFilesClient;
  final Object? mediaSourceIdentity;
  final WidgetHtmlReader? readWidgetHtml;
  final Future<void> Function(String prompt)? onWidgetIntent;

  const MessageBubble({
    super.key,
    required this.content,
    required this.isUser,
    this.verbose = false,
    this.density = ChatDensity.comfortable,
    this.metadataExpanded = false,
    this.onMetadataExpansionChanged,
    this.metadata = const {},
    this.onReadAloud,
    this.onEdit,
    this.onRestore,
    this.onRetry,
    this.mediaFilesClient,
    this.mediaSourceIdentity,
    this.mediaReferencesFinal = true,
    this.showQuickActions = false,
    this.readWidgetHtml,
    this.onWidgetIntent,
  });

  Future<void> _copyMessage(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: content));
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.message_copied),
          duration: Duration(seconds: 2),
        ),
      );
  }

  /// Opens the message in a selection-enabled dialog so a single sentence can
  /// be copied without taking the whole message. The rendering matches the
  /// bubble; the text is selectable with the platform handles, which keeps the
  /// long-press actions on the bubble itself untouched.
  ///
  /// One [SelectionArea] spans the whole message: prose renders as plain
  /// [MarkdownBody] text and fenced code keeps its copy/wrap block, so a drag
  /// can extend across paragraphs, lists and code fences — as much of the
  /// reply as the user wants, not just one block.
  Future<void> _showSelectTextDialog(BuildContext context) async {
    // Capture the bubble's owner before crossing the modal boundary. The
    // dialog is not its descendant, and the bubble may later be deactivated.
    final previewOwner = InlineMediaPreviewScope.ownerOf(context);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        // The dialog renders on the dialog surface, not on a bubble: use the
        // prose colours with the dialog's own onSurface, not onAccent.
        final dialogTheme = Theme.of(dialogContext);
        final tokens = HermesTokens.of(dialogContext);
        final dialogData = !isUser && mediaFilesClient != null
            ? inlineDeliveredFilesAsLinks(
                content,
                isFinal: mediaReferencesFinal,
              )
            : content;
        final sheet = _messageStyleSheet(
          dialogContext,
          dialogTheme,
          tokens,
          isUser: false,
          assistantTextColor: dialogTheme.colorScheme.onSurface,
        );
        return AlertDialog(
          title: Text(dialogContext.l10n.select_text),
          content: SingleChildScrollView(
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final block in splitMarkdownCodeBlocks(
                    dialogData,
                    selectable: false,
                  ))
                    if (block is MarkdownCodeBlock)
                      block
                    else
                      ...richProseWidgets(
                        text: block as String,
                        tablesOnly: true,
                        markdown: (text) => MarkdownBody(
                          data: text,
                          selectable: false,
                          sizedImageBuilder: (image) => externalEmbed(
                            dialogContext,
                            uri: '${image.uri}',
                            alt: image.alt ?? image.title,
                            blocked: Text(image.alt ?? image.title ?? ''),
                            linkColor: sheet.a?.color,
                          ),
                          onTapLink: (_, href, _) => unawaited(
                            _openLink(
                              dialogContext,
                              href,
                              previewOwner: previewOwner,
                            ),
                          ),
                          styleSheet: sheet,
                        ),
                      ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(dialogContext.l10n.close),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openLink(
    BuildContext context,
    String? href, {
    InlineMediaPreviewOwner? previewOwner,
  }) async {
    final path = href == null ? null : deliveredFilePathFromHref(href);
    if (path == null) {
      await openMarkdownWebLink(context, href);
      return;
    }
    _openDeliveredLink(context, href, previewOwner: previewOwner);
  }

  MediaTagRef _deliveryRef(MediaTagRef ref) {
    final hints = metadata['_delivery_refs'];
    final hint = hints is Map<String, MediaTagRef> ? hints[ref.path] : null;
    if (ref.suggestedFilename != null || hint?.suggestedFilename == null) {
      return ref;
    }
    return MediaTagRef(
      path: ref.path,
      quoted: ref.quoted,
      suggestedFilename: hint!.suggestedFilename,
    );
  }

  void _openDeliveredLink(
    BuildContext context,
    String? href, {
    InlineMediaPreviewOwner? previewOwner,
  }) {
    final filesClient = !isUser ? mediaFilesClient : null;
    final path = href == null ? null : deliveredFilePathFromHref(href);
    if (filesClient == null || path == null || !context.mounted) return;
    final eligible = extractDeliveredFileRefs(
      content,
      isFinal: mediaReferencesFinal,
    ).any((ref) => ref.path == path);
    if (!eligible) return;
    unawaited(
      openMediaFilePreview(
        context: context,
        filesClient: filesClient,
        ref: _deliveryRef(MediaTagRef(path: path)),
        sourceIdentity: mediaSourceIdentity,
        owner: previewOwner,
      ).catchError((Object error) {
        debugPrint('media preview failed: $error');
      }),
    );
  }

  MarkdownStyleSheet _messageStyleSheet(
    BuildContext context,
    ThemeData theme,
    HermesTokens tokens, {
    required bool isUser,
    required Color assistantTextColor,
  }) {
    final foreground = isUser ? tokens.onAccent : assistantTextColor;
    final body = chatTypeface(
      context,
      theme.textTheme.bodyMedium?.copyWith(color: foreground),
    );
    final rule = isUser ? tokens.onAccent : tokens.border;
    return MarkdownStyleSheet(
      p: body,
      code: terminalTypeface(
        context,
        tokens.typography.mono.copyWith(
          backgroundColor: tokens.accentContainer,
          color: tokens.onAccentContainer,
        ),
      ),
      a: TextStyle(
        color: isUser ? tokens.onAccent : tokens.accent,
        decoration: TextDecoration.underline,
        decorationColor: isUser ? tokens.onAccent : tokens.accent,
      ),
      h1: theme.textTheme.headlineSmall?.copyWith(color: foreground),
      h2: theme.textTheme.titleLarge?.copyWith(color: foreground),
      h3: theme.textTheme.titleMedium?.copyWith(color: foreground),
      h4: theme.textTheme.titleSmall?.copyWith(color: foreground),
      h5: body?.copyWith(fontWeight: FontWeight.bold),
      h6: body?.copyWith(fontWeight: FontWeight.bold),
      blockquote: body?.copyWith(fontStyle: FontStyle.italic),
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: rule, width: 3)),
      ),
      em: body?.copyWith(fontStyle: FontStyle.italic),
      strong: body?.copyWith(fontWeight: FontWeight.bold),
      del: body?.copyWith(decoration: TextDecoration.lineThrough),
      listBullet: body,
      checkbox: body,
      tableHead: body?.copyWith(fontWeight: FontWeight.bold),
      tableBody: body,
      tableBorder: TableBorder.all(color: rule),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: rule)),
      ),
      codeblockDecoration: BoxDecoration(color: tokens.accentContainer),
    );
  }

  /// Splits assistant text on `MEDIA:` refs (when a files client is
  /// available) and renders each piece: prose through the markdown/code-block
  /// pipeline, standalone-line refs as download cards. Code fences are split
  /// out FIRST and stay verbatim — a `MEDIA:` example inside a code block is
  /// documentation, not a delivery. Mid-line refs stay in the prose as
  /// markdown links so they never fragment a list item or table row.
  List<Widget> _renderContent(
    BuildContext context,

    HermesTokens tokens,
    bool isUser,
    Color assistantTextColor,
  ) {
    final styleSheet = _messageStyleSheet(
      context,
      Theme.of(context),
      tokens,
      isUser: isUser,
      assistantTextColor: assistantTextColor,
    );
    final filesClient = !isUser ? mediaFilesClient : null;
    final mediaPaths = filesClient == null
        ? const <String>{}
        : {
            for (final ref in extractMediaTagRefs(
              content,
              isFinal: mediaReferencesFinal,
            ))
              ref.path,
          };
    final markdownRefs = <String, MediaTagRef>{};
    if (filesClient != null) {
      for (final ref in extractMarkdownFileRefs(
        content,
        isFinal: mediaReferencesFinal,
      )) {
        if (!mediaPaths.contains(ref.path)) {
          markdownRefs.putIfAbsent(ref.path, () => ref);
        }
      }
    }
    final hasTable = _hasTable;
    Widget prose(String text) {
      final body = transcriptBody(
        MarkdownBody(
          data: text,
          selectable: false,
          styleSheet: styleSheet,
          // Local images become lazy file cards below. Remote https images
          // follow Inline Embeds; nothing loads a host path from the phone.
          sizedImageBuilder: (image) => externalEmbed(
            context,
            uri: '${image.uri}',
            alt: image.alt ?? image.title,
            blocked: Text(image.alt ?? image.title ?? ''),
            linkColor: styleSheet.a?.color,
          ),
          onTapLink: (_, href, _) => unawaited(_openLink(context, href)),
        ),
      );
      final boundedBody = hasTable
          ? ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 752),
              child: body,
            )
          : body;
      if (isUser) return boundedBody;
      return transcriptEmbeds(
        context,
        text,
        boundedBody,
        complete: mediaReferencesFinal,
      );
    }

    final parseMedia = filesClient != null;
    final blocks = splitMarkdownCodeBlocks(content, openTail: true);
    final mediaOccurrences = <String, int>{};

    List<Widget> renderProse(String text) {
      List<Widget> rich(String chunk) => richProseWidgets(
        text: chunk,
        markdown: prose,
        readHtml: readWidgetHtml,
        onIntent: onWidgetIntent,
      );
      if (!parseMedia) return rich(text);
      final segments = splitMediaTags(text, isFinal: mediaReferencesFinal);
      if (!segments.any((s) => s.isMedia)) {
        return rich(
          inlineMediaTagsAsLinks(text, isFinal: mediaReferencesFinal),
        );
      }
      final widgets = <Widget>[];
      for (final segment in segments) {
        if (segment.isMedia) {
          final path = segment.media!.path;
          final occurrence = mediaOccurrences.update(
            path,
            (value) => value + 1,
            ifAbsent: () => 0,
          );
          widgets.add(
            MediaArtifactCard(
              // The occurrence ordinal keeps repeated paths unique while
              // remaining stable as a streamed suffix grows.
              key: ValueKey((mediaSourceIdentity, path, occurrence)),
              ref: _deliveryRef(segment.media!),
              filesClient: filesClient,
              sourceIdentity: mediaSourceIdentity,
            ),
          );
        } else if (segment.text.trim().isNotEmpty) {
          // Inline refs (mid-line) become markdown links in place.
          widgets.addAll(
            rich(
              inlineMediaTagsAsLinks(
                segment.text,
                isFinal: mediaReferencesFinal,
              ),
            ),
          );
        }
      }
      return widgets;
    }

    return [
      for (final block in blocks)
        if (block is MarkdownCodeBlock)
          RichFence(
            language: block.language,
            code: block.code,
            corpus: content,
            fallback: block,
            readHtml: readWidgetHtml,
            onIntent: onWidgetIntent,
          )
        else
          ...renderProse(block as String),
      if (mediaFilesClient != null && isUser)
        for (final ref in audioPromptFileRefs(content))
          MediaArtifactCard(
            key: ValueKey((mediaSourceIdentity, 'audio-prompt', ref.path)),
            ref: ref,
            filesClient: mediaFilesClient!,
            sourceIdentity: mediaSourceIdentity,
          ),
      if (filesClient != null)
        for (final ref in markdownRefs.values)
          MediaArtifactCard(
            key: ValueKey((mediaSourceIdentity, 'file-link', ref.path)),
            ref: _deliveryRef(ref),
            filesClient: filesClient,
            sourceIdentity: mediaSourceIdentity,
          ),
    ];
  }

  Future<void> _showActions(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      // The sheet scrolls: at large text scales four 48 dp tiles plus the
      // header exceed the default sheet height, and an action a user cannot
      // reach is worse than one that scrolls.
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(
                  context.l10n.message_actions,
                  style: Theme.of(sheetContext).textTheme.titleSmall,
                ),
              ),
              _actionTile(
                sheetContext,
                label: context.l10n.copy_message,
                tooltip: context.l10n.copy_message,
                icon: Icons.copy_outlined,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  unawaited(_copyMessage(context));
                },
              ),
              _actionTile(
                sheetContext,
                label: context.l10n.select_text,
                tooltip: context.l10n.select_text,
                icon: Icons.select_all,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  unawaited(_showSelectTextDialog(context));
                },
              ),
              if (!isUser)
                _actionTile(
                  sheetContext,
                  label: context.l10n.report_ai_output,
                  tooltip: context.l10n.report_ai_output,
                  icon: Icons.flag_outlined,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    unawaited(reportAresAiOutput());
                  },
                ),
              if (onReadAloud != null)
                _actionTile(
                  sheetContext,
                  label: context.l10n.read_aloud,
                  tooltip: context.l10n.read_aloud,
                  icon: Icons.volume_up_outlined,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    unawaited(onReadAloud!());
                  },
                ),
              if (onEdit != null)
                _actionTile(
                  sheetContext,
                  label: context.l10n.edit_and_resend,
                  tooltip: context.l10n.edit_and_resend,
                  icon: Icons.edit_outlined,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onEdit!();
                  },
                ),
              if (onRestore != null)
                _actionTile(
                  sheetContext,
                  key: const Key('message-action-restore'),
                  label: context.l10n.restore_turn_confirm,
                  tooltip: context.l10n.restore_turn_confirm,
                  icon: Icons.settings_backup_restore,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onRestore!();
                  },
                ),
              if (onRetry != null)
                _actionTile(
                  sheetContext,
                  label: context.l10n.regenerate_response,
                  tooltip: context.l10n.regenerate_response,
                  icon: Icons.refresh,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    unawaited(onRetry!());
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  /// Always-visible affordances for the most recent completed assistant
  /// reply. The long-press sheet stays the full action set; this row surfaces
  /// the actions users reach for most (copy, select, read aloud, regenerate).
  Widget _quickActionBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _quickAction(
            context,
            key: const Key('message-action-copy'),
            icon: Icons.copy_outlined,
            label: context.l10n.copy_message,
            onTap: () => unawaited(_copyMessage(context)),
          ),
          _quickAction(
            context,
            key: const Key('message-action-select'),
            icon: Icons.select_all,
            label: context.l10n.select_text,
            onTap: () => unawaited(_showSelectTextDialog(context)),
          ),
          if (onReadAloud != null)
            _quickAction(
              context,
              key: const Key('message-action-read'),
              icon: Icons.volume_up_outlined,
              label: context.l10n.read_aloud,
              onTap: () => unawaited(onReadAloud!()),
            ),
          if (onRetry != null)
            _quickAction(
              context,
              key: const Key('message-action-retry'),
              icon: Icons.refresh,
              label: context.l10n.regenerate_response,
              onTap: () => unawaited(onRetry!()),
            ),
        ],
      ),
    );
  }

  Widget _quickAction(
    BuildContext context, {
    required Key key,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final tokens = HermesTokens.of(context);
    return Semantics(
      label: label,
      button: true,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: InkWell(
          key: key,
          onTap: onTap,
          // A long press anywhere on the reply still opens the full action
          // sheet, including on these buttons: on short replies the row
          // covers the bubble's centre, which used to swallow the gesture.
          onLongPress: () => unawaited(_showActions(context)),
          customBorder: const CircleBorder(),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: tokens.muted),
          ),
        ),
      ),
    );
  }

  Widget _actionTile(
    BuildContext context, {
    Key? key,
    required String label,
    required String tooltip,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Semantics(
      key: key,
      label: label,
      button: true,
      excludeSemantics: true,
      child: Tooltip(
        message: tooltip,
        child: ListTile(
          leading: Icon(icon),
          title: Text(label),
          minTileHeight: 48,
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => InlineMediaPreviewScope(
    filesClient: isUser ? null : mediaFilesClient,
    sourceIdentity: mediaSourceIdentity,
    references: isUser || mediaFilesClient == null
        ? const []
        : extractDeliveredFileRefs(
            content,
            isFinal: mediaReferencesFinal,
          ).map(_deliveryRef).toList(growable: false),
    builder: _buildBubble,
  );

  bool get _hasTable => splitMarkdownCodeBlocks(
    content,
    openTail: true,
  ).whereType<String>().any(richProseContainsTable);

  Widget _buildBubble(BuildContext context) {
    final hasTable = _hasTable;
    final theme = Theme.of(context);
    final tokens = HermesTokens.of(context);
    final userBubbleColor = tokens.accent;
    final assistantBubbleColor = tokens.raised;
    final assistantTextColor = tokens.onSurface;
    final messageTime =
        (isUser || isCompletedChatResponse(metadata)) &&
            metadata['_message_time_continuation'] != true
        ? ChatMessageTime.fromRow(metadata)
        : null;
    final localTime = messageTime?.at.toLocal();
    final clockTime = localTime == null
        ? null
        : MaterialLocalizations.of(context).formatTimeOfDay(
            TimeOfDay.fromDateTime(localTime),
            alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
          );
    final fullTime = localTime == null
        ? null
        : '${MaterialLocalizations.of(context).formatFullDate(localTime)} · $clockTime';

    // Collect extra metadata for verbose mode
    final List<String> metaLines = [];
    if (verbose) {
      final role = (metadata['role'] as String?) ?? 'unknown';
      metaLines.add('role: $role');
      // Show any extra fields that aren't role/content
      for (final entry in metadata.entries) {
        if (entry.key == 'role' ||
            entry.key == 'content' ||
            entry.key == '_delivery_refs') {
          continue;
        }
        final value = entry.value?.toString() ?? 'null';
        if (value.length > 80) {
          metaLines.add('${entry.key}: ${value.substring(0, 80)}…');
        } else {
          metaLines.add('${entry.key}: $value');
        }
      }
    }

    final bubble = GestureDetector(
      key: const Key('message-bubble'),
      onLongPress: () => _showActions(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: hasTable
            ? const EdgeInsets.symmetric(horizontal: 4, vertical: 4)
            : density.bubbleMargin,
        constraints: BoxConstraints(
          maxWidth: hasTable
              ? double.infinity
              : (MediaQuery.sizeOf(context).width - density.maxWidthInset)
                    .clamp(0, 800),
        ),
        padding: hasTable ? const EdgeInsets.all(8) : density.bubblePadding,
        decoration: BoxDecoration(
          color: isUser
              ? userBubbleFill(context, userBubbleColor)
              : assistantBubbleColor,
          borderRadius: BorderRadius.circular(density.bubbleRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Role header keeps user and assistant prose clearly separated.
            // Compact density drops it: alignment and colour already identify
            // the speaker, and the label costs a line per message.
            if (density.showsSenderLabel)
              Padding(
                padding: EdgeInsets.only(bottom: density.senderLabelGap),
                child: Text(
                  isUser
                      ? context.sharedL10n.history_role_user
                      : context.sharedL10n.history_role_assistant,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isUser ? tokens.onAccent : tokens.muted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            // Verbose metadata header
            if (metaLines.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isUser ? tokens.accentContainer : tokens.surface,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: ExpansionTile(
                    key: const ValueKey('message-metadata'),
                    title: Text(context.l10n.message_metadata),
                    dense: true,
                    tilePadding: EdgeInsets.zero,
                    initiallyExpanded: metadataExpanded,
                    onExpansionChanged: onMetadataExpansionChanged,
                    children: metaLines
                        .map(
                          (line) => Text(
                            line,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'monospace',
                              color: isUser
                                  ? tokens.onAccentContainer
                                  : tokens.onSurface,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
            ..._renderContent(context, tokens, isUser, assistantTextColor),
            if (messageTime != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Tooltip(
                  message: switch (messageTime.source) {
                    ChatMessageTimeSource.recorded =>
                      context.l10n.message_time_recorded(fullTime!),
                    ChatMessageTimeSource.sent =>
                      context.l10n.message_time_sent(fullTime!),
                    ChatMessageTimeSource.received =>
                      context.l10n.message_time_received(fullTime!),
                  },
                  child: Text(
                    clockTime!,
                    key: const Key('message-timestamp'),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isUser ? tokens.onAccent : tokens.muted,
                    ),
                  ),
                ),
              ),
            if (showQuickActions) _quickActionBar(context),
            SizedBox(height: density.bodyBottomGap),
          ],
        ),
      ),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: transcriptDirection(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            density.showsSenderLabel
                ? bubble
                : Semantics(
                    container: true,
                    label: isUser
                        ? context.sharedL10n.history_role_user
                        : context.sharedL10n.history_role_assistant,
                    child: bubble,
                  ),
            MessageReaction(messageId: _reactionId),
          ],
        ),
      ),
    );
  }

  String? get _reactionId {
    final id = metadata['id'] ?? metadata['message_id'];
    if (id is! String || id.isEmpty || id.length > 200 || id.contains('\n')) {
      return null;
    }
    return id;
  }
}

class _CommandPaletteResults extends StatelessWidget {
  final String query;
  final ValueChanged<String> onSelect;

  const _CommandPaletteResults({required this.query, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final commands = <String, String>{
      'copy-last-code': context.l10n.command_palette_copy_last_code,
      'refresh': context.l10n.refresh,
      'export': context.l10n.export_share,
      'rename': context.l10n.rename,
      'archive': context.l10n.archive_chat,
      'unarchive': context.l10n.unarchive_chat,
    };
    final lowered = query.toLowerCase();
    final filtered = commands.entries
        .where((entry) => entry.value.toLowerCase().contains(lowered))
        .toList();
    if (filtered.isEmpty) {
      return Text(
        context.l10n.command_palette_no_results,
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final entry in filtered)
          ListTile(
            dense: true,
            leading: const Icon(Icons.arrow_right_rounded, size: 20),
            title: Text(entry.value),
            onTap: () => onSelect(entry.key),
          ),
      ],
    );
  }
}
