import 'dart:async';

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../services/connection_manager.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/bot_desktop_session.dart';
import '../services/bot_sections.dart';
import '../services/remote_workspace.dart';
import '../theme/hermes_theme.dart';
import '../widgets/bot_desktop_viewer.dart';
import '../../nextgen/data/chat_controller.dart';
import '../../nextgen/data/nextgen_gateway.dart';
import '../../nextgen/ui/chat_view.dart';
import '../../nextgen/ui/nextgen_scope.dart';
import 'bot_profile_forms.dart';
import 'chat_screen.dart';

/// Native Bot Mode workspace (`F11`): the bot roster, canonical bot chats,
/// per-bot routines, multi-bot rooms and the Bot Desktop (status, start/stop,
/// thumbnail, takeover lease and sandbox-image switch), scoped to [owner] and
/// [route]. All gateway calls go through the owner's fenced target so late
/// replies never land on a different account or profile.
class BotsScreen extends StatefulWidget {
  const BotsScreen({
    super.key,
    required this.owner,
    required this.route,
    required this.connection,
    this.displayConnector,
    this.openBotChat,
    this.pickAvatarImage,
  });

  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final SavedConnection connection;

  /// Picks an avatar picture as a PNG data URL. Production opens the file
  /// picker ([pickBotAvatarImage]); tests supply one.
  @visibleForTesting
  final Future<String?> Function()? pickAvatarImage;

  /// Opens the live screen for a `display.observe` ticket. Production dials
  /// the gateway's `/api/display/ws`; tests supply an in-memory screen.
  @visibleForTesting
  final BotDisplayConnector? displayConnector;

  /// Shows a bot's chat page. Production pushes it; tests inspect it.
  @visibleForTesting
  final Future<void> Function(BuildContext context, BotChatPage page)?
  openBotChat;

  @override
  State<BotsScreen> createState() => _BotsScreenState();
}

enum _BotsTab { roster, rooms, screen, routines }

class _BotsScreenState extends State<BotsScreen> with WidgetsBindingObserver {
  WorkspacePane? _pane;
  WorkspaceTarget? _target;
  Object? _account;
  Object _token = Object();

  // One counter per kind of read: only the newest request may land.
  int _roomsRequest = 0;
  int _routinesRequest = 0;
  int _screenRequest = 0;
  int _thumbnailRequest = 0;

  _BotsTab _tab = _BotsTab.roster;
  bool _loading = true;
  WorkspaceFailure? _failure;
  String? _errorDetail;

  // Roster
  List<BotRosterProfile> _roster = const [];
  bool _botModeProtocol = false;
  String? _installId;
  String _search = '';
  final _searchController = TextEditingController();

  /// Stored avatar pictures (data URLs) by bot, read on [_avatarTarget].
  Map<String, String> _avatars = const {};
  WorkspaceTarget? _avatarTarget;

  /// Roster sections (Desktop's user-sections.ts): this device's list for
  /// the connection, the sections whose delete is still clearing members,
  /// and the blocks collapsed for this visit.
  List<BotSection> _sections = const [];
  String? _sectionsScope;
  final _sectionDeletes = <String>{};
  final _collapsed = <String>{};
  final _backfilled = <String>{};

  // Rooms
  RoomCapabilities? _roomsCaps;
  List<RoomSummary> _rooms = const [];
  bool _roomsLoading = false;

  // Screen
  String? _screenProfile; // null = current row in roster
  DisplayStatus? _display;

  /// The take-over in progress: the live viewer and the lease it holds.
  BotDesktopSession? _session;

  /// The package install this screen started, with its output so far.
  _BotInstall? _install;
  void Function()? _installUnwatch;
  DisplayThumbnail? _thumbnail;
  ImageProvider? _thumbnailImage;
  bool _thumbnailSuppressed = false;
  Timer? _thumbnailTimer;
  bool _screenBusy = false;

  // Routines
  String? _routinesProfile; // null = _screenProfile or current
  List<RoutineJob> _routines = const [];
  String? _routinesScope;
  bool _routinesLoading = false;

  @override
  void initState() {
    super.initState();
    _account = ConnectionMutationBarrier.capture(widget.route.connectionId);
    ConnectionMutationBarrier.addListener(_onAccountChanged);
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(() {
      final next = _searchController.text.trim();
      if (next != _search && mounted) setState(() => _search = next);
    });
    unawaited(_load());
  }

