// Slash-command highlighting for the chat composers.
//
// The composer controller styles a recognised leading `/command` token while
// the draft text stays byte-for-byte what the user typed, and the anchor shows
// a small, non-focusable card describing that command when the token is
// tapped (or the caret is moved into it from the keyboard).
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../controllers/slash_command_controller.dart';
import '../l10n/l10n.dart';
import '../models/slash_command.dart';
import '../theme/hermes_theme.dart';

/// The leading slash token of a draft, read the way the send path reads it.
///
/// Both composers trim the draft before sending, so leading whitespace is
/// skipped; the token then runs to the first whitespace (`/title My chat`).
/// A lone `/`, a slash mid-sentence or a path such as `/usr/bin` (or `//x`)
/// is never a command token.
@immutable
class SlashCommandToken {
  const SlashCommandToken._(this.start, this.end, this.name);

  /// Offset of the `/` in the draft.
  final int start;

  /// Exclusive end offset of the token.
  final int end;

  /// The name as typed, without the slash.
  final String name;

  TextRange get range => TextRange(start: start, end: end);

  static final RegExp _leadingSpace = RegExp(r'^\s*');
  static final RegExp _space = RegExp(r'\s');

  static SlashCommandToken? parse(String text) {
    final start = _leadingSpace.matchAsPrefix(text)?.end ?? 0;
    if (start >= text.length || text.codeUnitAt(start) != 0x2F) return null;
    final gap = _space.allMatches(text, start + 1).firstOrNull;
    final end = gap?.start ?? text.length;
    final name = text.substring(start + 1, end);
    if (name.isEmpty || name.contains('/')) return null;
    return SlashCommandToken._(start, end, name);
  }

  @override
  bool operator ==(Object other) =>
      other is SlashCommandToken &&
      other.start == start &&
      other.end == end &&
      other.name == name;

  @override
  int get hashCode => Object.hash(start, end, name);
}

/// What the composer knows about a recognised command token.
@immutable
class SlashCommandTokenInfo {
  const SlashCommandTokenInfo({
    required this.typed,
    required this.canonical,
    this.description = '',
    this.argumentMode,
    this.detailsPending = false,
  });

  /// The name as typed, without the slash.
  final String typed;

  /// The canonical name the gateway dispatches, without the slash.
  final String canonical;

  /// The catalogue description; registry commands already include their
  /// localized usage hint.
  final String description;

  /// `options`, `text` or `mixed` when the catalogue carries one.
  final String? argumentMode;

  /// The name is recognised but the catalogue with its details is still
  /// loading.
  final bool detailsPending;

  bool get isAlias => typed.toLowerCase() != canonical.toLowerCase();
}

/// Decides whether a typed command name is highlighted, and with what details.
/// Returning null leaves the token as plain text.
typedef SlashCommandTokenResolver =
    SlashCommandTokenInfo? Function(String name);

/// A highlighted token and its resolved details.
@immutable
class SlashCommandHighlight {
  const SlashCommandHighlight(this.token, this.info);

  final SlashCommandToken token;
  final SlashCommandTokenInfo info;
}

/// Name → command index over a parsed catalogue, resolving aliases.
class SlashCommandLookup {
  SlashCommandLookup(
    Iterable<SlashCommand> commands, {
    Map<String, String> aliases = const {},
  }) {
    for (final command in commands) {
      _byName.putIfAbsent(command.name.toLowerCase(), () => command);
    }
    for (final entry in aliases.entries) {
      final alias = _bare(entry.key);
      final target = _bare(entry.value);
      if (alias.isEmpty || target.isEmpty) continue;
      _aliases[alias] = target;
    }
  }

  /// Parses a raw `commands.catalog` result, including its `canon` aliases.
  factory SlashCommandLookup.fromCatalogResult(Object? result) {
    final catalog = SlashCommandCatalog.fromResult(result);
    final canon = result is Map ? result['canon'] : null;
    return SlashCommandLookup(
      catalog.commands,
      aliases: {
        if (canon is Map)
          for (final entry in canon.entries)
            if (entry.key is String && entry.value is String)
              entry.key as String: entry.value as String,
      },
    );
  }

