import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/notification_prefs.dart';
import '../services/turn_notification_service.dart';
import '../services/ws_client.dart';
import 'hermes_shell.dart' show HermesPaneVisibility;

/// The socket a chat pane would report on, and the runtime session it shows.
/// Null while the pane cannot name both without starting a connection or
/// creating a chat.
typedef ChatPresenceTarget = (WsClient, String)? Function();

/// Page-level input evidence for `client.activity`, on every platform.
///
/// Wrap each chat pane. Never samples other apps and never sends keys, text,
/// pointer coordinates, titles, configured hosts or credentials. Off until the
/// user opts in, and silent unless the socket's gateway acknowledged
/// `client_activity`. Every pane reports through [ChatPresenceCoordinator], so
/// panes that share a socket never overwrite each other.
class ChatPresence extends StatefulWidget {
  const ChatPresence({
    super.key,
    required this.target,
    this.cueKey,
    required this.child,
  });

  final ChatPresenceTarget target;

  /// The chat this pane shows, named as its completion cue names it
  /// (`<connection id>|<stored chat id>`), or null while it has none. Lets
  /// the main window and a pop-out agree which of them plays the cue.
  final String? Function()? cueKey;
  final Widget child;

  /// Records input in the pane around [context]. Pointer and hardware-key
  /// input are seen here; composers also call this for text edits and focus,
  /// because a phone's soft keyboard produces no hardware key events.
  static void noteInput(BuildContext context) =>
      context.findAncestorStateOfType<_ChatPresenceState>()?._noteInput();

  @override
  State<ChatPresence> createState() => _ChatPresenceState();
}

class _ChatPresenceState extends State<ChatPresence> {
  final _focus = FocusNode(skipTraversal: true, canRequestFocus: false);

  /// Coordinator clock time of the newest input in this pane.
  Duration? _input;
  bool _ticking = true;
  bool _routeCurrent = true;
  bool _paneVisible = true;

  ChatPresenceCoordinator get _coordinator => ChatPresenceCoordinator.instance;

  /// On screen: its ticker is live (not an offstage tab or a hidden parallel
  /// pane), its shell destination is selected, and no other route covers it.
  /// The app being in front is checked by the coordinator.
  bool get _onScreen => mounted && _ticking && _routeCurrent && _paneVisible;