  @override
  void didUpdateWidget(covariant BotsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.owner != widget.owner || oldWidget.route != widget.route) {
      _closePaneAfterHandBack();
      _pane = null;
      _target = null;
      _account = ConnectionMutationBarrier.capture(widget.route.connectionId);
      _cancelThumbnail();
      // Sections are this connection's: the next roster reads its own.
      _sectionsScope = null;
      _sections = const [];
      _sectionDeletes.clear();
      _collapsed.clear();
      unawaited(_load());
    }
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(_onAccountChanged);
    _cancelThumbnail();
    _thumbnailImage?.evict();
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _stopInstallWatch();
    _closePaneAfterHandBack();
    super.dispose();
  }

  /// Leaving never keeps the bot locked out: the lease is released on the
  /// pane it was taken on, and only then is that pane closed.
  void _closePaneAfterHandBack() {
    final pane = _pane;
    final session = _session;
    _session = null;
    if (session == null) {
      pane?.close();
      return;
    }
    session.removeListener(_onSessionChanged);
    unawaited(session.close().whenComplete(() => pane?.close()));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // In the background the user can neither see nor drive the screen.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      unawaited(_endSession(BotDesktopClose.background));
    }
  }

  void _onSessionChanged() {
    // The viewer dropped or was evicted: the session has released the lease.
    if (_session?.isClosed == true) {
      unawaited(_endSession(_session!.closedBecause!));
    }
  }

  /// Ends the take-over (if any) and repaints the lease the gateway reports.
  Future<void> _endSession(BotDesktopClose because) async {
    final session = _session;
    if (session == null) return;
    _session = null;
    session.removeListener(_onSessionChanged);
    await session.close(because: because);
    if (!_ownsScreen(session.target, session.profile)) return;
    setState(() => _display = _display?.copyWith(lease: session.lease));
    unawaited(_loadScreen(session.target));
  }

  void _onAccountChanged() {
    if (ConnectionMutationBarrier.isCurrent(
      widget.route.connectionId,
      _account,
    )) {
      return;
    }
    _pane?.invalidate();
    _target = null;
    _cancelThumbnail();
    if (mounted) {
      setState(() {
        _loading = false;
        _failure = WorkspaceFailure.stale;
      });
    }
  }

  /// Swaps the decoded frame. The frame it replaces is dropped from the
  /// image cache once the new one has painted, so a 4 s poll keeps one frame
  /// in memory; nothing is written to disk.
  void _showThumbnail(Uint8List? bytes) {
    final previous = _thumbnailImage;
    _thumbnailImage = bytes == null
        ? null
        : ResizeImage.resizeIfNeeded(
            _thumbnailDecodeWidth,
            null,
            MemoryImage(bytes),
          );
    if (previous != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => previous.evict());
    }
  }

  static const _thumbnailDecodeWidth = 1280;

  void _cancelThumbnail() {
    _thumbnailTimer?.cancel();
    _thumbnailTimer = null;
  }

  Future<WorkspaceTarget> _bound() async {
    final existing = _target;
    if (existing != null && existing.isCurrent) return existing;
    _pane?.close();
    final pane = _pane = widget.owner.pane();
    final bound = await pane.bind(widget.route);
    _target = bound;
    return bound;
  }

  Future<void> _load() async {
    final token = _token = Object();
    setState(() {
      _loading = true;
      _failure = null;
      _errorDetail = null;
    });
    try {
      final target = await _bound();
      if (!mounted || !identical(token, _token)) return;
      final roster = await target.botRoster(includeSessions: true);
      if (!mounted || !identical(token, _token)) return;
      setState(() {
        _roster = roster.profiles;
        _botModeProtocol = roster.botModeProtocol;
        _installId = roster.installId;
        _loading = false;
        _screenProfile ??= _roster.firstOrNull?.name;
        _routinesProfile ??= _screenProfile;
      });
      unawaited(_loadAvatars(target, roster.profiles));
      unawaited(_syncSections(target, roster.profiles));
      if (_tab == _BotsTab.rooms) unawaited(_loadRooms(target));
      if (_tab == _BotsTab.routines) unawaited(_loadRoutines(target));
      if (_tab == _BotsTab.screen) unawaited(_loadScreen(target));
    } on WorkspaceException catch (e) {
      if (!mounted || !identical(token, _token)) return;
      setState(() {
        _loading = false;
        _failure = e.reason;
      });
    } catch (_) {
      if (!mounted || !identical(token, _token)) return;
      setState(() {
        _loading = false;
        _failure = WorkspaceFailure.unavailable;
      });
    }
  }

  /// True while [target] is still this screen's gateway: the same
  /// connection, account and profile it was bound for. Every request captures
  /// its target (and its bot) before the first await and checks again after
  /// each one, so a late reply is dropped instead of landing on whatever is
  /// selected now.
  bool _owns(WorkspaceTarget target) =>
      mounted && identical(target, _target) && target.isCurrent;

  bool _ownsScreen(WorkspaceTarget target, String bot) =>
      _owns(target) && _screenProfile == bot;

  bool _ownsRoutines(WorkspaceTarget target, String bot) =>
      _owns(target) && _routinesProfile == bot;

  /// Reads the stored pictures of the bots that have one (Desktop's
  /// `pullServerAvatars`), one at a time, on [target] only.
  Future<void> _loadAvatars(
    WorkspaceTarget target,
    List<BotRosterProfile> roster,
  ) async {
    if (!identical(_avatarTarget, target)) {
      _avatarTarget = target;
      _avatars = const {};
    }
    for (final bot in roster) {
      if (!bot.hasAvatar || _avatars.containsKey(bot.name)) continue;
      try {
        final image = await target.botProfileAvatarUrl(bot.name);
        if (!_owns(target) || !identical(_avatarTarget, target)) return;
        if (image != null) {
          setState(() => _avatars = {..._avatars, bot.name: image});
        }
      } on WorkspaceException catch (e) {
        if (!_owns(target) || e.reason == WorkspaceFailure.unsupported) return;
      }
    }
  }

  Uint8List? _avatarOf(BotRosterProfile bot) =>
      identical(_avatarTarget, _target) && bot.hasAvatar
      ? DisplayThumbnail.decode(_avatars[bot.name])
      : null;

  Widget _face(BotRosterProfile bot, double size) {
    final look = botAppearance(bot.name, bot.look);
    return BotFace(
      key: Key('bots-face-${bot.name}'),
      name: bot.name,
      shape: look.shape,
      color: look.color,
      image: _avatarOf(bot),
      size: size,
    );
  }

  // ── New Bot ───────────────────────────────────────────────────────────

  void _openNewBot() {
    final target = _target;
    if (target == null || !_owns(target)) return;
    unawaited(
      showBotForm(
        context,
        BotCreateForm(
          roster: _roster,
          pickImage: widget.pickAvatarImage ?? pickBotAvatarImage,
          onSubmit: (draft) => _createBot(target, draft),
        ),
      ),
    );
  }

  /// Desktop's New Bot submit: `profiles.create`, then the look on the new
  /// profile's record and its picture. Every step is fenced to [target]: a
  /// reply that arrives after the connection changed is dropped.
  Future<BotFormResult> _createBot(
    WorkspaceTarget target,
    BotCreateDraft draft,
  ) async {
    final l10n = context.sharedL10n;
    if (!_owns(target)) return const BotFormDropped();
    final BotProfileCreated created;
    try {
      created = await target.botProfileCreate(
        name: draft.name,
        description: draft.description,
        cloneFrom: draft.cloneFrom,
        noSkills: draft.noSkills,
        shareAuth: draft.shareAuth,
        soul: draft.soul,
        model: draft.model,
        provider: draft.provider,
      );
    } on BotProfileRefusal catch (e) {
      if (!_owns(target)) return const BotFormDropped();
      return BotFormFailed(e.message);
    } on WorkspaceException catch (e) {
      if (!_owns(target)) return const BotFormDropped();
      return BotFormFailed(l10n.ng_bots_request_failed(e.reason.name));
    }
    if (!_owns(target)) return const BotFormDropped();
    // The profile exists from here on; the look is best-effort, as in
    // Desktop, and Edit Profile can finish it.
    var lookSaved = true;
    try {
      final saved = await target.botSaveLook(created.name, draft.look);
      if (!_owns(target)) return const BotFormDropped();
      lookSaved = saved != BotLookSave.failed;
      final image = draft.image;
      if (image != null) {
        await target.botProfileSetAvatar(created.name, image);
        if (!_owns(target)) return const BotFormDropped();
      }
    } on WorkspaceException {
      if (!_owns(target)) return const BotFormDropped();
      lookSaved = false;
    }
    final shown = draft.title.isNotEmpty ? draft.title : created.name;
    _toast(
      [
        l10n.ng_bots_created(shown),
        if (!lookSaved) l10n.ng_bots_look_failed,
        ...created.warnings,
      ].join('\n'),
    );
    unawaited(_refreshRoster(target));
    return const BotFormDone();
  }

  /// Re-reads the roster after a write without the loading screen.
  Future<void> _refreshRoster(WorkspaceTarget target) async {
    try {
      final roster = await target.botRoster(includeSessions: true);
      if (!_owns(target)) return;
      setState(() => _roster = roster.profiles);
      unawaited(_loadAvatars(target, roster.profiles));
      await _syncSections(target, roster.profiles);
    } on WorkspaceException {
      // The roster on screen stays; Refresh retries.
    }
  }

  // ── Sections ──────────────────────────────────────────────────────────

  String get _sectionScope =>
      BotSectionStore.key(widget.route.connectionId, widget.route.profile);

  void _saveSections() =>
      unawaited(BotSectionStore.save(_sectionScope, _sections));

  /// Reads this connection's sections once, adopts the ones other devices
  /// made from what their members carry, and stamps the name on members
  /// filed before names rode along (Desktop's adopt and backfill).
  Future<void> _syncSections(
    WorkspaceTarget target,
    List<BotRosterProfile> roster,
  ) async {
    final scope = _sectionScope;
    if (_sectionsScope != scope) {
      final loaded = await BotSectionStore.load(scope);
      if (!_owns(target) || scope != _sectionScope) return;
      _sectionsScope = scope;
      _sections = loaded;
    }
    final next = adoptBotSections(_sections, roster, _sectionDeletes);
    final changed = !listEquals(next, _sections);
    setState(() => _sections = next);
    if (changed) _saveSections();
    final known = {for (final s in _sections) s.id};
    for (final bot in roster) {
      final id = bot.sectionId;
      if (id == null ||
          !known.contains(id) ||
          bot.sectionName != null ||
          !_backfilled.add('$scope|${bot.name}')) {
        continue;
      }
      if (!await _fileBots(target, [bot], id, refresh: false)) return;
    }
  }

  /// Desktop's `moveBotsToSection`: one look write per bot, in sequence,
  /// with the section's name riding along (null clears both). Shown at once,
  /// confirmed by the next roster read.
  Future<bool> _fileBots(
    WorkspaceTarget target,
    List<BotRosterProfile> bots,
    String? sectionId, {
    bool refresh = true,
  }) async {
    final l10n = context.sharedL10n;
    for (final bot in bots) {
      // Deleted while this walked its members: do not refile the rest.
      if (sectionId != null && !_sections.any((s) => s.id == sectionId)) {
        return false;
      }
      final name = sectionId == null
          ? null
          : _sections.firstWhere((s) => s.id == sectionId).name;
      // Compared with the row as it is now, not as the caller saw it (an
      // Undo refiles members its delete has already cleared).
      final current = _roster.where((r) => r.name == bot.name).firstOrNull;
      if (current == null) continue;
      if (current.sectionId == sectionId && current.sectionName == name) {
        continue;
      }
      final fields = {'sectionId': sectionId, 'sectionName': name};
      setState(() {
        _roster = [
          for (final row in _roster)
            row.name == bot.name ? row.withLook({...row.look, ...fields}) : row,
        ];
      });
      String? failure;
      try {
        final saved = await target.botSaveLook(bot.name, fields);
        if (!_owns(target)) return false;
        if (saved == BotLookSave.failed) failure = 'ui_meta';
      } on BotProfileRefusal catch (e) {
        if (!_owns(target)) return false;
        failure = e.message;
      } on WorkspaceException catch (e) {
        if (!_owns(target)) return false;
        failure = e.reason.name;
      }
      if (failure != null) {
        _toast(l10n.ng_bots_section_move_failed(failure));
        unawaited(_refreshRoster(target));
        return false;
      }
    }
    if (refresh) unawaited(_refreshRoster(target));
    return true;
  }

  Future<String?> _askSectionName({
    required String title,
    required String ok,
    String initial = '',
  }) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) =>
          _SectionNameDialog(title: title, ok: ok, initial: initial),
    );
    final clean = name?.trim();
    return clean == null || clean.isEmpty ? null : clean;
  }

  /// New section, filing [bot] into it when its menu asked.
  Future<void> _newSection([BotRosterProfile? bot]) async {
    final target = _target;
    if (target == null) return;
    final l10n = context.sharedL10n;
    final name = await _askSectionName(
      title: l10n.ng_bots_section_new,
      ok: l10n.ng_bots_section_create,
    );
    if (name == null || !_owns(target)) return;
    final section = BotSection(newBotSectionId(), name);
    setState(() => _sections = [..._sections, section]);
    _saveSections();
    if (bot != null) await _fileBots(target, [bot], section.id);
  }

  Future<void> _renameSection(BotSection section) async {
    final target = _target;
    if (target == null) return;
    final l10n = context.sharedL10n;
    final name = await _askSectionName(
      title: l10n.ng_bots_section_rename,
      ok: l10n.rename,
      initial: section.name,
    );
    if (name == null || !_owns(target)) return;
    setState(() {
      _sections = [
        for (final s in _sections)
          s.id == section.id ? BotSection(s.id, name) : s,
      ];
    });
    _saveSections();
    // Members carry the name: re-stamping them takes it to other devices.
    await _fileBots(target, [
      for (final bot in _roster)
        if (bot.sectionId == section.id) bot,
    ], section.id);
  }

  void _moveSection(String id, int delta) {
    final from = _sections.indexWhere((s) => s.id == id);
    final to = from + delta;
    if (from < 0 || to < 0 || to >= _sections.length) return;
    setState(() {
      final next = [..._sections];
      next.insert(to, next.removeAt(from));
      _sections = next;
    });
    _saveSections();
  }

  /// Deletes the section only: its bots fall back to Unassigned, so there is
  /// nothing to confirm, and Undo puts the section and its bots back.
  Future<void> _deleteSection(BotSection section) async {
    final target = _target;
    if (target == null) return;
    final l10n = context.sharedL10n;
    final index = _sections.indexOf(section);
    final members = [
      for (final bot in _roster)
        if (bot.sectionId == section.id) bot,
    ];
    _sectionDeletes.add(section.id);
    setState(
      () => _sections = [
        for (final s in _sections)
          if (s.id != section.id) s,
      ],
    );
    _saveSections();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          content: Text(
            l10n.ng_bots_section_deleted(section.name, members.length),
          ),
          action: SnackBarAction(
            key: const Key('bots-section-undo'),
            label: l10n.ng_bots_undo,
            onPressed: () {
              if (!_owns(target)) return;
              _sectionDeletes.remove(section.id);
              setState(() {
                final next = [
                  for (final s in _sections)
                    if (s.id != section.id) s,
                ];
                next.insert(index.clamp(0, next.length), section);
                _sections = next;
              });
              _saveSections();
              unawaited(_fileBots(target, members, section.id));
            },
          ),
        ),
      );
    await _fileBots(target, members, null);
    _sectionDeletes.remove(section.id);
  }

  Future<void> _openMoveTo(BotRosterProfile bot) async {
    final target = _target;
    if (target == null) return;
    // Not section ids: those are trimmed.
    const fresh = ' new', none = ' none';
    final choice = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        key: const Key('bots-move-to'),
        title: Text(ctx.sharedL10n.ng_bots_section_move_to),
        children: [
          for (final s in _sections)
            SimpleDialogOption(
              key: Key('bots-move-to-${s.id}'),
              onPressed: () => Navigator.pop(ctx, s.id),
              child: Row(
                children: [
                  Icon(
                    s.id == bot.sectionId ? Icons.check : Icons.folder_outlined,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(s.name)),
                ],
              ),
            ),
          SimpleDialogOption(
            key: const Key('bots-move-to-new'),
            onPressed: () => Navigator.pop(ctx, fresh),
            child: Text(ctx.sharedL10n.ng_bots_section_new_ellipsis),
          ),
          if (bot.sectionId != null)
            SimpleDialogOption(
              key: const Key('bots-move-to-none'),
              onPressed: () => Navigator.pop(ctx, none),
              child: Text(ctx.sharedL10n.ng_bots_section_remove),
            ),
        ],
      ),
    );
    if (choice == null || !_owns(target)) return;
    if (choice == fresh) return _newSection(bot);
    await _fileBots(target, [bot], choice == none ? null : choice);
  }

  // ── Edit Profile ──────────────────────────────────────────────────────

  void _openEditProfile(BotRosterProfile bot) {
    final target = _target;
    if (target == null || !_owns(target)) return;
    unawaited(
      showBotForm(
        context,
        BotEditForm(
          bot: bot,
          image: identical(_avatarTarget, target) ? _avatars[bot.name] : null,
          pickImage: widget.pickAvatarImage ?? pickBotAvatarImage,
          loadAdvanced: () async {
            final described = await target.botProfileDescribe(bot.name);
            if (!_owns(target)) {
              throw const WorkspaceException(WorkspaceFailure.stale);
            }
            return described;
          },
          confirm: (title, message, ok) =>
              _confirm(title: title, message: message, confirmLabel: ok),
          onSubmit: (edit) => _saveProfile(target, bot.name, edit),
        ),
      ),
    );
  }

  /// Desktop's Edit Profile save: the changed look fields over the bot's
  /// current record (CAS), the picture only when it changed, and one
  /// `profiles.configure` for the description and the dirty Advanced
  /// sections. A guarded model asks with the gateway's own message and is
  /// resent alone with `confirm_expensive_model`.
  Future<BotFormResult> _saveProfile(
    WorkspaceTarget target,
    String name,
    BotProfileEdit edit,
  ) async {
    final l10n = context.sharedL10n;
    if (!_owns(target)) return const BotFormDropped();
    final failed = <String>[];
    var modelKept = false;
    try {
      if (edit.look != null || edit.lookRemove.isNotEmpty) {
        final saved = await target.botSaveLook(
          name,
          edit.look ?? const {},
          remove: edit.lookRemove,
        );
        if (!_owns(target)) return const BotFormDropped();
        if (saved == BotLookSave.failed) failed.add('ui_meta');
      }
      if (edit.imageChanged) {
        await target.botProfileSetAvatar(name, edit.image);
        if (!_owns(target)) return const BotFormDropped();
        if (identical(_avatarTarget, target)) {
          final image = edit.image;
          _avatars = {..._avatars}..remove(name);
          if (image != null) _avatars = {..._avatars, name: image};
        }
      }
      if (edit.description != null || edit.advanced) {
        final result = await target.botProfileConfigure(
          name,
          description: edit.description,
          soul: edit.soul,
          model: edit.model,
          provider: edit.provider,
          disabledSkills: edit.disabledSkills,
          enabledToolsets: edit.enabledToolsets,
          enabledMcpServers: edit.enabledMcpServers,
        );
        if (!_owns(target)) return const BotFormDropped();
        failed.addAll(result.failed);
        final message = result.confirmMessage;
        if (message != null && edit.model != null) {
          final ok = await _confirm(
            title: l10n.ng_bots_model_confirm_title,
            message: message,
            confirmLabel: l10n.ng_bots_model_confirm_ok,
          );
          if (!_owns(target)) return const BotFormDropped();
          if (ok) {
            final confirmed = await target.botProfileConfigure(
              name,
              model: edit.model,
              provider: edit.provider,
              confirmExpensiveModel: true,
            );
            if (!_owns(target)) return const BotFormDropped();
            failed.addAll(confirmed.failed);
          } else {
            modelKept = true;
          }
        }
      }
    } on BotProfileRefusal catch (e) {
      if (!_owns(target)) return const BotFormDropped();
      return BotFormFailed(e.message);
    } on WorkspaceException catch (e) {
      if (!_owns(target)) return const BotFormDropped();
      return BotFormFailed(l10n.ng_bots_request_failed(e.reason.name));
    }
    unawaited(_refreshRoster(target));
    if (failed.isNotEmpty) {
      return BotFormFailed(l10n.ng_bots_sections_failed(failed.join(', ')));
    }
    final shown = edit.look?['title'] is String && edit.look!['title'] != ''
        ? edit.look!['title'] as String
        : (_roster.where((b) => b.name == name).firstOrNull?.title ?? name);
    _toast(
      [
        l10n.ng_bots_updated(shown),
        if (modelKept) l10n.ng_bots_model_not_switched,
      ].join('\n'),
    );
    return const BotFormDone();
  }

  Future<void> _loadRooms(WorkspaceTarget target) async {
    final request = ++_roomsRequest;
    bool current() => request == _roomsRequest && _owns(target);
    setState(() => _roomsLoading = true);
    try {
      final caps = await target.roomCapabilities();
      if (!current()) return;
      final rooms = await target.roomList(limit: 50);
      if (!current()) return;
      setState(() {
        _roomsCaps = caps;
        _rooms = rooms;
        _roomsLoading = false;
      });
    } catch (e) {
      if (!current()) return;
      setState(() {
        _roomsLoading = false;
        _roomsCaps = null;
        _rooms = const [];
        _errorDetail = context.sharedL10n.ng_bots_rooms_load_failed('$e');
      });
    }
  }

  Future<void> _loadRoutines(WorkspaceTarget target) async {
    final bot = _routinesProfile;
    if (bot == null) return;
    final request = ++_routinesRequest;
    bool current() => request == _routinesRequest && _ownsRoutines(target, bot);
    setState(() => _routinesLoading = true);
    try {
      final result = await target.botRoutinesWithLegacyPause(bot);
      if (!current()) return;
      setState(() {
        _routines = result.jobs;
        _routinesScope = result.scoped;
        _routinesLoading = false;
      });
    } on WorkspaceException catch (e) {
      if (!current()) return;
      setState(() {
        _routinesLoading = false;
        _routines = const [];
        _errorDetail = context.sharedL10n.ng_bots_routines_load_failed(
          e.reason.name,
        );
      });
    } catch (_) {
      if (!current()) return;
      setState(() => _routinesLoading = false);
    }
  }

  Future<void> _loadScreen(WorkspaceTarget target) async {
    final bot = _screenProfile;
    if (bot == null) return;
    final request = ++_screenRequest;
    bool current() => request == _screenRequest && _ownsScreen(target, bot);
    try {
      final status = await target.displayStatus(bot);
      if (!current()) return;
      setState(() {
        _display = status;
        _thumbnailSuppressed = false;
      });
      if (status.running) {
        await _refreshThumbnail(target, bot);
        if (!current()) return;
        _scheduleThumbnail(target, bot);
      } else {
        _cancelThumbnail();
      }
    } on WorkspaceException catch (e) {
      if (!current()) return;
      setState(() {
        _display = null;
        _errorDetail = context.sharedL10n.ng_bots_desktop_failed(e.reason.name);
      });
    } catch (_) {
      if (!current()) return;
      setState(() => _display = null);
    }
  }

  Future<void> _refreshThumbnail(WorkspaceTarget target, String bot) async {
    final request = ++_thumbnailRequest;
    try {
      final thumb = await target.displayThumbnail(bot);
      if (request != _thumbnailRequest || !_ownsScreen(target, bot)) return;
      setState(() {
        _thumbnail = thumb;
        _thumbnailSuppressed = thumb.suppressed != null;
        _showThumbnail(thumb.bytes);
      });
    } catch (_) {
      // Thumbnail poll must not spam errors; leave the last frame.
    }
  }

  void _scheduleThumbnail(WorkspaceTarget target, String bot) {
    _cancelThumbnail();
    _thumbnailTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_ownsScreen(target, bot)) {
        timer.cancel();
        return;
      }
      if (_tab == _BotsTab.screen) unawaited(_refreshThumbnail(target, bot));
    });
  }

  /// Runs one Bot Desktop action for the bot selected when it was tapped.
  /// [apply] only runs if that bot (and this gateway) is still the one shown
  /// when the reply arrives.
  Future<void> _screenAction<T>({
    required Future<T> Function(WorkspaceTarget target, String bot) send,
    required void Function(WorkspaceTarget target, String bot, T value) apply,
    required String failure,
  }) async {
    final target = _target;
    final bot = _screenProfile;
    if (target == null || bot == null) return;
    setState(() => _screenBusy = true);
    try {
      final value = await send(target, bot);
      if (!_ownsScreen(target, bot)) return;
      apply(target, bot, value);
    } catch (e) {
      if (_ownsScreen(target, bot)) _toast('$failure: $e');
    } finally {
      if (mounted) setState(() => _screenBusy = false);
    }
  }

  void _stopInstallWatch() {
    _installUnwatch?.call();
    _installUnwatch = null;
  }

  /// `display.install` only starts the package manager on the gateway host.
  /// Its output arrives as `display.install.log` events, its end as
  /// `display.install.done`, and its sudo prompt as a request this screen
  /// answers; all three are followed from before the call is sent.
  Future<void> _startInstalling() async {
    final target = _target;
    final bot = _screenProfile;
    if (target == null || bot == null || _install?.running == true) return;
    final profileKey = _display?.profileKey;
    final install = _BotInstall(bot);
    _stopInstallWatch();
    final unwatchLog = target.watchDisplayInstall(
      profileKey: profileKey,
      onLog: (line) {
        if (!mounted) return;
        setState(() {
          install.lines.add(line);
          if (install.lines.length > _BotInstall.keep) {
            install.lines.removeAt(0);
          }
        });
      },
      onDone: (code, status) => _installDone(target, install, code, status),
    );
    final unwatchSudo = target.answerDisplayInstallSudo(
      profileKey: profileKey,
      onAsked: (request) => unawaited(_askSudo(install, request)),
    );
    _installUnwatch = () {
      unwatchLog();
      unwatchSudo();
    };
    setState(() {
      _install = install;
      _screenBusy = true;
    });
    try {
      final result = await target.displayInstall(bot);
      if (!mounted) return;
      if (!result.started) {
        _installFailed(install, context.sharedL10n.ng_bots_install_not_started);
      } else if (result.command case final command?) {
        setState(() => install.lines.insert(0, '\$ $command'));
      }
    } catch (e) {
      _installFailed(
        install,
        context.sharedL10n.ng_bots_install_failed_error('$e'),
      );
    } finally {
      if (mounted) setState(() => _screenBusy = false);
    }
  }

  void _installFailed(_BotInstall install, String message) {
    if (identical(_install, install)) _stopInstallWatch();
    if (!mounted) return;
    setState(() {
      install.running = false;
      install.error = message;
    });
  }

  void _installDone(
    WorkspaceTarget target,
    _BotInstall install,
    int code,
    DisplayStatus? status,
  ) {
    if (code != 0 || status?.installed != true) {
      _installFailed(install, switch (code) {
        -1 => context.sharedL10n.ng_bots_install_cancelled,
        -2 => context.sharedL10n.ng_bots_install_no_sudo,
        _ => context.sharedL10n.ng_bots_install_exit_code('$code'),
      });
      return;
    }
    if (identical(_install, install)) _stopInstallWatch();
    if (!mounted) return;
    setState(() {
      install.running = false;
      if (identical(_install, install)) _install = null;
      if (_ownsScreen(target, install.bot)) _display = status;
    });
    _toast(context.sharedL10n.ng_bots_install_done(install.bot));
  }

  /// The gateway's sudo prompt for the install this screen started. The
  /// password is read from an obscured field and goes straight into the
  /// response to that one request: it is never stored, logged or put in any
  /// call's params. Cancelling answers empty, which the gateway reads as
  /// "skipped".
  Future<void> _askSudo(
    _BotInstall install,
    DisplayInstallSudoRequest request,
  ) async {
    if (!mounted) {
      request.skip();
      return;
    }
    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SudoPasswordDialog(bot: install.bot),
    );
    if (password == null || password.isEmpty) {
      request.skip();
    } else {
      request.answer(password);
    }
  }

  Future<void> _startScreen() => _screenAction(
    send: (target, bot) => target.displayStart(bot),
    apply: (target, bot, status) {
      setState(() => _display = status);
      if (status.running) {
        unawaited(_refreshThumbnail(target, bot));
        _scheduleThumbnail(target, bot);
      }
    },
    failure: context.sharedL10n.ng_bots_start_failed,
  );

  Future<void> _stopScreen() async {
    final profile = _screenProfile;
    if (_target == null || profile == null) return;
    // The gateway refuses to stop a screen a person is driving unless told
    // to (methods_display.py); say so before asking.
    final humanHeld = _display?.lease.isAgent == false;
    final confirmed = await _confirm(
      title: context.sharedL10n.ng_bots_stop_title(profile),
      message: humanHeld
          ? context.sharedL10n.ng_bots_stop_human_held
          : context.sharedL10n.ng_bots_stop_body,
      confirmLabel: context.sharedL10n.ng_stop,
    );
    if (!confirmed || !mounted || _screenProfile != profile) return;
    await _screenAction(
      send: (target, bot) => target.displayStop(bot, force: humanHeld),
      apply: (target, bot, status) {
        _cancelThumbnail();
        setState(() => _display = status);
      },
      failure: context.sharedL10n.ng_bots_stop_refused,
    );
  }

  /// Take over = open the live viewer, then take the lease. Without a live
  /// viewer nothing is acquired; when the viewer closes, for any reason, the
  /// lease goes back.
  Future<void> _takeOverScreen() async {
    final l10n = context.sharedL10n;
    final target = _target;
    final profile = _screenProfile;
    if (target == null || profile == null || _session != null) return;
    setState(() => _screenBusy = true);
    BotDesktopSession? session;
    try {
      session = await BotDesktopSession.open(
        target,
        profile,
        connect: widget.displayConnector,
        reason: l10n.ng_bots_take_over_reason,
      );
      final foreground =
          WidgetsBinding.instance.lifecycleState == null ||
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
      if (!mounted || !_ownsScreen(target, profile) || !foreground) {
        await session.close();
        return;
      }
      _session = session;
      session.addListener(_onSessionChanged);
      setState(() {
        _screenBusy = false;
        _display = _display?.copyWith(lease: session!.lease);
      });
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              BotDesktopViewerPage(session: session!, botName: profile),
        ),
      );
      // The viewer was closed: hand back.
      await _endSession(BotDesktopClose.handedBack);
    } catch (e) {
      await session?.close();
      if (_ownsScreen(target, profile)) {
        _toast(l10n.ng_bots_take_over_failed('$e'));
        unawaited(_loadScreen(target));
      }
    } finally {
      if (mounted && _screenBusy) setState(() => _screenBusy = false);
    }
  }

  /// The way out when a lease outlived its viewer (a crash, a dropped link,
  /// another device): give the screen back to the bot.
  Future<void> _forceHandBack() async {
    final profile = _screenProfile;
    if (_target == null || profile == null) return;
    final confirmed = await _confirm(
      title: context.sharedL10n.ng_bots_force_hand_back_title(profile),
      message: context.sharedL10n.ng_bots_force_hand_back_body,
      confirmLabel: context.sharedL10n.ng_bots_hand_back,
    );
    if (!confirmed || !mounted || _screenProfile != profile) return;
    await _screenAction(
      send: (target, bot) => target.displayLeaseRelease(bot, force: true),
      apply: (target, bot, lease) =>
          setState(() => _display = _display?.copyWith(lease: lease)),
      failure: context.sharedL10n.ng_bots_hand_back_failed,
    );
  }

  Future<void> _switchSandboxImage() async {
    final profile = _screenProfile;
    if (_target == null || profile == null) return;
    final pending = _display?.imageSwitch;
    final confirmed = await _confirm(
      title: context.sharedL10n.ng_bots_adopt_title,
      message: context.sharedL10n.ng_bots_adopt_body(
        profile,
        '${pending?['current_image'] ?? '?'}',
        '${pending?['target_image'] ?? '?'}',
      ),
      confirmLabel: context.sharedL10n.ng_bots_adopt_image,
    );
    if (!confirmed || !mounted || _screenProfile != profile) return;
    await _screenAction(
      send: (target, bot) =>
          target.displaySwitchSandboxImage(bot, approve: true),
      apply: (target, bot, status) => setState(() => _display = status),
      failure: context.sharedL10n.ng_bots_image_switch_failed,
    );
  }

  Future<void> _keepCurrentImage() => _screenAction(
    send: (target, bot) =>
        target.displaySwitchSandboxImage(bot, approve: false),
    apply: (target, bot, status) => setState(() => _display = status),
    failure: context.sharedL10n.ng_bots_keep_refused,
  );

  /// Asks before stopping, replacing or removing something a bot is using.
  /// False on Cancel or dismissal: the caller then sends nothing.
  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key('bots-confirm-dialog'),
        scrollable: true,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            key: const Key('bots-confirm-cancel'),
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.sharedL10n.cancel),
          ),
          FilledButton(
            key: const Key('bots-confirm-ok'),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return ok == true;
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openCanonicalChat(BotRosterProfile bot) {
    unawaited(() async {
      try {
        final target = await _bound();
        final chat = await target.resolveCanonicalChat(bot.name);
        // The connection or account changed while the chat was resolved.
        if (!mounted || !_owns(target)) return;
        final page = BotChatPage(
          connection: widget.connection,
          storedId: chat.sessionId,
          title: botCanonicalChatTitle,
          profile: chat.profile,
        );
        final open = widget.openBotChat;
        if (open != null) {
          await open(context, page);
        } else {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => page));
        }
        if (mounted) setState(() {});
      } on WorkspaceException catch (e) {
        if (mounted) {
          _toast(context.sharedL10n.ng_bots_chat_open_failed(e.reason.name));
        }
      } catch (e) {
        if (mounted) _toast(context.sharedL10n.ng_bots_chat_open_failed('$e'));
      }
    }());
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 480;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.sharedL10n.ng_bots_title(widget.connection.label)),
        actions: [
          if (_botModeProtocol)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Tooltip(
                message: context.sharedL10n.ng_bots_protocol_tooltip,
                child: Icon(Icons.auto_awesome_outlined, size: 18),
              ),
            ),
          IconButton(
            tooltip: context.sharedL10n.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => unawaited(_load()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: LayoutBuilder(builder: _tabs),
          ),
          Expanded(child: _loadBody(isNarrow)),
        ],
      ),
    );
  }

  List<(_BotsTab, String, IconData)> get _tabSpecs => [
    (
      _BotsTab.roster,
      context.sharedL10n.ng_bots_tab_roster,
      Icons.people_outline,
    ),
    (
      _BotsTab.rooms,
      context.sharedL10n.ng_bots_tab_rooms,
      Icons.groups_outlined,
    ),
    (
      _BotsTab.screen,
      context.sharedL10n.ng_bots_tab_screen,
      Icons.desktop_windows_outlined,
    ),
    (
      _BotsTab.routines,
      context.sharedL10n.ng_bots_tab_routines,
      Icons.schedule_outlined,
    ),
  ];

  /// The tab switcher. Labels show when all four fit at the current text
  /// size; otherwise the tabs are icons with their names as tooltips.
  Widget _tabs(BuildContext context, BoxConstraints constraints) {
    final style = Theme.of(context).textTheme.labelLarge;
    final scaler = MediaQuery.textScalerOf(context);
    var needed = 0.0;
    for (final (_, label, _) in _tabSpecs) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: Directionality.of(context),
        textScaler: scaler,
        maxLines: 1,
      )..layout();
      // Icon, gap and the segment's own padding around the label.
      needed += painter.width + 18 + 8 + 48;
      painter.dispose();
    }
    final labels = needed <= constraints.maxWidth;
    return SegmentedButton<_BotsTab>(
      key: const Key('bots-tabs'),
      showSelectedIcon: false,
      segments: [
        for (final (tab, label, icon) in _tabSpecs)
          ButtonSegment(
            value: tab,
            label: labels ? Text(label) : null,
            tooltip: labels ? null : label,
            icon: Icon(icon),
          ),
      ],
      selected: {_tab},
      onSelectionChanged: (s) => _onTabChanged(s.single),
    );
  }

  void _onTabChanged(_BotsTab tab) {
    if (tab == _tab) return;
    setState(() => _tab = tab);
    final target = _target;
    if (target == null) return;
    switch (tab) {
      case _BotsTab.rooms:
        unawaited(_loadRooms(target));
      case _BotsTab.routines:
        _routinesProfile ??= _screenProfile;
        unawaited(_loadRoutines(target));
      case _BotsTab.screen:
        _screenProfile ??= _roster.firstOrNull?.name;
        unawaited(_loadScreen(target));
      case _BotsTab.roster:
        break;
    }
  }

  Widget _loadBody(bool isNarrow) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_failure != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.sharedL10n.ng_bots_unavailable(_failure!.name),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _failure == WorkspaceFailure.stale
                    ? context.sharedL10n.ng_bots_account_changed
                    : context.sharedL10n.ng_bots_try_refresh,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => unawaited(_load()),
                child: Text(context.sharedL10n.refresh),
              ),
            ],
          ),
        ),
      );
    }
    final banner = _errorDetail;
    return Column(
      children: [
        if (banner != null)
          Material(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      banner,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: context.sharedL10n.ng_dismiss,
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => setState(() => _errorDetail = null),
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: switch (_tab) {
            _BotsTab.roster => _rosterView(isNarrow),
            _BotsTab.rooms => _roomsView(),
            _BotsTab.screen => _screenView(isNarrow),
            _BotsTab.routines => _routinesView(isNarrow),
          },
        ),
      ],
    );
  }

  // ── Roster ────────────────────────────────────────────────────────────

  /// The roster narrowed by the search field, as Desktop's filterBots.
  List<BotRosterProfile> get _visibleRoster =>
      filterBotRoster(_roster, _search);

  Widget _rosterView(bool isNarrow) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: context.sharedL10n.ng_bots_search,
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton.filledTonal(
              key: const Key('bots-new-bot'),
              tooltip: context.sharedL10n.ng_bots_new_bot,
              icon: const Icon(Icons.person_add_alt_1_outlined),
              onPressed: _target == null ? null : _openNewBot,
            ),
            IconButton(
              key: const Key('bots-new-section'),
              tooltip: context.sharedL10n.ng_bots_section_new,
              icon: const Icon(Icons.create_new_folder_outlined),
              onPressed: _target == null
                  ? null
                  : () => unawaited(_newSection()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_visibleRoster.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 48),
            child: Center(child: Text(context.sharedL10n.ng_bots_none_found)),
          ),
        ..._rosterRows(),
        const SizedBox(height: 16),
        const SizedBox(height: 4),
        Text(
          _installId != null
              ? context.sharedL10n.ng_bots_install_id(
                  _installId!,
                  '$_botModeProtocol',
                )
              : context.sharedL10n.ng_bots_protocol_note,
          style: TextStyle(fontSize: 12, color: HermesTokens.of(context).muted),
        ),
      ],
    );
  }

  /// The roster in Desktop's order (pinned, then newest activity), grouped
  /// into sections when there are any: sections in their order, then
  /// Unassigned. A search looks in every section and opens them all.
  List<Widget> _rosterRows() {
    final rows = sortBotRoster(_visibleRoster);
    if (_sections.isEmpty) return [for (final bot in rows) _botCard(bot)];
    final searching = _search.isNotEmpty;
    final l10n = context.sharedL10n;
    return [
      for (final block in groupBotsBySection(rows, _sections))
        // An empty Unassigned is not worth a heading; an empty section is
        // somewhere the user made.
        if (block.rows.isNotEmpty || block.id != null) ...[
          _sectionHeader(block, searching),
          if (searching || !_collapsed.contains(block.key))
            if (block.rows.isEmpty)
              Padding(
                key: Key('bots-section-empty-${block.id}'),
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                child: Text(
                  l10n.ng_bots_section_empty,
                  style: TextStyle(color: HermesTokens.of(context).muted),
                ),
              )
            else
              for (final bot in block.rows) _botCard(bot),
        ],
    ];
  }

  Widget _sectionHeader(BotSectionBlock block, bool searching) {
    final l10n = context.sharedL10n;
    final id = block.id;
    final name = id == null ? l10n.ng_bots_section_unassigned : block.name;
    final collapsed = !searching && _collapsed.contains(block.key);
    final order = _sections.indexWhere((s) => s.id == id);
    return Semantics(
      button: true,
      expanded: !collapsed,
      label: l10n.ng_bots_section_toggle(name),
      child: InkWell(
        key: Key('bots-section-${id ?? 'unassigned'}'),
        borderRadius: BorderRadius.circular(8),
        onTap: searching
            ? null
            : () => setState(() {
                if (!_collapsed.remove(block.key)) _collapsed.add(block.key);
              }),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(collapsed ? Icons.chevron_right : Icons.expand_more),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                '${block.rows.length}',
                style: TextStyle(color: HermesTokens.of(context).muted),
              ),
              if (id != null)
                PopupMenuButton<String>(
                  key: Key('bots-section-menu-$id'),
                  tooltip: l10n.ng_bots_section_options(name),
                  onSelected: (action) {
                    final section = _sections.firstWhere((s) => s.id == id);
                    switch (action) {
                      case 'rename':
                        unawaited(_renameSection(section));
                      case 'up':
                        _moveSection(id, -1);
                      case 'down':
                        _moveSection(id, 1);
                      case 'delete':
                        unawaited(_deleteSection(section));
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      key: const Key('bots-section-rename'),
                      value: 'rename',
                      child: Text(l10n.ng_bots_section_rename),
                    ),
                    PopupMenuItem(
                      key: const Key('bots-section-up'),
                      value: 'up',
                      enabled: order > 0,
                      child: Text(l10n.ng_bots_section_move_up),
                    ),
                    PopupMenuItem(
                      key: const Key('bots-section-down'),
                      value: 'down',
                      enabled: order >= 0 && order < _sections.length - 1,
                      child: Text(l10n.ng_bots_section_move_down),
                    ),
                    PopupMenuItem(
                      key: const Key('bots-section-delete'),
                      value: 'delete',
                      child: Text(l10n.ng_bots_section_delete),
                    ),
                  ],
                )
              else
                const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botCard(BotRosterProfile bot) {
    final l10n = context.sharedL10n;
    return Card(
      key: Key('bots-row-${bot.name}'),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _face(bot, 40),
        title: Text(
          bot.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          [
            bot.model.isNotEmpty ? bot.model : l10n.ng_bots_no_model,
            if (bot.provider.isNotEmpty) bot.provider,
            l10n.ng_bots_skill_count(bot.skillCount),
            if (bot.canonicalSessionId != null) l10n.ng_bots_bot_chat,
          ].join(' · '),
        ),
        trailing: PopupMenuButton<String>(
          key: Key('bots-row-menu-${bot.name}'),
          tooltip: l10n.ng_bots_bot_actions(bot.title),
          onSelected: (action) => switch (action) {
            'edit' => _openEditProfile(bot),
            _ => unawaited(_openMoveTo(bot)),
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              key: const Key('bots-row-edit'),
              value: 'edit',
              child: Text(l10n.ng_bots_edit_profile),
            ),
            PopupMenuItem(
              key: const Key('bots-row-move'),
              value: 'move',
              child: Text(l10n.ng_bots_section_move_to),
            ),
          ],
        ),
        onTap: () => _openRosterDetail(bot),
      ),
    );
  }

  void _openRosterDetail(BotRosterProfile bot) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _RosterDetailSheet(
        bot: bot,
        face: _face(bot, 44),
        onEditProfile: () {
          Navigator.of(sheetContext).pop();
          _openEditProfile(bot);
        },
        onOpenChat: () {
          Navigator.of(sheetContext).pop();
          _openCanonicalChat(bot);
        },
        onOpenRoutines: () {
          Navigator.of(sheetContext).pop();
          setState(() {
            _routinesProfile = bot.name;
            _tab = _BotsTab.routines;
          });
          final target = _target;
          if (target != null) unawaited(_loadRoutines(target));
        },
        onOpenScreen: () {
          Navigator.of(sheetContext).pop();
          setState(() {
            _screenProfile = bot.name;
            _tab = _BotsTab.screen;
          });
          final target = _target;
          if (target != null) unawaited(_loadScreen(target));
        },
      ),
    );
  }

  // ── Rooms ─────────────────────────────────────────────────────────────

  Widget _roomsView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_roomsCaps != null) _roomsStatusCard(_roomsCaps!),
        _roomsCreateRow(),
        const SizedBox(height: 12),
        if (_roomsLoading)
          const Center(child: CircularProgressIndicator())
        else if (_rooms.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: Center(child: Text(context.sharedL10n.ng_bots_no_rooms)),
          ),
        for (final room in _rooms)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                room.disbanded ? Icons.block : Icons.groups_outlined,
              ),
              title: Text(room.name),
              subtitle: Text(
                [
                  context.sharedL10n.ng_bots_member_count(room.members.length),
                  if (room.disbanded) context.sharedL10n.ng_bots_room_disbanded,
                  if (room.adopted) context.sharedL10n.ng_bots_room_adopted,
                ].join(' · '),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openRoom(room),
            ),
          ),
      ],
    );
  }

  Widget _roomsStatusCard(RoomCapabilities caps) {
    final driver = caps.driver;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(driver ? Icons.hub : Icons.desktop_windows_outlined),
        title: Text(
          driver
              ? context.sharedL10n.ng_bots_rooms_gateway
              : context.sharedL10n.ng_bots_rooms_desktop,
        ),
        subtitle: Text(
          driver
              ? context.sharedL10n.ng_bots_rooms_gateway_body(
                  caps.methods.join(', '),
                )
              : (caps.persistentProcess
                    ? context.sharedL10n.ng_bots_rooms_no_seat
                    : context.sharedL10n.ng_bots_rooms_fallback),
        ),
        trailing: Text(
          'v${caps.protocolVersion}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _roomsCreateRow() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _roster.isEmpty ? null : () => _openCreateRoomSheet(),
            child: Text(context.sharedL10n.ng_bots_create_room),
          ),
        ),
        IconButton(
          tooltip: context.sharedL10n.ng_bots_refresh_rooms,
          icon: const Icon(Icons.refresh),
          onPressed: () {
            final target = _target;
            if (target != null) unawaited(_loadRooms(target));
          },
        ),
      ],
    );
  }

  void _openCreateRoomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _CreateRoomSheet(
        roster: _roster,
        onCreate: (name, roomId, members) async {
          final l10n = context.sharedL10n;
          Navigator.of(sheetContext).pop();
          final target = _target;
          if (target == null) return;
          setState(() {
            _roomsLoading = true;
          });
          try {
            await target.roomCreate(
              roomId: roomId,
              name: name,
              members: members,
            );
            if (!_owns(target)) return;
            _toast(l10n.ng_bots_room_created);
            await _loadRooms(target);
          } on WorkspaceException catch (e) {
            if (!_owns(target)) return;
            setState(() => _roomsLoading = false);
            _toast(l10n.ng_bots_room_refused(e.reason.name));
          } catch (e) {
            if (!_owns(target)) return;
            setState(() => _roomsLoading = false);
            _toast(l10n.ng_bots_room_failed('$e'));
          }
        },
      ),
    );
  }

  void _openRoom(RoomSummary room) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BotRoomScreen(
          owner: widget.owner,
          route: widget.route,
          connection: widget.connection,
          room: room,
        ),
      ),
    );
  }

  // ── Screen (Bot Desktop) ────────────────────────────────────────────────

  Widget _screenView(bool isNarrow) {
    final profiles = _roster.map((p) => p.name).toList();
    final selected = _screenProfile;
    final status = _display;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: profiles.contains(selected) ? selected : null,
          items: [
            for (final n in profiles)
              DropdownMenuItem(
                value: n,
                child: Text(n, overflow: TextOverflow.ellipsis),
              ),
          ],
          decoration: InputDecoration(
            labelText: context.sharedL10n.ng_bots_bot,
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (n) {
            if (n == null || n == _screenProfile) return;
            _cancelThumbnail();
            setState(() {
              _screenProfile = n;
              _display = null;
              _thumbnail = null;
              _showThumbnail(null);
              _thumbnailSuppressed = false;
            });
            final target = _target;
            if (target != null) unawaited(_loadScreen(target));
          },
        ),
        const SizedBox(height: 12),
        if (status == null && !_screenBusy)
          Card(
            child: ListTile(
              title: Text(context.sharedL10n.ng_bots_screen_unavailable),
              subtitle: Text(
                context.sharedL10n.ng_bots_screen_unavailable_body,
              ),
            ),
          ),
        if (status != null) _displayCard(status),
        if (_install case final install? when install.bot == selected)
          _installCard(install),
        if (status != null) _screenControls(status),
        if (status?.running == true) _thumbnailCard(),
        const SizedBox(height: 12),
        Text(
          context.sharedL10n.ng_bots_take_over_note,
          style: TextStyle(fontSize: 12, color: HermesTokens.of(context).muted),
        ),
      ],
    );
  }

  Widget _displayCard(DisplayStatus status) {
    final unsupported = !status.supported;
    final installed = status.installed;
    final blocked = status.blocker;
    final imageSwitch = status.imageSwitch;
    return Card(
      child: ListTile(
        leading: Icon(
          unsupported
              ? Icons.block_outlined
              : installed
              ? (status.running
                    ? Icons.desktop_windows
                    : Icons.desktop_windows_outlined)
              : Icons.download_outlined,
        ),
        title: Text(
          !unsupported
              ? installed
                    ? status.running
                          ? context.sharedL10n.ng_running
                          : context.sharedL10n.ng_stopped
                    : context.sharedL10n.ng_bots_not_installed
              : context.sharedL10n.ng_bots_unsupported_host,
        ),
        subtitle: Text(
          [
            if (installed)
              '${status.geometry} · ${_displayPlacementLabel(context.sharedL10n, status.placement)}',
            if (status.pid != null)
              context.sharedL10n.ng_bots_pid('${status.pid}'),
            if (status.missing.isNotEmpty)
              context.sharedL10n.ng_bots_missing(status.missing.join(', ')),
            if (blocked != null) context.sharedL10n.ng_bots_blocked(blocked),
            if (!unsupported && !installed && status.missing.isEmpty)
              context.sharedL10n.ng_bots_no_switch,
            if (imageSwitch != null)
              context.sharedL10n.ng_bots_switch_image(
                '${imageSwitch['current_image'] ?? '?'}',
                '${imageSwitch['target_image'] ?? '?'}',
              ),
            if (status.running)
              status.lease.isAgent
                  ? context.sharedL10n.ng_bots_bot_in_control
                  : context.sharedL10n.ng_bots_person_in_control,
          ].join(' · '),
        ),
      ),
    );
  }

  Widget _installCard(_BotInstall install) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      key: const Key('bots-install-card'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              install.running
                  ? context.sharedL10n.ng_bots_installing
                  : context.sharedL10n.ng_bots_install_unfinished,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (install.running)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(),
              ),
            if (install.lines.isNotEmpty)
              Container(
                key: const Key('bots-install-log'),
                margin: const EdgeInsets.only(top: 8),
                constraints: const BoxConstraints(maxHeight: 180),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  child: SelectableText(
                    install.lines.join('\n'),
                    style: const TextStyle(
                      fontFamily: 'GeistMono',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            if (install.error case final error?)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  error,
                  key: const Key('bots-install-error'),
                  style: TextStyle(color: scheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _screenControls(DisplayStatus status) {
    final unsupported = !status.supported;
    final installed = status.installed;
    final running = status.running;
    final humanHeld = !status.lease.isAgent;
    final installing = _install?.running == true;
    final imageSwitchPending = status.imageSwitch != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (!unsupported && !installed)
              OutlinedButton.icon(
                onPressed: _screenBusy || installing ? null : _startInstalling,
                icon: const Icon(Icons.download_outlined),
                label: Text(context.sharedL10n.ng_bots_install),
              ),
            if (!unsupported && installed && !running)
              FilledButton.icon(
                onPressed: _screenBusy ? null : _startScreen,
                icon: const Icon(Icons.play_arrow_outlined),
                label: Text(context.sharedL10n.ng_bots_start),
              ),
            if (!unsupported && installed && running)
              FilledButton.icon(
                onPressed: _screenBusy ? null : () => _stopScreen(),
                icon: const Icon(Icons.stop_circle_outlined),
                label: Text(context.sharedL10n.ng_stop),
              ),
            if (!unsupported && installed && running)
              OutlinedButton.icon(
                key: const Key('bots-take-over'),
                onPressed: _screenBusy || _session != null
                    ? null
                    : _takeOverScreen,
                icon: const Icon(Icons.visibility_outlined),
                label: Text(context.sharedL10n.ng_bots_take_over),
              ),
            if (!unsupported && running && humanHeld && _session == null)
              OutlinedButton.icon(
                key: const Key('bots-force-hand-back'),
                onPressed: _screenBusy ? null : _forceHandBack,
                icon: const Icon(Icons.visibility_off_outlined),
                label: Text(context.sharedL10n.ng_bots_hand_back),
              ),
            if (imageSwitchPending && !_screenBusy) ...[
              FilledButton.icon(
                onPressed: _screenBusy ? null : _switchSandboxImage,
                icon: const Icon(Icons.sync_alt_outlined),
                label: Text(context.sharedL10n.ng_bots_adopt_image),
              ),
              OutlinedButton.icon(
                onPressed: _screenBusy ? null : _keepCurrentImage,
                icon: const Icon(Icons.close),
                label: Text(context.sharedL10n.ng_bots_keep_image),
              ),
            ],
            if (status.missing.isNotEmpty && !unsupported)
              Tooltip(
                message: context.sharedL10n.ng_bots_missing_pieces(
                  status.missing.join(', '),
                ),
                child: TextButton(
                  onPressed: _screenBusy || installing
                      ? null
                      : _startInstalling,
                  child: Text(context.sharedL10n.ng_bots_install_missing),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailCard() {
    final thumbnail = _thumbnail;
    final scheme = Theme.of(context).colorScheme;
    final unavailable = Container(
      height: 96,
      width: double.infinity,
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Text(
        context.sharedL10n.ng_bots_thumbnail_unavailable,
        style: TextStyle(color: scheme.onSurfaceVariant),
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.sharedL10n.ng_bots_thumbnail_title,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (_thumbnailImage case final image?)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 360),
                  // The last frame stays up while the next one decodes.
                  child: Image(
                    key: const Key('bots-thumbnail-image'),
                    image: image,
                    gaplessPlayback: true,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => unavailable,
                  ),
                ),
              )
            else if (thumbnail?.dataUrl != null)
              unavailable
            else if (_thumbnailSuppressed)
              Text(context.sharedL10n.ng_bots_thumbnail_suppressed)
            else
              Text(context.sharedL10n.ng_bots_thumbnail_pending),
          ],
        ),
      ),
    );
  }

  // ── Routines ───────────────────────────────────────────────────────────

  Widget _routinesView(bool isNarrow) {
    final profiles = _roster.map((p) => p.name).toList();
    final selected = _routinesProfile;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          isExpanded: true,
          initialValue: profiles.contains(selected) ? selected : null,
          items: [
            for (final n in profiles)
              DropdownMenuItem(
                value: n,
                child: Text(n, overflow: TextOverflow.ellipsis),
              ),
          ],
          decoration: InputDecoration(
            labelText: context.sharedL10n.ng_bots_bot,
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (n) {
            if (n == null || n == _routinesProfile) return;
            setState(() {
              _routinesProfile = n;
              _routines = const [];
              _routinesScope = null;
              _routinesLoading = false;
            });
            final target = _target;
            if (target != null) unawaited(_loadRoutines(target));
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Text(
                _routinesScope ??
                    context.sharedL10n.ng_bots_routines_of(selected ?? '—'),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            IconButton(
              tooltip: context.sharedL10n.refresh,
              icon: const Icon(Icons.refresh),
              onPressed: () {
                final target = _target;
                if (target != null) unawaited(_loadRoutines(target));
              },
            ),
            IconButton(
              tooltip: context.sharedL10n.ng_bots_add_routine,
              icon: const Icon(Icons.add_circle_outline),
              onPressed: _routinesLoading ? null : () => _openRoutineDialog(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_routinesLoading)
          const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_routines.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: Center(child: Text(context.sharedL10n.ng_bots_no_routines)),
          ),
        for (final job in _routines) _routineTile(job),
        const SizedBox(height: 16),
        Text(
          context.sharedL10n.ng_bots_routines_note,
          style: TextStyle(fontSize: 12, color: HermesTokens.of(context).muted),
        ),
      ],
    );
  }

  Widget _routineTile(RoutineJob job) {
    final tagged = RoutineJob.splitTags(job.name);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          job.enabled ? Icons.schedule : Icons.pause_circle_outline,
        ),
        title: Text(
          tagged.title.isNotEmpty ? tagged.title : job.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          [
            job.schedule,
            if (job.enabled)
              context.sharedL10n.ng_bots_routine_enabled
            else
              context.sharedL10n.ng_bots_routine_paused,
            ?job.repeat,
            if (job.state.isNotEmpty) job.state,
            if (job.lastStatus.isNotEmpty)
              context.sharedL10n.ng_bots_routine_last(job.lastStatus),
            if (job.nextRunAt != null)
              context.sharedL10n.ng_bots_routine_next(job.nextRunAt!),
            if (job.lastError != null && job.lastError!.isNotEmpty)
              context.sharedL10n.ng_bots_routine_error(job.lastError!),
          ].where((s) => s.isNotEmpty).join(' · '),
        ),
        trailing: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            if (!job.enabled)
              IconButton(
                tooltip: context.sharedL10n.ng_resume,
                icon: const Icon(Icons.play_arrow_outlined),
                onPressed: () => _routineAction('resume', job),
              )
            else
              IconButton(
                tooltip: context.sharedL10n.ng_pause,
                icon: const Icon(Icons.pause_outlined),
                onPressed: () => _routineAction('pause', job),
              ),
            IconButton(
              tooltip: context.sharedL10n.ng_remove,
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _routineAction('remove', job),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _routineAction(String action, RoutineJob job) async {
    final l10n = context.sharedL10n;
    final target = _target;
    final profile = _routinesProfile;
    if (target == null || profile == null) return;
    if (action == 'remove') {
      final title = RoutineJob.splitTags(job.name).title;
      final confirmed = await _confirm(
        title: l10n.ng_bots_remove_routine_title(
          title.isEmpty ? job.name : title,
        ),
        message: l10n.ng_bots_remove_routine_body(profile),
        confirmLabel: l10n.ng_remove,
      );
      if (!confirmed || !_ownsRoutines(target, profile)) return;
    }
    setState(() => _routinesLoading = true);
    try {
      switch (action) {
        case 'pause':
          await target.botRoutinePause(profile, job.jobId);
        case 'resume':
          await target.botRoutineResume(profile, job.jobId);
        case 'remove':
          await target.botRoutineRemove(profile, job.jobId);
      }
      if (!_ownsRoutines(target, profile)) return;
      await _loadRoutines(target);
    } catch (e) {
      if (_ownsRoutines(target, profile)) {
        setState(() => _routinesLoading = false);
        final verb = switch (action) {
          'pause' => l10n.ng_pause,
          'resume' => l10n.ng_resume,
          _ => l10n.ng_remove,
        };
        _toast(l10n.ng_bots_routine_action_failed(verb, '$e'));
      }
    }
  }

  void _openRoutineDialog() {
    final profile = _routinesProfile;
    if (profile == null) return;
    showDialog<void>(
      context: context,
      builder: (context) => _RoutineDialog(
        onAdd: (draft) async {
          final l10n = context.sharedL10n;
          final target = _target;
          if (target == null) return l10n.ng_bots_not_connected;
          try {
            await target.botRoutineAdd(
              profile: profile,
              title: draft.title,
              schedule: draft.schedule,
              instruction: draft.instruction,
              repeat: draft.repeat,
              continuity: draft.continuity,
              deliverToBotChat: draft.deliverToBotChat,
            );
          } on WorkspaceException catch (e) {
            return l10n.ng_bots_add_failed(e.reason.name);
          } catch (e) {
            return l10n.ng_bots_add_failed('$e');
          }
          if (!_ownsRoutines(target, profile)) return null;
          _toast(l10n.ng_bots_routine_added);
          unawaited(_loadRoutines(target));
          return null;
        },
      ),
    );
  }
}

String _displayPlacementLabel(AppLocalizations l10n, String placement) =>
    switch (placement) {
      'gateway' => l10n.ng_gateway_2,
      _ => placement,
    };

extension on DisplayStatus {
  DisplayStatus copyWith({DisplayLease? lease}) => DisplayStatus(
    profile: profile,
    supported: supported,
    installed: installed,
    missing: missing,
    running: running,
    pid: pid,
    geometry: geometry,
    placement: placement,
    blocker: blocker,
    memoryAvailableMb: memoryAvailableMb,
    memoryLimitMb: memoryLimitMb,
    imageSwitch: imageSwitch,
    lease: lease ?? this.lease,
    profileKey: profileKey,
  );
}

/// The one section-name dialog (New section and Rename). It owns its
/// controller, so the field outlives the closing animation.
class _SectionNameDialog extends StatefulWidget {
  const _SectionNameDialog({
    required this.title,
    required this.ok,
    required this.initial,
  });

  final String title;
  final String ok;
  final String initial;

  @override
  State<_SectionNameDialog> createState() => _SectionNameDialogState();
}

class _SectionNameDialogState extends State<_SectionNameDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    return AlertDialog(
      key: const Key('bots-section-dialog'),
      scrollable: true,
      title: Text(widget.title),
      content: TextField(
        key: const Key('bots-section-name'),
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.ng_bots_section_name,
          hintText: l10n.ng_bots_section_name_hint,
        ),
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          key: const Key('bots-section-cancel'),
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('bots-section-ok'),
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text(widget.ok),
        ),
      ],
    );
  }
}