  /// One lookup per parsed catalogue instance; catalogues are immutable.
  static SlashCommandLookup of(SlashCommandCatalog catalog) =>
      _byCatalog[catalog] ??= SlashCommandLookup(catalog.commands);

  static final Expando<SlashCommandLookup> _byCatalog = Expando(
    'slash command lookup',
  );

  final Map<String, SlashCommand> _byName = {};
  final Map<String, String> _aliases = {};

  bool get isEmpty => _byName.isEmpty;

  /// The command [name] (or the alias it names) refers to, or null.
  SlashCommandTokenInfo? resolve(String name) {
    final key = _bare(name);
    if (key.isEmpty) return null;
    final command = _byName[key] ?? _byName[_aliases[key] ?? ''];
    if (command == null) return null;
    return SlashCommandTokenInfo(
      typed: name,
      canonical: command.name,
      description: command.description,
      argumentMode: command.argumentMode,
    );
  }

  static String _bare(String value) =>
      value.trim().replaceFirst(RegExp(r'^/+'), '').toLowerCase();
}

/// A drop-in [TextEditingController] that styles a recognised leading slash
/// command token.
///
/// Only [buildTextSpan] differs: [value], selection, composing region, undo
/// and input formatters behave exactly like the base controller, so wrappers
/// that expect a plain [TextEditingController] (send-on-enter shortcuts,
/// large-paste formatters, draft persistence) keep working. The IME composing
/// underline is preserved inside and outside the token.
class SlashCommandHighlightController extends TextEditingController {
  SlashCommandHighlightController({super.text});

  SlashCommandHighlightController.fromValue(super.value) : super.fromValue();

  /// Decides which names are highlighted. Without one nothing is styled.
  SlashCommandTokenResolver? resolver;

  /// Style for the highlighted token, resolved against the field's context.
  TextStyle Function(BuildContext context)? highlightStyleOf;

  String? _parsedText;
  SlashCommandToken? _parsedToken;

  /// The leading slash token of the current draft, recognised or not.
  SlashCommandToken? get slashToken {
    final current = text;
    if (!identical(current, _parsedText)) {
      _parsedText = current;
      _parsedToken = SlashCommandToken.parse(current);
    }
    return _parsedToken;
  }

  /// The highlighted token and its details, or null when nothing is styled.
  SlashCommandHighlight? get highlight {
    final token = slashToken;
    final resolve = resolver;
    if (token == null || resolve == null) return null;
    final info = resolve(token.name);
    return info == null ? null : SlashCommandHighlight(token, info);
  }

  static TextStyle defaultHighlightStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.w500,
  );

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final match = highlight;
    if (match == null) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    assert(
      !value.composing.isValid || !withComposing || value.isComposingRangeValid,
    );
    final text = value.text;
    final composing = withComposing && value.isComposingRangeValid
        ? value.composing
        : null;
    final accent =
        highlightStyleOf?.call(context) ?? defaultHighlightStyle(context);
    const underline = TextStyle(decoration: TextDecoration.underline);
    final token = match.token;
    final cuts = <int>{
      0,
      text.length,
      token.start,
      token.end,
      if (composing != null) ...[composing.start, composing.end],
    }.toList()..sort();
    final children = <TextSpan>[];
    for (var i = 0; i + 1 < cuts.length; i++) {
      final from = cuts[i];
      final to = cuts[i + 1];
      if (from >= to) continue;
      var segment = from >= token.start && to <= token.end ? accent : null;
      if (composing != null && from >= composing.start && to <= composing.end) {
        segment = (segment ?? const TextStyle()).merge(underline);
      }
      children.add(TextSpan(text: text.substring(from, to), style: segment));
    }
    return TextSpan(style: style, children: children);
  }
}

