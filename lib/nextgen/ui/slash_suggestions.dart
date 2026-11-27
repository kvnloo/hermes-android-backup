// The NextGen composer's `/` suggestions box, like Hermes Desktop's and
// Kyllene's: typing a leading `/` (or `/partial`) lists matching commands
// with one-line descriptions in a box above the composer, filtered as you
// type. Click or tap a row, or use Up/Down then Enter or Tab, to put it in
// the composer; Esc, Back or a tap elsewhere closes it. Nothing is sent.
//
// Keys are handled on the composer field's own FocusNode, the first node a
// key event reaches. A wrapper above the field (the Windows and Apple ports'
// `SendOnEnter`) only sees Enter, including its key-up and repeats, when the
// box is not using it.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../data/chat_controller.dart';
import '../data/nextgen_gateway.dart';
import '../data/slash_catalog.dart';
import '../data/slash_suggest.dart';
import '../nextgen_l10n.dart';
import '../theme/nextgen_theme.dart';

class NgSlashSuggestions extends StatefulWidget {
  const NgSlashSuggestions({
    super.key,
    required this.chat,
    required this.controller,
    required this.focusNode,
    required this.catalog,
    required this.child,
    this.onOpenChanged,
    this.margin = const EdgeInsets.fromLTRB(12, 4, 12, 0),
    this.gap = 6,
    this.maxRows = 6,
    this.maxWidth = 420,
    this.debounce = kNgSlashSuggestDebounce,
    this.appendArgumentSpace = true,
    this.argumentDebounce = kNgSlashSuggestDebounce,
  });

  final NgChatController chat;
  final TextEditingController controller;

  /// The composer field's node. The box sets its `onKeyEvent` while mounted
  /// (chaining to any handler already there) and restores it on dispose.
  final FocusNode focusNode;

  /// The composer's shared catalogue reader (also used by the highlight
  /// and the send path).
  final NgSlashCatalog catalog;

  /// The composer. Its input container sits [margin] inside it (plus the
  /// safe-area insets its `SafeArea` adds); the box's bottom edge sits [gap]
  /// above that container's top, its left edge on the container's.
  final Widget child;

  /// Whether the box is showing, e.g. to keep the command info card away.
  final ValueChanged<bool>? onOpenChanged;

  final EdgeInsetsGeometry margin;
  final double gap;
  final int maxRows;
  final double maxWidth;
  final Duration debounce;

  /// Whether accepting an argument adds a space (5.0 retains exact insertion).
  final bool appendArgumentSpace;
  final Duration argumentDebounce;

  static final Set<_NgSlashSuggestionsState> _states = {};

  /// Closes a showing box for Android Back; true when one was closed.
  ///
  /// `NgMainPage`'s PopScope (Back toggles the sidebar) runs before any
  /// PopScope inside the chat, since a route calls its pop entries in the
  /// order they registered, so it asks here first. The box's own PopScope
  /// covers a chat shown on a route of its own.
  static bool dismissForBack() {
    for (final state in _states.toList().reversed) {
      if (state.mounted && state._visible) {
        state._dismiss();
        return true;
      }
    }
    return false;
  }

  @override
  State<NgSlashSuggestions> createState() => _NgSlashSuggestionsState();
}

class _NgSlashSuggestionsState extends State<NgSlashSuggestions> {
  final _portal = OverlayPortalController();
  final _scroll = ScrollController();

  /// What the box completes now; null when closed.
  NgSlashQuery? _query;
  List<NgSlashSuggestion> _items = const [];

  /// Where an argument row's text goes in [_query]'s text.
  int _replaceFrom = 1;
  int _marked = 0;

  /// The user moved the mark (keys or pointer) for this query: a refreshed
  /// list keeps that row marked. Otherwise the first row is.
  bool _markedByUser = false;

  /// The gateway's answer for [_query]'s text, when it came.
  NgSlashCompletion? _server;
  final _argumentCache = <String, NgSlashCompletion>{};
  Object? _completionOwner;

  /// Esc, Back or a tap elsewhere: closed until the text changes.
  bool _dismissed = false;