class _RosterDetailSheet extends StatelessWidget {
  const _RosterDetailSheet({
    required this.bot,
    required this.face,
    required this.onEditProfile,
    required this.onOpenChat,
    required this.onOpenRoutines,
    required this.onOpenScreen,
  });

  final BotRosterProfile bot;
  final Widget face;
  final VoidCallback onEditProfile;
  final VoidCallback onOpenChat;
  final VoidCallback onOpenRoutines;
  final VoidCallback onOpenScreen;

  @override
  Widget build(BuildContext context) {
    // Scrolls: at 2.0x text the sheet is taller than a phone.
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                face,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bot.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '@${bot.handle} · ${bot.model.isNotEmpty ? bot.model : context.sharedL10n.ng_bots_no_model}'
                        '${bot.provider.isNotEmpty ? ' · ${bot.provider}' : ''}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: context.sharedL10n.close,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (bot.description.isNotEmpty)
              Text(
                bot.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            if (bot.description.isNotEmpty) const SizedBox(height: 8),
            Text(
              '${context.sharedL10n.ng_bots_path(bot.path)} · ${context.sharedL10n.ng_bots_skill_count(bot.skillCount)}'
              ' · ${bot.canonicalSessionId != null ? context.sharedL10n.ng_bots_chat_present : context.sharedL10n.ng_bots_chat_missing}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (bot.lastSessionPreview != null) ...[
              const SizedBox(height: 8),
              Text(
                context.sharedL10n.ng_bots_last_session(
                  bot.lastSessionPreview!,
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: Text(context.sharedL10n.ng_bots_open_chat),
                    onPressed: onOpenChat,
                  ),
                  OutlinedButton.icon(
                    key: const Key('bots-edit-profile'),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(context.sharedL10n.ng_bots_edit_profile),
                    onPressed: onEditProfile,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.schedule_outlined),
                    label: Text(context.sharedL10n.ng_bots_tab_routines),
                    onPressed: onOpenRoutines,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.desktop_windows_outlined),
                    label: Text(context.sharedL10n.ng_bots_desktop),
                    onPressed: onOpenScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateRoomSheet extends StatefulWidget {
  const _CreateRoomSheet({required this.roster, required this.onCreate});

  final List<BotRosterProfile> roster;
  final Future<void> Function(
    String name,
    String roomId,
    List<RoomMember> members,
  )
  onCreate;

  @override
  State<_CreateRoomSheet> createState() => _CreateRoomSheetState();
}

class _CreateRoomSheetState extends State<_CreateRoomSheet> {
  final _nameInput = TextEditingController();
  final Set<String> _selected = {};
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _nameInput.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _nameInput.removeListener(_onNameChanged);
    _nameInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final members = [
      for (final p in widget.roster)
        if (_selected.contains(p.name))
          RoomMember(
            memberId: p.name,
            profile: p.name,
            handle: p.handle,
            displayName: p.displayName.isNotEmpty ? p.displayName : '',
          ),
    ];
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).padding.bottom + 20,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 480),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.sharedL10n.ng_bots_create_room,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: context.sharedL10n.close,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameInput,
                  decoration: InputDecoration(
                    labelText: context.sharedL10n.ng_bots_room_name,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final bot in widget.roster)
                      FilterChip(
                        label: Text(bot.title),
                        selected: _selected.contains(bot.name),
                        onSelected: (v) {
                          setState(() {
                            if (v) {
                              _selected.add(bot.name);
                            } else {
                              _selected.remove(bot.name);
                            }
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (members.isEmpty)
                  Text(
                    context.sharedL10n.ng_bots_select_member,
                    style: TextStyle(color: HermesTokens.of(context).muted),
                  ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed:
                      _busy || _nameInput.text.trim().isEmpty || members.isEmpty
                      ? null
                      : () async {
                          setState(() => _busy = true);
                          final roomId =
                              'room-${_nameInput.text.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_-]+'), '-')}';
                          await widget.onCreate(
                            _nameInput.text.trim(),
                            roomId,
                            members,
                          );
                          if (mounted) setState(() => _busy = false);
                        },
                  child: _busy
                      ? const CircularProgressIndicator()
                      : Text(context.sharedL10n.ng_bots_create_room),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One package install on a bot's gateway host, as far as this screen has
/// followed it.
class _BotInstall {
  _BotInstall(this.bot);

  /// Output lines kept on screen.
  static const keep = 200;

  final String bot;
  final lines = <String>[];
  bool running = true;
  String? error;
}

/// Asks for the sudo password of a Bot Desktop install. Pops with the text
/// (null on Cancel) and clears its own copy; nothing else keeps it.
class _SudoPasswordDialog extends StatefulWidget {
  const _SudoPasswordDialog({required this.bot});
  final String bot;

  @override
  State<_SudoPasswordDialog> createState() => _SudoPasswordDialogState();
}

class _SudoPasswordDialogState extends State<_SudoPasswordDialog> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password
      ..clear()
      ..dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_password.text);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key('bots-sudo-dialog'),
      scrollable: true,
      title: Text(context.sharedL10n.ng_bots_sudo_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.sharedL10n.ng_bots_sudo_body(widget.bot)),
          const SizedBox(height: 12),
          TextField(
            key: const Key('bots-sudo-password'),
            controller: _password,
            autofocus: true,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.visiblePassword,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: context.sharedL10n.ng_bots_sudo_password,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const Key('bots-sudo-cancel'),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.sharedL10n.cancel),
        ),
        FilledButton(
          key: const Key('bots-sudo-submit'),
          onPressed: _submit,
          child: Text(context.sharedL10n.ng_continue),
        ),
      ],
    );
  }
}