/// User-visible copy for the command card, supplied by each composer's own
/// localizations.
@immutable
class SlashCommandInfoStrings {
  const SlashCommandInfoStrings({
    required this.noDescription,
    required this.loading,
    required this.aliasOf,
    required this.argumentsOptions,
    required this.argumentsText,
    required this.argumentsMixed,
  });

  final String noDescription;
  final String loading;
  final String Function(String alias, String command) aliasOf;
  final String argumentsOptions;
  final String argumentsText;
  final String argumentsMixed;

  String? argumentHint(String? mode) => switch (mode) {
    'options' => argumentsOptions,
    'text' => argumentsText,
    'mixed' => argumentsMixed,
    _ => null,
  };
}

/// Colours and type for the command card, supplied by each composer's theme.
@immutable
class SlashCommandInfoStyle {
  const SlashCommandInfoStyle({
    required this.background,
    required this.foreground,
    required this.muted,
    required this.accent,
    required this.border,
    this.textStyle,
    this.radius = 12,
  });

  final Color background;
  final Color foreground;
  final Color muted;
  final Color accent;
  final Color border;
  final TextStyle? textStyle;
  final double radius;

  static SlashCommandInfoStyle fallback(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SlashCommandInfoStyle(
      background: scheme.surfaceContainerHigh,
      foreground: scheme.onSurface,
      muted: scheme.onSurfaceVariant,
      accent: scheme.primary,
      border: scheme.outlineVariant,
      textStyle: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

/// The small card describing one command: canonical name, the alias it was
/// typed as, the catalogue description (which carries usage) and the
/// argument hint.
class SlashCommandInfoCard extends StatelessWidget {
  const SlashCommandInfoCard({
    super.key,
    required this.info,
    required this.strings,
    required this.style,
    this.note,
    this.maxWidth = 280,
  });

  final SlashCommandTokenInfo info;
  final SlashCommandInfoStrings strings;
  final SlashCommandInfoStyle style;

  /// An extra line under the details (e.g. how this composer sends commands).
  final String? note;
  final double maxWidth;

  /// Whether [description] carries the gateway's usage clause for
  /// [command]. Every localized `slash.shared.usage_suffix` template embeds
  /// `/{name} {args_hint}`.
  @visibleForTesting
  static bool describesUsage(String description, String command) => RegExp(
    '/${RegExp.escape(command)}(?=[\\s)\uFF09]|\$)',
    caseSensitive: false,
  ).hasMatch(description);

  @override
  Widget build(BuildContext context) {
    final base =
        style.textStyle ??
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle(fontSize: 14);
    final small = base.copyWith(
      color: style.muted,
      fontSize: (base.fontSize ?? 14) - 1,
    );
    final description = info.description.trim();
    // Registry descriptions already end in a localized usage clause
    // (`… (usage: /title <name>)`); the coarser argument hint would repeat it.
    final hint = describesUsage(description, info.canonical)
        ? null
        : strings.argumentHint(info.argumentMode);
    return Semantics(
      container: true,
      liveRegion: true,
      child: Material(
        color: style.background,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.radius),
          side: BorderSide(color: style.border),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '/${info.canonical}',
                  style: base.copyWith(
                    color: style.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (info.isAlias)
                  Text(
                    strings.aliasOf('/${info.typed}', '/${info.canonical}'),
                    style: small,
                  ),
                const SizedBox(height: 4),
                Text(
                  description.isNotEmpty
                      ? description
                      : info.detailsPending
                      ? strings.loading
                      : strings.noDescription,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: base.copyWith(
                    color: description.isNotEmpty
                        ? style.foreground
                        : style.muted,
                  ),
                ),
                if (hint != null) ...[
                  const SizedBox(height: 4),
                  Text(hint, style: small),
                ],
                if (note != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    note!,
                    style: small.copyWith(fontStyle: FontStyle.italic),
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

/// Wraps a composer and wires slash-command highlighting into [controller].
///
/// Tapping (or clicking) inside the highlighted token shows a
/// [SlashCommandInfoCard] above it; moving the caret into the token from the
/// keyboard or a screen reader does the same. The card never takes focus and
/// is dismissed by a tap anywhere, any edit, the caret leaving the token,
/// focus loss, Esc, a [scope] change (chat switch), [suppressed] becoming
/// true (the command dropdown is open) or [timeout].
///
/// Detection uses raw pointer events and never joins the gesture arena, so
/// the field's own caret placement, selection and long-press behave as
/// before.
class SlashCommandInfoAnchor extends StatefulWidget {
  const SlashCommandInfoAnchor({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.resolver,
    required this.strings,
    required this.child,
    this.highlightStyleOf,
    this.style,
    this.note,
    this.suppressed = false,
    this.scope,
    this.refresh,
    this.onToken,
    this.timeout = const Duration(seconds: 8),
    this.gap = 6,
  });

  final SlashCommandHighlightController controller;
  final FocusNode focusNode;
  final SlashCommandTokenResolver resolver;
  final SlashCommandInfoStrings strings;
  final TextStyle Function(BuildContext context)? highlightStyleOf;
  final SlashCommandInfoStyle? style;
  final String? note;

  /// True while another surface (the command dropdown) already explains the
  /// token: no card is shown and an open one closes.
  final bool suppressed;

  /// Identity of the chat the composer belongs to; a change closes the card.
  final Object? scope;

  /// Fires when the resolver's answers may have changed (a catalogue load),
  /// so the field restyles even when its own widget was not rebuilt.
  final Listenable? refresh;

  /// Called when the draft starts with a slash token (on mount and on each
  /// edit), so the owner can load what [resolver] needs. Must be idempotent.
  final VoidCallback? onToken;

  final Duration timeout;

  /// Space between the card's bottom edge and the top of [child].
  final double gap;

  /// The composer's input container, including every control the card must
  /// leave uncovered; it must contain the [EditableText] driven by
  /// [controller]. The card sits above its top edge, near the token.
  final Widget child;

  @override
  State<SlashCommandInfoAnchor> createState() => _SlashCommandInfoAnchorState();
}

class _SlashCommandInfoAnchorState extends State<SlashCommandInfoAnchor> {
  final _portal = OverlayPortalController();
  final _link = LayerLink();
  SlashCommandToken? _shown;
  Offset _offset = Offset.zero;
  Timer? _timer;
  bool _routed = false;
  _PendingTap? _down;
  bool _pointerActive = false;
  bool _escapeLatch = false;
  late TextEditingValue _last;
  EditableTextState? _editable;

  bool get _visible => _shown != null;

  @override
  void initState() {
    super.initState();
    _attach(widget);
    _last = widget.controller.value;
    if (widget.controller.slashToken != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.controller.slashToken != null) {
          widget.onToken?.call();
        }
      });
    }
  }

  void _attach(SlashCommandInfoAnchor anchor) {
    anchor.controller
      ..resolver = anchor.resolver
      ..highlightStyleOf = anchor.highlightStyleOf;
    anchor.controller.addListener(_onValue);
    anchor.focusNode.addListener(_onFocus);
    anchor.refresh?.addListener(_onRefresh);
  }

  void _detach(SlashCommandInfoAnchor anchor) {
    anchor.controller.removeListener(_onValue);
    anchor.focusNode.removeListener(_onFocus);
    anchor.refresh?.removeListener(_onRefresh);
  }

  @override
  void didUpdateWidget(covariant SlashCommandInfoAnchor old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller ||
        old.focusNode != widget.focusNode ||
        old.refresh != widget.refresh) {
      _detach(old);
      _attach(widget);
      _last = widget.controller.value;
      _editable = null;
    } else {
      widget.controller
        ..resolver = widget.resolver
        ..highlightStyleOf = widget.highlightStyleOf;
    }
    if (old.scope != widget.scope || widget.suppressed) _hide();
  }

  @override
  void dispose() {
    _detach(widget);
    _timer?.cancel();
    _unroute();
    super.dispose();
  }

  void _onValue() {
    final value = widget.controller.value;
    final textChanged = value.text != _last.text;
    final selectionChanged = value.selection != _last.selection;
    _last = value;
    if (textChanged) {
      // Any edit closes the card; the token it described may be gone.
      _escapeLatch = false;
      _hide();
      if (widget.controller.slashToken != null) widget.onToken?.call();
      return;
    }
    if (!selectionChanged) return;
    final match = widget.controller.highlight;
    final caret = value.selection;
    final token = match?.token;
    final touching =
        token != null &&
        caret.isCollapsed &&
        caret.baseOffset >= token.start &&
        caret.baseOffset <= token.end;
    if (!touching) {
      _escapeLatch = false;
      _hide();
      return;
    }
    // Taps are decided from the pointer position, after the field has
    // placed its caret; only keyboard and accessibility caret moves open the
    // card from here.
    if (_pointerActive || _visible || _escapeLatch) return;
    if (caret.baseOffset < token.end && widget.focusNode.hasFocus) {
      _show(match!.token);
    }
  }

  void _onFocus() {
    if (!widget.focusNode.hasFocus) _hide();
  }

  void _onRefresh() {
    if (!mounted) return;
    void apply() {
      if (!mounted) return;
      // The field's text span is built from the resolver; rebuild just the
      // field (notifying the controller would look like an edit).
      final editable = _findEditable();
      if (editable != null && editable.mounted) {
        (editable.context as Element).markNeedsBuild();
      }
      if (_visible) {
        if (widget.controller.highlight?.token != _shown) {
          _hide();
        } else {
          setState(() {});
        }
      }
    }

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => apply());
    } else {
      apply();
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (_visible &&
        event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _escapeLatch = true;
      _hide();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerActive = true;
    if (_down != null) {
      // A second finger is a gesture, not a tap on the token.
      _down = null;
      return;
    }
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons != kPrimaryMouseButton) {
      return;
    }
    _down = _PendingTap(
      pointer: event.pointer,
      position: event.position,
      time: event.timeStamp,
      kind: event.kind,
      wasVisible: _visible,
    );
  }

  void _onPointerUp(PointerUpEvent event) {
    final down = _down;
    _down = null;
    final isTap =
        down != null &&
        down.pointer == event.pointer &&
        (event.position - down.position).distance <=
            computeHitSlop(down.kind, null) &&
        event.timeStamp - down.time < kLongPressTimeout;
    // Hit-test against the layout the user actually tapped: focusing the
    // field can move it (keyboard, toolbars) before the next frame.
    final token = isTap ? _tokenAt(down.position, down.kind) : null;
    // The field handles the tap after this listener; decide once its caret
    // and focus have settled.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _pointerActive = false;
      if (token != null) _onTap(token, wasVisible: down!.wasVisible);
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  /// The highlighted token under [position], if any.
  SlashCommandToken? _tokenAt(Offset position, PointerDeviceKind kind) {
    if (widget.suppressed) return null;
    final match = widget.controller.highlight;
    final editable = _findEditable()?.renderEditable;
    if (match == null || editable == null || !editable.attached) return null;
    final local = editable.globalToLocal(position);
    final boxes = editable.getBoxesForSelection(
      TextSelection(
        baseOffset: match.token.start,
        extentOffset: match.token.end,
      ),
    );
    final slop = kind == PointerDeviceKind.touch ? 6.0 : 2.0;
    final hit = boxes.any((box) => box.toRect().inflate(slop).contains(local));
    return hit ? match.token : null;
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _down = null;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _pointerActive = false;
    });
    SchedulerBinding.instance.ensureVisualUpdate();
  }

  void _onTap(SlashCommandToken token, {required bool wasVisible}) {
    if (!mounted || widget.suppressed) return;
    // The draft changed under the tap, or a double tap selected a word.
    if (widget.controller.highlight?.token != token) return;
    if (!widget.controller.selection.isCollapsed) return;
    // Tapping the token again closes the card it opened.
    if (wasVisible) return;
    _show(token);
  }

  void _show(SlashCommandToken token) {
    if (!mounted || widget.suppressed) return;
    final offset = _anchorOffset(token);
    if (offset == null) return;
    _escapeLatch = false;
    _timer?.cancel();
    if (!MediaQuery.accessibleNavigationOf(context)) {
      _timer = Timer(widget.timeout, _hide);
    }
    setState(() {
      _shown = token;
      _offset = offset;
    });
    _portal.show();
    _route();
  }

  void _hide() {
    _timer?.cancel();
    _timer = null;
    _unroute();
    if (!_visible) return;
    void apply() {
      if (!mounted) return;
      if (_shown != null) setState(() => _shown = null);
      _portal.hide();
    }

    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      // Hidden during a build (a scope or dropdown change): paint nothing now
      // and drop the overlay entry after the frame.
      _shown = null;
      SchedulerBinding.instance.addPostFrameCallback((_) => apply());
    } else {
      apply();
    }
  }

  void _route() {
    if (_routed) return;
    _routed = true;
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onGlobalPointer);
  }