  @override
  void initState() {
    super.initState();
    _coordinator._attach(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Each lookup makes this method run again when it changes, so a pushed
    // route or a hidden pane is withdrawn at once, not at the next tick.
    final ticking = TickerMode.valuesOf(context).enabled;
    final routeCurrent = ModalRoute.isCurrentOf(context) != false;
    // The Classic shell keeps a visited destination mounted in an
    // IndexedStack with its tickers running, so a chat embedded in the Chats
    // pane is only hidden by this flag when another destination is chosen.
    final paneVisible = HermesPaneVisibility.of(context);
    if (ticking != _ticking ||
        routeCurrent != _routeCurrent ||
        paneVisible != _paneVisible) {
      _ticking = ticking;
      _routeCurrent = routeCurrent;
      _paneVisible = paneVisible;
      _coordinator._schedule();
    }
  }

  @override
  void didUpdateWidget(ChatPresence oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The pane may now show another chat or socket.
    _coordinator._schedule();
  }

  void _noteInput() {
    if (!_coordinator._on || !_onScreen || !_coordinator._foreground) return;
    _input = _coordinator._now;
    _coordinator.evaluate();
  }

  @override
  void dispose() {
    _coordinator._detach(this);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Focus(
    focusNode: _focus,
    includeSemantics: false,
    child: Listener(
      onPointerDown: (_) => _noteInput(),
      onPointerSignal: (_) => _noteInput(),
      child: widget.child,
    ),
  );
}

/// Wraps a pane's composer. A phone's soft keyboard produces no hardware key
/// events, so gaining focus and each user text edit count as input: [builder]
/// passes `input` for the field's `onChanged`, which only user edits call
/// (a restored draft or a cleared field does not).
class ChatPresenceComposer extends StatelessWidget {
  const ChatPresenceComposer({super.key, required this.builder});

  final Widget Function(BuildContext context, VoidCallback input) builder;

  @override
  Widget build(BuildContext context) => Focus(
    canRequestFocus: false,
    skipTraversal: true,
    includeSemantics: false,
    onFocusChange: (focused) {
      if (focused) ChatPresence.noteInput(context);
    },
    child: builder(context, () => ChatPresence.noteInput(context)),
  );
}

class _Changes extends ChangeNotifier {
  void fire() => notifyListeners();
}

/// What one socket was last told: a claim for [session], or a withdrawal.
class _Statement {
  const _Statement({
    required this.at,
    required this.session,
    required this.input,
    this.canAlert = false,
  });

  final Duration at;
  final String? session;
  final Duration? input;
  final bool canAlert;
}

/// One presence reporter per app window (a pop-out runs its own).
///
/// The gateway keeps one statement per connection: each `client.activity`
/// replaces the connection's whole record set
/// (`gateway/session_presence.py`). Several panes can share one socket
/// (NextGen parallel panes on one gateway, Classic panes on one application
/// session), so each socket is evaluated once, over every pane on it, as the
/// Desktop reporter does for its window (`apps/desktop/src/store/presence.ts`):
///
/// * the socket claims only the on-screen pane with the newest input, while
///   that input is younger than [active], at most once per [refresh] unless
///   the claimed session changes or the input the socket last heard about
///   has aged past [active] (input after an idle spell is claimed at once);
/// * a claim is withdrawn (`sessions: []`) as soon as its session is no longer
///   the one in view on that socket: another pane's newer input, a pushed
///   route, a hidden pane, the app leaving the screen, or the opt-in being
///   turned off;
/// * evidence that merely goes stale is not withdrawn: the gateway ages a
///   record by itself, so silence is safe, and an empty report would also
///   drop the input the gateway saw on that socket.
///
/// `away: true` is reserved for a locked or suspending device. The app has no
/// lock or suspend signal on any platform, so it never sends it.
class ChatPresenceCoordinator with WidgetsBindingObserver {
  ChatPresenceCoordinator._();

  static final instance = ChatPresenceCoordinator._();

  /// Evidence younger than this counts as the user being here.
  static const active = Duration(seconds: 60);

  /// At most one report per socket per this interval while nothing changes.
  static const refresh = Duration(seconds: 45);

  /// How often the evidence is re-read.
  static const tick = Duration(seconds: 10);

  final _clock = Stopwatch()..start();
  final _panes = <_ChatPresenceState>[];
  final Map<WsClient, _Statement> _told = Map.identity();
  final _changes = _Changes();
  Timer? _ticker;
  bool _scheduled = false;

  Duration get _now => _clock.elapsed;
  bool get _on => notificationPrefs.value.shareWindowActivity;
  bool get _foreground =>
      WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

  /// Fires after every evaluation, so cue ownership follows [shows] and
  /// [holds].
  Listenable get changes => _changes;

  /// A pane in this window shows the chat named by [cueKey], seen or not.
  bool shows(String cueKey) =>
      _panes.any((pane) => pane.widget.cueKey?.call() == cueKey);

  /// This window holds presence for the chat named by [cueKey]: sharing is
  /// on, the window is in front, and a pane showing that chat is on screen
  /// with input younger than [active]. Evidence only: it does not depend on
  /// the gateway accepting reports.
  bool holds(String cueKey) {
    if (!_on || !_foreground) return false;
    final now = _now;
    return _panes.any((pane) {
      final input = pane._input;
      return input != null &&
          now - input < active &&
          pane._onScreen &&
          pane.widget.cueKey?.call() == cueKey;
    });
  }

  void _attach(_ChatPresenceState pane) {
    if (_panes.isEmpty) {
      WidgetsBinding.instance.addObserver(this);
      HardwareKeyboard.instance.addHandler(_key);
      notificationPrefs.addListener(_policy);
    }
    _panes.add(pane);
    _policy();
  }

  void _detach(_ChatPresenceState pane) {
    _panes.remove(pane);
    evaluate();
    if (_panes.isEmpty) {
      _ticker?.cancel();
      _ticker = null;
      notificationPrefs.removeListener(_policy);
      HardwareKeyboard.instance.removeHandler(_key);
      WidgetsBinding.instance.removeObserver(this);
    }
  }

  bool _key(KeyEvent event) {
    if (event is KeyDownEvent) {
      for (final pane in List.of(_panes)) {
        if (pane._focus.hasFocus) pane._noteInput();
      }
    }
    return false;
  }

  void _policy() {
    if (_on && _panes.isNotEmpty) {
      _ticker ??= Timer.periodic(tick, (_) => evaluate());
    } else {
      _ticker?.cancel();
      _ticker = null;
    }
    if (!_on) {
      for (final pane in _panes) {
        pane._input = null;
      }
    }
    evaluate();
  }

  /// Coalesces evaluations requested while widgets build.
  void _schedule() {
    if (_scheduled) return;
    _scheduled = true;
    scheduleMicrotask(() {
      _scheduled = false;
      evaluate();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      // Input from before the app left the screen is no evidence after it.
      for (final pane in _panes) {
        pane._input = null;
      }
    }
    evaluate();
  }

  /// Re-reads every pane and corrects what each socket was told.
  @visibleForTesting
  void evaluate() {
    final now = _now;
    // A dropped socket holds nothing; a reconnected one starts empty.
    _told.removeWhere((socket, _) => !socket.acceptsWindowActivity);
    final views = <WsClient, (String, Duration)>{};
    if (_on && _foreground) {
      for (final pane in _panes) {
        final input = pane._input;
        if (input == null || !pane._onScreen) continue;
        final target = pane.widget.target();
        if (target == null || !target.$1.acceptsWindowActivity) continue;
        final best = views[target.$1];
        if (best == null || input > best.$2) {
          views[target.$1] = (target.$2, input);
        }
      }
    }
    for (final socket in List.of(_told.keys)) {
      if (!views.containsKey(socket) && _told[socket]!.session != null) {
        _withdraw(socket, now);
      }
    }
    for (final MapEntry(key: socket, value: (session, input))
        in views.entries) {
      final last = _told[socket];
      final canAlert =
          notificationKindEnabled(HermesNotificationKind.turnDone) &&
          TurnNotificationService.shared.permissionGranted;
      if (now - input < active) {
        // The input the socket last heard about. Once it is [active] old the
        // gateway counts the user as gone, so fresh input is news at once
        // (Desktop's `!wasActive`), not at the next refresh.
        final heard = last?.input;
        if (last == null ||
            last.session != session ||
            last.canAlert != canAlert ||
            heard == null ||
            now - heard >= active ||
            now - last.at >= refresh) {
          _claim(socket, session, input, canAlert, now);
        }
      } else if (last?.session != null &&
          (last!.session != session || (last.canAlert && !canAlert))) {
        // Stale evidence claims nothing new, but a claim that stopped being
        // true is corrected.
        _withdraw(socket, now);
      }
    }
    _changes.fire();
  }

  void _claim(
    WsClient socket,
    String session,
    Duration input,
    bool canAlert,
    Duration now,
  ) {
    final statement = _Statement(
      at: now,
      session: session,
      input: input,
      canAlert: canAlert,
    );
    _send(socket, statement, {
      'sessions': [session],
      'basis': 'page',
      'idle_seconds': (now - input).inSeconds,
      'can_alert': canAlert,
    });
  }

  void _withdraw(WsClient socket, Duration now) {
    final input = _told[socket]?.input;
    _send(socket, _Statement(at: now, session: null, input: input), {
      'sessions': <String>[],
      'basis': 'page',
      'idle_seconds': input == null
          ? active.inSeconds
          : (now - input).inSeconds,
    });
  }

  void _send(
    WsClient socket,
    _Statement statement,
    Map<String, dynamic> params,
  ) {
    _told[socket] = statement;
    // A refused or failed report leaves the socket's state unknown: forget
    // it, so the next evaluation states it again.
    socket
        .send('client.activity', params, includeProfile: false)
        .then(
          (_) {},
          onError: (Object _) {
            if (identical(_told[socket], statement)) _told.remove(socket);
          },
        );
  }
}