  /// Bumped by every new query: a reply for older typing is dropped.
  int _epoch = 0;
  int? _asking;
  Timer? _timer;
  late String _lastText;
  FocusOnKeyEventCallback? _chainedKeys;

  /// Keys whose key-down the box took (Enter, Tab, Esc): their repeats and
  /// key-up are swallowed too, so a send-on-Enter wrapper never sees them.
  final Set<PhysicalKeyboardKey> _swallowed = {};
  bool _reported = false;

  bool get _visible {
    final query = _query;
    return query != null &&
        !_dismissed &&
        widget.focusNode.hasFocus &&
        (!query.isArgument || _items.isNotEmpty);
  }

  bool get _loading =>
      (_timer?.isActive ?? false) ||
      _asking == _epoch ||
      widget.catalog.isLoading;

  @override
  void initState() {
    super.initState();
    NgSlashSuggestions._states.add(this);
    _lastText = widget.controller.text;
    _attach(widget);
  }

  void _attach(NgSlashSuggestions w) {
    w.controller.addListener(_onValue);
    w.focusNode.addListener(_onFocus);
    w.catalog.addListener(_onCatalog);
    _chainedKeys = w.focusNode.onKeyEvent;
    w.focusNode.onKeyEvent = _onKey;
  }

  void _detach(NgSlashSuggestions w) {
    w.controller.removeListener(_onValue);
    w.focusNode.removeListener(_onFocus);
    w.catalog.removeListener(_onCatalog);
    if (w.focusNode.onKeyEvent == _onKey) w.focusNode.onKeyEvent = _chainedKeys;
    _chainedKeys = null;
  }