/// What the New routine form sends: `cron.manage add` for one bot.
class _RoutineDraft {
  const _RoutineDraft({
    required this.title,
    required this.instruction,
    required this.schedule,
    required this.repeat,
    required this.continuity,
    required this.deliverToBotChat,
  });

  final String title;
  final String instruction;

  /// A Hermes schedule: a cron expression or `every <n><m|h|d>`.
  final String schedule;

  /// Run count after which the routine stops; null keeps it running.
  final int? repeat;
  final bool continuity;
  final bool deliverToBotChat;
}

enum _RoutineScheduleKind { cron, interval }

class _RoutineDialog extends StatefulWidget {
  const _RoutineDialog({required this.onAdd});

  /// Creates the routine; returns the error to show, or null on success.
  final Future<String?> Function(_RoutineDraft draft) onAdd;

  @override
  State<_RoutineDialog> createState() => _RoutineDialogState();
}

class _RoutineDialogState extends State<_RoutineDialog> {
  final _titleInput = TextEditingController();
  final _instructionInput = TextEditingController();
  final _cronInput = TextEditingController(text: '0 9 * * *');
  final _intervalInput = TextEditingController(text: '1');
  // Blank on purpose: 'Repeat' is a run COUNT on the gateway, so a default
  // of 1 would retire a daily routine after its first run.
  final _repeatInput = TextEditingController();
  _RoutineScheduleKind _kind = _RoutineScheduleKind.cron;
  String _intervalUnit = 'h';
  bool _continuity = false;
  bool _deliverToBotChat = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // The Add button follows what is typed.
    for (final input in _inputs) {
      input.addListener(_onInput);
    }
  }

  List<TextEditingController> get _inputs => [
    _titleInput,
    _instructionInput,
    _cronInput,
    _intervalInput,
    _repeatInput,
  ];

  void _onInput() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final input in _inputs) {
      input.dispose();
    }
    super.dispose();
  }

  String get _schedule {
    if (_kind == _RoutineScheduleKind.cron) return _cronInput.text.trim();
    final every = int.tryParse(_intervalInput.text.trim()) ?? 0;
    return every < 1 ? '' : 'every $every$_intervalUnit';
  }

  bool get _canAdd =>
      !_busy &&
      _titleInput.text.trim().isNotEmpty &&
      _instructionInput.text.trim().isNotEmpty &&
      _schedule.isNotEmpty;

  Future<void> _submit() async {
    if (!_canAdd) return;
    final limit = int.tryParse(_repeatInput.text.trim());
    final draft = _RoutineDraft(
      title: _titleInput.text.trim(),
      instruction: _instructionInput.text.trim(),
      schedule: _schedule,
      repeat: limit != null && limit > 0 ? limit : null,
      continuity: _continuity,
      deliverToBotChat: _deliverToBotChat,
    );
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await widget.onAdd(draft);
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _busy = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 12);
    final digits = [FilteringTextInputFormatter.digitsOnly];
    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      title: Text(context.sharedL10n.ng_bots_new_routine),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('bots-routine-title'),
            controller: _titleInput,
            decoration: InputDecoration(
              labelText: context.sharedL10n.ng_bots_routine_title,
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          gap,
          TextField(
            key: const Key('bots-routine-instruction'),
            controller: _instructionInput,
            minLines: 2,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: context.sharedL10n.ng_bots_routine_instruction,
              border: OutlineInputBorder(),
            ),
          ),
          gap,
          DropdownButtonFormField<_RoutineScheduleKind>(
            key: Key('bots-routine-schedule-kind'),
            isExpanded: true,
            initialValue: _kind,
            decoration: InputDecoration(
              labelText: context.sharedL10n.ng_schedule,
              border: OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: _RoutineScheduleKind.cron,
                child: Text(
                  context.sharedL10n.ng_bots_cron,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: _RoutineScheduleKind.interval,
                child: Text(
                  context.sharedL10n.ng_bots_interval,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            onChanged: _busy
                ? null
                : (kind) => setState(() => _kind = kind ?? _kind),
          ),
          gap,
          if (_kind == _RoutineScheduleKind.cron)
            TextField(
              key: const Key('bots-routine-cron'),
              controller: _cronInput,
              decoration: InputDecoration(
                labelText: context.sharedL10n.ng_bots_cron,
                helperText: context.sharedL10n.ng_bots_cron_help,
                helperMaxLines: 3,
                border: OutlineInputBorder(),
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('bots-routine-interval'),
                    controller: _intervalInput,
                    keyboardType: TextInputType.number,
                    inputFormatters: digits,
                    decoration: InputDecoration(
                      labelText: context.sharedL10n.ng_bots_every,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    key: Key('bots-routine-interval-unit'),
                    isExpanded: true,
                    initialValue: _intervalUnit,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    items: [
                      DropdownMenuItem(
                        value: 'm',
                        child: Text(
                          context.sharedL10n.ng_bots_unit_minutes,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'h',
                        child: Text(
                          context.sharedL10n.ng_bots_unit_hours,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'd',
                        child: Text(
                          context.sharedL10n.ng_bots_unit_days,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    onChanged: _busy
                        ? null
                        : (unit) => setState(() => _intervalUnit = unit ?? 'h'),
                  ),
                ),
              ],
            ),
          gap,
          TextField(
            key: const Key('bots-routine-repeat'),
            controller: _repeatInput,
            keyboardType: TextInputType.number,
            inputFormatters: digits,
            decoration: InputDecoration(
              labelText: context.sharedL10n.ng_bots_stop_after,
              hintText: '∞',
              helperText: context.sharedL10n.ng_bots_stop_after_help,
              helperMaxLines: 3,
              border: OutlineInputBorder(),
            ),
          ),
          gap,
          DropdownButtonFormField<bool>(
            key: Key('bots-routine-deliver'),
            isExpanded: true,
            initialValue: _deliverToBotChat,
            decoration: InputDecoration(
              labelText: context.sharedL10n.ng_bots_send_results,
              border: OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: false,
                child: Text(
                  context.sharedL10n.ng_bots_run_history,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: true,
                child: Text(
                  context.sharedL10n.ng_bots_bot_chat,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            onChanged: _busy
                ? null
                : (value) => setState(() => _deliverToBotChat = value ?? false),
          ),
          CheckboxListTile(
            key: const Key('bots-routine-continuity'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(context.sharedL10n.ng_bots_continuity),
            value: _continuity,
            onChanged: _busy
                ? null
                : (value) => setState(() => _continuity = value ?? false),
          ),
          if (_error case final error?)
            Text(
              error,
              key: const Key('bots-routine-error'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: Text(context.sharedL10n.cancel),
        ),
        FilledButton(
          key: const Key('bots-routine-add'),
          onPressed: _canAdd ? _submit : null,
          child: _busy
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.sharedL10n.add),
        ),
      ],
    );
  }
}

/// Pushed page hosting a bot's canonical Bot Chat, on the bot's own profile.
///
/// Each layout shows it with its own chat: inside NextGen (an [NgScope] is
/// above) the NextGen chat view, on a gateway and scope of its own for the
/// bot's profile; in Classic the Classic chat screen on [chatConnection].
/// Classic Bot Chat: a chat on the bot's own connection. /resume opens the
/// pick in place of it, on that same connection, as the session list does.
Widget _botClassicChat(SavedConnection connection, Session session) => Builder(
  builder: (context) => ChatScreen(
    connection: connection,
    session: session,
    singleSession: true,
    onOpenSession: (picked) async {
      if (!context.mounted) return;
      unawaited(
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => _botClassicChat(connection, picked),
          ),
        ),
      );
    },
    onClose: () => Navigator.of(context).maybePop(),
  ),
);

class BotChatPage extends StatefulWidget {
  const BotChatPage({
    super.key,
    required this.connection,
    required this.storedId,
    required this.title,
    required this.profile,
    this.gatewayFactory,
    this.classicChatBuilder,
  });

  /// The connection the roster was read on.
  final SavedConnection connection;
  final String storedId;
  final String title;

  /// The bot: the profile that owns [storedId].
  final String profile;

  /// Builds the NextGen chat's gateway. Tests record what it is given.
  @visibleForTesting
  final NextGenGateway Function(SavedConnection connection)? gatewayFactory;

  /// Builds the Classic chat. Tests record what it is given.
  @visibleForTesting
  final Widget Function(SavedConnection connection, Session session)?
  classicChatBuilder;

  /// The same gateway and account, on the bot's own profile. A bot's chat is
  /// a session in the bot's profile: read, resumed and sent to there, as
  /// Desktop opens it (`requestForBot`), not on whatever profile the saved
  /// connection selects. An unsaved copy; the saved connection is untouched.
  SavedConnection get chatConnection => profile.trim().isEmpty
      ? connection
      : connection.copyWith(gatewayProfile: profile.trim());

  @override
  State<BotChatPage> createState() => _BotChatPageState();
}

class _BotChatPageState extends State<BotChatPage> {
  NextGenGateway? _gateway;
  NgChatController? _chat;
  NgScope? _nextGen;
  bool _resolved = false;
  bool _loading = true;
  String? _failure;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_resolved) return;
    _resolved = true;
    // Read once: which layout this page was pushed from does not change.
    _nextGen = context.getInheritedWidgetOfExactType<NgScope>();
    if (_nextGen != null) unawaited(_start());
  }

  Future<void> _start() async {
    try {
      final gateway = (widget.gatewayFactory ?? NextGenGateway.new)(
        widget.chatConnection,
      );
      _gateway = gateway;
      final chat = NgChatController(
        gateway,
        sessionId: widget.storedId,
        title: widget.title,
      );
      _chat = chat;
      await chat.open();
      if (!mounted) return;
      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failure = '$e';
      });
    }
  }

  @override
  void dispose() {
    _chat?.dispose();
    _gateway?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextGen = _nextGen;
    if (nextGen == null) {
      final session = Session(
        id: widget.storedId,
        title: widget.title,
        model: '',
        source: 'desktop',
        messageCount: 0,
        hasKnownMessageCount: false,
        isActive: false,
        preview: '',
        startedAt: 0,
      );
      final build = widget.classicChatBuilder;
      if (build != null) return build(widget.chatConnection, session);
      return _botClassicChat(widget.chatConnection, session);
    }
    final chat = _chat;
    final gateway = _gateway;
    return Scaffold(
      appBar: AppBar(title: Text('${widget.title} · ${widget.profile}')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _failure != null || chat == null || gateway == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  context.sharedL10n.ng_bots_chat_open_failed('$_failure'),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          // The chat view reads its gateway from the scope: give it the
          // bot's, so nothing in it reaches the connection's own profile.
          : NgScope(
              connManager: nextGen.connManager,
              gateway: gateway,
              connections: nextGen.connections,
              switchTo: nextGen.switchTo,
              addGateway: nextGen.addGateway,
              signOut: nextGen.signOut,
              reload: nextGen.reload,
              signInAgain: nextGen.signInAgain,
              child: NgChatView(key: ObjectKey(chat), chat: chat),
            ),
    );
  }
}

/// Full-page room view: members, driver status, send form, history.
class BotRoomScreen extends StatefulWidget {
  const BotRoomScreen({
    super.key,
    required this.owner,
    required this.route,
    required this.connection,
    required this.room,
  });

  final RemoteWorkspaceOwner owner;
  final WorkspaceRoute route;
  final SavedConnection connection;
  final RoomSummary room;

  @override
  State<BotRoomScreen> createState() => _BotRoomScreenState();
}

class _BotRoomScreenState extends State<BotRoomScreen> {
  WorkspacePane? _pane;
  WorkspaceTarget? _target;
  Object? _account;

  RoomSummary _room = RoomSummary(roomId: '', name: '');
  RoomDriverStatus? _driver;
  RoomContext? _context;
  List<RoomLogEvent> _log = const [];
  bool _loading = true;
  String? _error;

  final _messageInput = TextEditingController();
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
    _account = ConnectionMutationBarrier.capture(widget.route.connectionId);
    ConnectionMutationBarrier.addListener(_onAccountChanged);
    unawaited(_load());
  }

  @override
  void dispose() {
    ConnectionMutationBarrier.removeListener(_onAccountChanged);
    _messageInput.dispose();
    _pane?.close();
    super.dispose();
  }

  void _onAccountChanged() {
    if (ConnectionMutationBarrier.isCurrent(
      widget.route.connectionId,
      _account,
    )) {
      return;
    }
    _pane?.invalidate();
    _target = null;
    if (mounted) {
      setState(() {
        _loading = false;
        _error = context.sharedL10n.ng_bots_account_changed_refresh;
      });
    }
  }

  Future<WorkspaceTarget> _bound() async {
    final existing = _target;
    if (existing != null && existing.isCurrent) return existing;
    _pane?.close();
    final pane = _pane = widget.owner.pane();
    final bound = await pane.bind(widget.route);
    _target = bound;
    return bound;
  }

  Future<void> _load() async {
    try {
      final target = await _bound();
      if (!mounted) return;
      final state = await target.roomState(widget.room.roomId);
      final log = await target.roomLog(widget.room.roomId, limit: 60);
      if (!mounted) return;
      setState(() {
        _room = state.room;
        _driver = state.driverStatus;
        _context = state.context;
        _log = log.events;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = context.sharedL10n.ng_bots_room_load_failed('$e');
      });
    }
  }

  Future<void> _send() async {
    final text = _messageInput.text.trim();
    if (text.isEmpty) return;
    final target = _target;
    if (target == null) return;
    setState(() => _sending = true);
    try {
      await target.roomSend(widget.room.roomId, {'text': text});
      if (!mounted) return;
      _messageInput.clear();
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.sharedL10n.ng_bots_send_failed('$e')),
            ),
          );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _stop() async {
    final target = _target;
    if (target == null) return;
    try {
      await target.roomStop(widget.room.roomId);
      if (!mounted) return;
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.sharedL10n.ng_bots_stop_failed('$e')),
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = _room;
    final driver = _driver;
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name.isNotEmpty ? room.name : room.roomId),
        actions: [
          IconButton(
            tooltip: context.sharedL10n.refresh,
            icon: const Icon(Icons.refresh),
            onPressed: () => unawaited(_load()),
          ),
          IconButton(
            tooltip: context.sharedL10n.ng_bots_stop_room,
            icon: const Icon(Icons.stop_circle_outlined),
            onPressed: _stop,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_error!, textAlign: TextAlign.center),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _roomHeaderCard(room, driver),
                const SizedBox(height: 12),
                _membersCard(room),
                const SizedBox(height: 12),
                _contextCard(),
                const SizedBox(height: 16),
                Text(
                  context.sharedL10n.ng_bots_send_message,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _messageInput,
                  maxLines: 4,
                  maxLength: 65536,
                  decoration: InputDecoration(
                    hintText: context.sharedL10n.ng_bots_room_hint,
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _sending ? null : _send,
                        icon: const Icon(Icons.send),
                        label: Text(context.sharedL10n.send),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  context.sharedL10n.ng_bots_history,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                for (final ev in _log)
                  ListTile(
                    dense: true,
                    leading: Icon(
                      ev.kind.startsWith('message')
                          ? Icons.chat_bubble_outline
                          : Icons.circle_outlined,
                      size: 18,
                    ),
                    title: Text(ev.kind),
                    subtitle: Text('#${ev.seq} · ${ev.actor}'),
                  ),
              ],
            ),
    );
  }

  Widget _roomHeaderCard(RoomSummary room, RoomDriverStatus? driver) {
    final status = driver == null
        ? context.sharedL10n.ng_bots_room_unknown
        : driver.running
        ? (driver.blocked
              ? context.sharedL10n.ng_bots_room_blocked
              : (driver.working
                    ? context.sharedL10n.ng_bots_room_working
                    : context.sharedL10n.ng_bots_room_running))
        : context.sharedL10n.ng_bots_room_idle;
    return Card(
      child: ListTile(
        leading: Icon(
          driver?.running == true ? Icons.sync : Icons.pause_circle_outline,
        ),
        title: Text(
          '${room.name} — $status',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          [
            context.sharedL10n.ng_bots_revision('${room.revision}'),
            if (driver != null && driver.counts.isNotEmpty)
              driver.counts.entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join(', '),
            if (driver?.lastError != null)
              context.sharedL10n.ng_bots_last_error(driver!.lastError!),
            if (room.disbanded) context.sharedL10n.ng_bots_room_disbanded,
          ].join(' · '),
        ),
      ),
    );
  }

  Widget _membersCard(RoomSummary room) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.sharedL10n.ng_bots_members,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final m in room.members)
                  Chip(
                    avatar: const Icon(Icons.person, size: 16),
                    label: Text(m.handle.isNotEmpty ? '@${m.handle}' : m.title),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _contextCard() {
    final roomContext = _context;
    if (roomContext == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.sharedL10n.ng_bots_room_context,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (roomContext.purpose.isNotEmpty)
              Text(context.sharedL10n.ng_bots_purpose(roomContext.purpose)),
            if (roomContext.notes.isNotEmpty)
              Text(context.sharedL10n.ng_bots_notes(roomContext.notes)),
            Text(
              '${context.sharedL10n.ng_bots_routing(roomContext.routing)}${roomContext.leadMemberId.isNotEmpty ? ' · ${context.sharedL10n.ng_bots_lead(roomContext.leadMemberId)}' : ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