  void _unroute() {
    if (!_routed) return;
    _routed = false;
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onGlobalPointer);
  }

  void _onGlobalPointer(PointerEvent event) {
    // Any new touch or click closes the card. A tap on the token itself was
    // recorded first, so it toggles instead of reopening.
    if (event is PointerDownEvent) _hide();
  }

  /// Where the card's bottom-left sits relative to this anchor: above the
  /// whole input container (so it never covers the field or a composer
  /// control), horizontally at the token, clamped to stay on screen.
  Offset? _anchorOffset(SlashCommandToken token) {
    final editable = _findEditable()?.renderEditable;
    final anchor = context.findRenderObject();
    if (editable == null ||
        !editable.attached ||
        anchor is! RenderBox ||
        !anchor.hasSize) {
      return null;
    }
    final boxes = editable.getBoxesForSelection(
      TextSelection(baseOffset: token.start, extentOffset: token.end),
    );
    if (boxes.isEmpty) return null;
    final first = boxes.first;
    final tokenLeft = anchor
        .globalToLocal(editable.localToGlobal(Offset(first.left, first.top)))
        .dx;
    final screen = MediaQuery.sizeOf(context).width;
    final origin = anchor.localToGlobal(Offset.zero).dx;
    final width = _maxWidth(context);
    const margin = 8.0;
    final minLeft = margin - origin;
    final maxLeft = math.max(minLeft, screen - margin - width - origin);
    return Offset(tokenLeft.clamp(minLeft, maxLeft), -widget.gap);
  }

  double _maxWidth(BuildContext context) =>
      math.max(0.0, math.min(280.0, MediaQuery.sizeOf(context).width - 16));

  EditableTextState? _findEditable() {
    final cached = _editable;
    if (cached != null &&
        cached.mounted &&
        cached.widget.controller == widget.controller) {
      return cached;
    }
    EditableTextState? found;
    void visit(Element element) {
      if (found != null) return;
      if (element is StatefulElement) {
        final state = element.state;
        if (state is EditableTextState &&
            state.widget.controller == widget.controller) {
          found = state;
          return;
        }
      }
      element.visitChildren(visit);
    }

    if (mounted) (context as Element).visitChildren(visit);
    return _editable = found;
  }

  Widget _overlay(BuildContext context) {
    final shown = _shown;
    final match = widget.controller.highlight;
    if (shown == null || match == null || match.token != shown) {
      return const SizedBox.shrink();
    }
    return Positioned(
      left: 0,
      top: 0,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        targetAnchor: Alignment.topLeft,
        followerAnchor: Alignment.bottomLeft,
        offset: _offset,
        // Taps on the card count as inside the field, so desktop does not
        // unfocus the composer.
        child: TextFieldTapRegion(
          child: SlashCommandInfoCard(
            key: const ValueKey('slash-command-info'),
            info: match.info,
            strings: widget.strings,
            style: widget.style ?? SlashCommandInfoStyle.fallback(context),
            note: widget.note,
            maxWidth: _maxWidth(context),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _overlay,
      child: CompositedTransformTarget(
        link: _link,
        child: Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: _onKey,
          child: Listener(
            onPointerDown: _onPointerDown,
            onPointerUp: _onPointerUp,
            onPointerCancel: _onPointerCancel,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _PendingTap {
  const _PendingTap({
    required this.pointer,
    required this.position,
    required this.time,
    required this.kind,
    required this.wasVisible,
  });

  final int pointer;
  final Offset position;
  final Duration time;
  final PointerDeviceKind kind;
  final bool wasVisible;
}

/// Which typed names the Classic composer highlights: exactly the ones its
/// send path would dispatch as commands.
///
/// `/new` and `/reset` are app-owned and always run. Every other name needs
/// the Desktop gateway's slash surface; with a loaded catalogue the
/// catalogue decides (the send gate), and before it loads (or when it
/// cannot) the reviewed [kSlashExecutableCommands] hint does, the same
/// fallback [SlashCommandController.isExecutable] uses. Unknown names stay
/// plain text.
SlashCommandTokenInfo? resolveChatSlashToken(
  String name, {
  required SlashCommandController commands,
  required bool available,
  required Set<String> localCommands,
}) {
  final bare = name.toLowerCase();
  final local = localCommands.contains(bare);
  if (!local && (!available || !commands.isExecutable(name))) return null;
  final catalog = commands.catalog;
  final known = catalog == null
      ? null
      : SlashCommandLookup.of(catalog).resolve(name);
  return known ??
      SlashCommandTokenInfo(
        typed: name,
        canonical: name,
        detailsPending:
            available && catalog == null && !commands.catalogUnavailable,
      );
}

/// Slash highlighting and the tap-for-details card for the Classic chat
/// composer.
class ChatComposerSlashInfo extends StatelessWidget {
  const ChatComposerSlashInfo({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.commands,
    required this.isAvailable,
    required this.dropdownOpen,
    required this.localCommands,
    required this.scope,
    required this.child,
  });

  final SlashCommandHighlightController controller;
  final FocusNode focusNode;
  final SlashCommandController commands;

  /// Whether the Desktop slash surface is up. Read only when a drafted
  /// command needs it, never on an ordinary rebuild: asking the gateway on
  /// every frame would add a call the composer did not make before.
  final ValueGetter<bool> isAvailable;
  final bool dropdownOpen;
  final Set<String> localCommands;
  final Object? scope;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final tokens = HermesTokens.of(context);
    return SlashCommandInfoAnchor(
      controller: controller,
      focusNode: focusNode,
      resolver: (name) => resolveChatSlashToken(
        name,
        commands: commands,
        available: isAvailable(),
        localCommands: localCommands,
      ),
      highlightStyleOf: (context) => TextStyle(
        color: HermesTokens.of(context).accent,
        fontWeight: FontWeight.w500,
      ),
      strings: SlashCommandInfoStrings(
        noDescription: l10n.slash_command_info_no_description,
        loading: l10n.slash_commands_loading,
        aliasOf: l10n.slash_command_info_alias,
        argumentsOptions: l10n.slash_command_info_arguments_options,
        argumentsText: l10n.slash_command_info_arguments_text,
        argumentsMixed: l10n.slash_command_info_arguments_mixed,
      ),
      style: SlashCommandInfoStyle(
        background: theme.colorScheme.surfaceContainerHigh,
        foreground: tokens.onSurface,
        muted: tokens.muted,
        accent: tokens.accent,
        border: tokens.border,
        textStyle: theme.textTheme.bodyMedium,
      ),
      suppressed: dropdownOpen,
      scope: scope,
      refresh: commands,
      // The send path consults the catalogue; load it as soon as a command
      // is drafted (typed, pasted or restored), as the dropdown does.
      onToken: () {
        if (isAvailable()) unawaited(commands.ensureCatalog());
      },
      child: child,
    );
  }
}