  @override
  void didUpdateWidget(covariant NgSlashSuggestions old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller ||
        old.focusNode != widget.focusNode ||
        old.catalog != widget.catalog) {
      _detach(old);
      _attach(widget);
      _lastText = widget.controller.text;
      _close();
    } else if (old.chat != widget.chat) {
      // Another chat: its scope, skills and session differ.
      _close();
    }
  }

  @override
  void dispose() {
    NgSlashSuggestions._states.remove(this);
    _timer?.cancel();
    _detach(widget);
    _scroll.dispose();
    super.dispose();
  }

  void _onValue() {
    final text = widget.controller.text;
    final edited = text != _lastText;
    _lastText = text;
    if (edited) _dismissed = false;
    _update(edited: edited);
  }

  void _onFocus() {
    if (!widget.focusNode.hasFocus) _close();
  }

  void _onCatalog() {
    if (!mounted || _query == null) return;
    _recompute();
    _sync();
  }

  NextGenGateway get _gateway => widget.chat.gateway;

  bool get _canAsk {
    final gateway = _gateway;
    return gateway.state.isConnected &&
        !ngCompleteSlashUnsupported(gateway.socket ?? gateway);
  }

  void _scopeCatalog() {
    final owner = (_gateway, _gateway.socket, widget.chat.runtimeId);
    if (_completionOwner != owner) {
      _completionOwner = owner;
      _argumentCache.clear();
    }
    widget.catalog.scopeTo(_gateway, sessionId: widget.chat.runtimeId);
  }

  /// Re-reads the draft. Only an edit opens the box; moving the caret
  /// within the token while it is open re-filters, anywhere else closes it.
  void _update({required bool edited}) {
    if (!mounted) return;
    final query = widget.focusNode.hasFocus && !_dismissed
        ? NgSlashQuery.of(widget.controller.value)
        : null;
    if (query == null) return _close();
    // Composing-only and other same-place updates change nothing.
    if (query.sameAs(_query)) return;
    // A tap or caret move never opens the box (a tap on the token shows the
    // command's info card instead); it only re-filters a showing box. This
    // also drops an argument query that had nothing to show.
    if (!edited && !_visible) return _close();
    _scopeCatalog();
    // Argument discovery is read-only. Let the gateway resolve commands even
    // when an older/partial catalogue omitted them (5.0 completion behaviour).
    if (query.isArgument && !_canAsk) {
      return _close();
    }
    final previous = _query;
    final previousItems = _items;
    _query = query;
    _epoch++;
    _markedByUser = false;
    if (_server?.text != query.text) _server = null;
    if (query.isArgument) _server = _argumentCache[query.text];
    if (!query.isArgument) unawaited(widget.catalog.ensureLoaded());
    _recompute(
      carried: previous != null && previous.isArgument && query.isArgument
          ? previousItems
          : const [],
    );
    _schedule(query);
    _sync(reset: true);
  }

  String _localDescription(String name) => switch (name) {
    'new' || 'reset' => ngL.ng_new_chat,
    'stop' => ngL.ng_stop,
    'model' => ngL.ng_model,
    _ => '',
  };

  void _recompute({List<NgSlashSuggestion> carried = const []}) {
    final query = _query;
    if (query == null) return;
    final marked = _markedByUser && _marked < _items.length
        ? _items[_marked]
        : null;
    final server = _server;
    var replaceFrom = 1;
    List<NgSlashSuggestion> items;
    if (!query.isArgument) {
      items = server != null && !server.isArgument
          ? ngRunnableSlashSuggestions(
              server,
              query.name,
              widget.catalog,
              localDescription: _localDescription,
            )
          : ngLocalSlashSuggestions(
              query.name,
              widget.catalog,
              localDescription: _localDescription,
              // Offline or still loading: just NextGen's own commands.
              fallback: _gateway.state.isConnected && !widget.catalog.isLoading,
            );
    } else if (server != null) {
      replaceFrom = server.replaceFrom;
      items = server.isArgument
          ? _newOptions(server.items, query, replaceFrom)
          : const [];
    } else {
      // Until the gateway answers, keep the earlier choices that still fit.
      replaceFrom = _replaceFrom;
      items = _newOptions(carried, query, replaceFrom);
    }
    _items = items;
    _replaceFrom = replaceFrom;
    final keep = marked == null ? -1 : items.indexOf(marked);
    _marked = keep < 0 ? 0 : keep;
  }

  /// Argument rows that extend what is typed (not what is already there).
  List<NgSlashSuggestion> _newOptions(
    List<NgSlashSuggestion> items,
    NgSlashQuery query,
    int replaceFrom,
  ) {
    final typed = query.text;
    if (replaceFrom > typed.length) return const [];
    final head = typed.substring(0, replaceFrom);
    final lower = typed.toLowerCase();
    return [
      for (final item in items)
        if ((head + item.insert).toLowerCase().startsWith(lower) &&
            (head + item.insert).trim() != typed.trim())
          item,
    ];
  }

  void _schedule(NgSlashQuery query) {
    _timer?.cancel();
    _timer = null;
    // A bare `/` browses the catalogue, as Hermes Desktop and Kyllene do;
    // typing narrows it through the gateway's ranking.
    if (!_canAsk ||
        (!query.isArgument && query.name.isEmpty) ||
        (query.isArgument && _argumentCache.containsKey(query.text))) {
      return;
    }
    final epoch = _epoch;
    _timer = Timer(
      query.isArgument ? widget.argumentDebounce : widget.debounce,
      () => unawaited(_ask(query, epoch)),
    );
  }

  Future<void> _ask(NgSlashQuery query, int epoch) async {
    if (!mounted || epoch != _epoch) return;
    _asking = epoch;
    NgSlashCompletion? answer;
    try {
      answer = await ngCompleteSlash(
        _gateway,
        query.text,
        sessionId: widget.chat.runtimeId,
      );
    } catch (_) {
      // Old gateway (remembered for the socket), error or timeout: the
      // catalogue's matches stay.
    }
    // Newer typing (or a closed box) owns the rows now.
    if (!mounted || epoch != _epoch) return;
    _asking = null;
    if (answer != null) {
      _server = answer;
      if (query.isArgument) {
        _argumentCache[query.text] = answer;
        if (_argumentCache.length > 64) {
          _argumentCache.remove(_argumentCache.keys.first);
        }
      }
      _recompute();
    } else if (query.isArgument) {
      _items = const [];
    }
    _sync();
  }

  void _close() {
    _timer?.cancel();
    _timer = null;
    if (_query == null) return;
    _epoch++;
    _asking = null;
    _query = null;
    _server = null;
    _items = const [];
    _marked = 0;
    _sync();
  }

  void _dismiss() {
    _dismissed = true;
    _close();
  }

  void _accept(NgSlashSuggestion suggestion) {
    final query = _query;
    if (query == null) return;
    final value = query.apply(
      widget.controller.text,
      suggestion,
      replaceFrom: _replaceFrom,
      appendSpace: !query.isArgument || widget.appendArgumentSpace,
    );
    _close();
    // The edit may open argument choices for the command just picked.
    widget.controller.value = value;
    if (!widget.focusNode.hasFocus) widget.focusNode.requestFocus();
  }

  void _mark(int index) {
    if (_items.isEmpty) return;
    final next = index % _items.length;
    _markedByUser = true;
    setState(() => _marked = next < 0 ? next + _items.length : next);
    SchedulerBinding.instance.addPostFrameCallback((_) => _reveal());
  }

  /// Scrolls the marked row into view.
  void _reveal() {
    if (!mounted || !_scroll.hasClients) return;
    final position = _scroll.position;
    final extent = _rowExtent(context);
    final top = _listPadding + _marked * extent;
    final bottom = top + extent;
    if (top - _listPadding < position.pixels) {
      _scroll.jumpTo(math.max(0, top - _listPadding));
    } else if (bottom + _listPadding >
        position.pixels + position.viewportDimension) {
      _scroll.jumpTo(
        math.min(
          position.maxScrollExtent,
          bottom + _listPadding - position.viewportDimension,
        ),
      );
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final physical = event.physicalKey;
    if (_swallowed.contains(physical)) {
      if (event is KeyUpEvent) _swallowed.remove(physical);
      return KeyEventResult.handled;
    }
    if (event is! KeyUpEvent && _visible) {
      final handled = _key(event);
      if (handled != null) {
        if (handled && event is KeyDownEvent) _swallowed.add(physical);
        return KeyEventResult.handled;
      }
    }
    return _chainedKeys?.call(node, event) ?? KeyEventResult.ignored;
  }

  /// Null when the box does not use [event]; else whether its key-up must
  /// be swallowed as well.
  bool? _key(KeyEvent event) {
    final key = event.logicalKey;
    final keyboard = HardwareKeyboard.instance;
    if (key == LogicalKeyboardKey.escape) {
      if (event is KeyDownEvent) _dismiss();
      return true;
    }
    if (_items.isEmpty ||
        keyboard.isControlPressed ||
        keyboard.isMetaPressed ||
        keyboard.isAltPressed) {
      return null;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      _mark(_marked + 1);
      return false;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      _mark(_marked - 1);
      return false;
    }
    final enter =
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter;
    if (!(enter || key == LogicalKeyboardKey.tab) || keyboard.isShiftPressed) {
      return null;
    }
    final item = _items[_marked];
    if (enter && _typedExactly(item)) {
      // `/help` typed in full: Enter does what it does without the box
      // (the ports' SendOnEnter runs it) instead of adding a space.
      if (event is KeyDownEvent) _dismiss();
      return null;
    }
    if (event is KeyDownEvent) _accept(item);
    return true;
  }

  /// Whether the caret ends a leading token that already is [item].
  bool _typedExactly(NgSlashSuggestion item) {
    final query = _query;
    return query != null &&
        !query.isArgument &&
        query.caret == query.tokenEnd &&
        item.kind != NgSlashSuggestionKind.option &&
        item.insert.toLowerCase() == query.text.toLowerCase();
  }

  /// Shows or hides the overlay and tells the owner, outside any build.
  void _sync({bool reset = false}) {
    if (!mounted) return;
    void apply() {
      if (!mounted) return;
      final visible = _visible;
      if (visible && !_portal.isShowing) _portal.show();
      if (!visible && _portal.isShowing) _portal.hide();
      if (visible != _reported) {
        _reported = visible;
        widget.onOpenChanged?.call(visible);
      }
      if (reset && _scroll.hasClients) _scroll.jumpTo(0);
    }

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => apply());
    } else {
      apply();
    }
    setState(() {});
  }

  static const double _listPadding = 4;

  double _rowExtent(BuildContext context) =>
      math.max(36, MediaQuery.textScalerOf(context).scale(17) + 20);

  Widget _overlay(BuildContext context, OverlayChildLayoutInfo info) {
    if (!_visible || info.childPaintTransform.determinant() == 0) {
      return const SizedBox.shrink();
    }
    final child = MatrixUtils.transformRect(
      info.childPaintTransform,
      Offset.zero & info.childSize,
    );
    final padding = MediaQuery.paddingOf(context);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final margin = widget.margin.resolve(Directionality.of(context));
    final left = child.left + margin.left + padding.left;
    final right = child.right - margin.right - padding.right;
    final width = math.max(0.0, math.min(widget.maxWidth, right - left));
    final bottom = child.top + margin.top - widget.gap;
    final extent = _rowExtent(context);
    final full = widget.maxRows * extent + 2 * _listPadding;
    // Below the app bar where there is room, never less than one row.
    final room = bottom - (padding.top + kToolbarHeight + 4);
    final maxHeight = math.min(full, math.max(extent + 2 * _listPadding, room));
    return Stack(
      children: [
        Positioned(
          left: rtl ? null : left,
          right: rtl ? info.overlaySize.width - right : null,
          bottom: info.overlaySize.height - bottom,
          width: width,
          // Taps on the box count as inside the field (desktop keeps focus);
          // a tap anywhere else closes it.
          child: TextFieldTapRegion(
            onTapOutside: (_) => _dismiss(),
            child: _box(context, width, maxHeight, extent),
          ),
        ),
      ],
    );
  }

  Widget _box(
    BuildContext context,
    double width,
    double maxHeight,
    double extent,
  ) {
    final c = NgColors.of(context);
    final Widget body;
    if (_items.isEmpty) {
      body = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Text(
          _loading
              ? ngL.ng_slash_suggestions_loading
              : ngL.ng_slash_suggestions_empty,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: NgType.bodySmall.copyWith(color: c.text3),
        ),
      );
    } else {
      body = ListView.builder(
        controller: _scroll,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: _listPadding),
        itemExtent: extent,
        itemCount: _items.length,
        itemBuilder: (context, index) => _row(context, index, width),
      );
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: ngL.ng_slash_suggestions_label,
      child: Material(
        key: const ValueKey('ng-slash-suggestions'),
        color: c.sheet,
        elevation: 6,
        shadowColor: Theme.of(context).colorScheme.shadow,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NgRadii.md),
          side: BorderSide(color: c.stroke),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: body,
        ),
      ),
    );
  }

  Widget _row(BuildContext context, int index, double width) {
    final c = NgColors.of(context);
    final item = _items[index];
    final marked = index == _marked;
    return Semantics(
      button: true,
      selected: marked,
      child: InkWell(
        key: ValueKey('ng-slash-suggestion-${item.label}'),
        canRequestFocus: false,
        onTap: () => _accept(item),
        onHover: (hovering) {
          if (!hovering || _marked == index) return;
          _markedByUser = true;
          setState(() => _marked = index);
        },
        child: Container(
          color: marked ? c.surface2 : null,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width * 0.5),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NgType.label.copyWith(
                    color: item.isSkill ? c.accentText : c.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (item.isSkill)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 6),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: c.accentSoft,
                      borderRadius: BorderRadius.circular(NgRadii.xs),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      child: Text(
                        ngL.ng_slash_suggestions_skill,
                        style: NgType.caption.copyWith(
                          color: c.accentText,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: NgType.caption.copyWith(color: c.text3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_visible,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _visible) _dismiss();
      },
      child: OverlayPortal.overlayChildLayoutBuilder(
        controller: _portal,
        overlayChildBuilder: _overlay,
        child: widget.child,
      ),
    );
  }
}
