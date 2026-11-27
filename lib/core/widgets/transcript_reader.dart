import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'transcript_body.dart';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [index] is the actual builder index (including paging/status rows), not
/// the chronological ordinal. [id] survives list growth while seeking.
typedef TranscriptEntry = ({Object id, int index, String text, bool prompt});
typedef _TimelineChoice = ({TranscriptEntry? prompt});
typedef _Hit = ({Object id, int occurrence, int offset});

String readingPositionKey(
  String surface,
  String connection,
  String? profile,
  String session,
) =>
    'transcript.reading.${jsonEncode([surface, connection, profile, session])}';

Widget transcriptShortcuts(
  GlobalKey<TranscriptReaderState> key,
  Widget child,
) => Focus(
  // A full-chat semantic focus node would absorb standalone controls such as
  // Classic’s Go to end into a viewport-sized tap target for screen readers.
  includeSemantics: false,
  skipTraversal: true,
  autofocus: true,
  onKeyEvent: (node, event) {
    final bindings = <ShortcutActivator, VoidCallback>{
      for (final meta in [true, false]) ...{
        SingleActivator(
          LogicalKeyboardKey.keyF,
          meta: meta,
          control: !meta,
        ): () =>
            key.currentState?.open(),
        SingleActivator(
          LogicalKeyboardKey.keyG,
          meta: meta,
          control: !meta,
        ): () =>
            key.currentState?.step(1),
        SingleActivator(
          LogicalKeyboardKey.keyG,
          meta: meta,
          control: !meta,
          shift: true,
        ): () =>
            key.currentState?.step(-1),
      },
    };
    for (final entry in bindings.entries) {
      if (entry.key.accepts(event, HardwareKeyboard.instance) &&
          key.currentState != null) {
        entry.value();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  },
  child: child,
);

class TranscriptReader extends StatefulWidget {
  const TranscriptReader({
    super.key,
    required this.scroll,
    required this.entries,
    required this.storageKey,
    this.owner,
    required this.child,
    this.reverse = false,
    this.onNavigate,
    this.onLatest,
  });
  final ScrollController scroll;
  final List<TranscriptEntry> Function() entries;
  final String? storageKey;
  final Object? owner;
  final bool reverse;
  final VoidCallback? onNavigate;
  final VoidCallback? onLatest;
  final Widget child;
  @override
  State<TranscriptReader> createState() => TranscriptReaderState();
}

class TranscriptReaderState extends State<TranscriptReader> {
  final _list = GlobalKey();
  final _field = TextEditingController();
  final _focus = FocusNode();
  bool _open = false, _userScrolling = false;
  int _generation = 0;
  Object? _selectedId;
  int _occurrence = 0;
  bool _passageUnavailable = false;
  SharedPreferences? _prefs;
  late String? _scope;
  DialogRoute<_TimelineChoice>? _timeline;

  @override
  void initState() {
    super.initState();
    _resetScope();
  }

  @override
  void didUpdateWidget(covariant TranscriptReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.owner != widget.owner ||
        oldWidget.storageKey != widget.storageKey ||
        oldWidget.scroll != widget.scroll) {
      _resetScope();
    }
  }

  // A modal lives on the navigator, not under this State. Invalidate its
  // callbacks now and remove that exact route after widget-tree teardown.
  void _dismissTimeline() {
    final route = _timeline;
    _timeline = null;
    if (route == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (route.isActive) route.navigator?.removeRoute(route);
    });
  }

  void _resetScope() {
    _dismissTimeline();
    final epoch = ++_generation;
    _scope = widget.storageKey;
    _open = false;
    _field.clear();
    _selectedId = null;
    _passageUnavailable = false;
    _userScrolling = false;
    unawaited(_restore(epoch));
  }

  Future<void> _restore(int epoch) async {
    final key = _scope;
    if (key == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted || key != _scope) return;
      _prefs = prefs;
      final saved = prefs.getDouble(key);
      if (saved == null || saved <= 1 || !saved.isFinite) return;
      // A direct gesture or a newer destination always wins over hydration.
      for (int frame = 0; frame < 8; frame++) {
        await WidgetsBinding.instance.endOfFrame;
        if (!mounted || epoch != _generation) return;
        if (!widget.scroll.hasClients) continue;
        final p = widget.scroll.position;
        if (!p.hasContentDimensions || p.maxScrollExtent <= 0) continue;
        widget.onNavigate?.call();
        final target = (widget.reverse ? saved : p.maxScrollExtent - saved)
            .clamp(p.minScrollExtent, p.maxScrollExtent);
        if ((p.pixels - target).abs() < 1) break;
        widget.scroll.jumpTo(target.toDouble());
      }
    } catch (_) {
      /* Position is optional; never block transcript loading. */
    }
  }

  void rememberLatest() {
    ++_generation;
    final key = _scope;
    if (key != null && _prefs != null) {
      unawaited(_prefs!.remove(key).catchError((Object _) => false));
    }
  }

  void _latest() {
    _close();
    rememberLatest();
    if (widget.onLatest case final go?) {
      go();
    } else if (widget.scroll.hasClients) {
      widget.scroll.jumpTo(widget.scroll.position.minScrollExtent);
    }
  }

  void _save() {
    if (!widget.scroll.hasClients || _scope == null) return;
    final p = widget.scroll.position;
    final distance = widget.reverse ? p.pixels : p.extentAfter;
    final prefs = _prefs;
    if (prefs != null && distance.isFinite) {
      unawaited(
        prefs
            .setDouble(_scope!, math.max(0, distance))
            .catchError((Object _) => false),
      );
    }
  }

  @override
  void dispose() {
    _dismissTimeline();
    _field.dispose();
    _focus.dispose();
    super.dispose();
  }

  void open() {
    setState(() => _open = true);
    _focus.requestFocus();
  }

  void _close() {
    ++_generation;
    setState(() {
      _open = false;
      _selectedId = null;
      _field.clear();
      _passageUnavailable = false;
    });
  }

  List<_Hit> _matches(List<TranscriptEntry> rows) {
    final q = _field.text;
    if (q.isEmpty) return const [];
    final pattern = RegExp(
      RegExp.escape(q),
      caseSensitive: false,
      unicode: true,
    );
    return [
      for (final row in rows)
        for (final (i, m) in pattern.allMatches(row.text).indexed)
          (id: row.id, occurrence: i, offset: m.start),
    ];
  }

  void _queryChanged(String _) {
    _selectedId = null;
    _occurrence = 0;
    step(1);
  }

  void step(int delta) {
    if (!_open) {
      open();
      return;
    }
    final hits = _matches(widget.entries());
    if (hits.isEmpty) {
      ++_generation;
      setState(() {
        _selectedId = null;
        _passageUnavailable = false;
      });
      return;
    }
    final at = hits.indexWhere(
      (h) => h.id == _selectedId && h.occurrence == _occurrence,
    );
    final hit =
        hits[(at < 0 ? (delta < 0 ? hits.length - 1 : 0) : at + delta) %
            hits.length];
    _select(hit.id, hit.occurrence);
  }

  void _select(Object id, int occurrence) {
    widget.onNavigate?.call();
    setState(() {
      _selectedId = id;
      _occurrence = occurrence;
      _passageUnavailable = false;
    });
    unawaited(_reveal(++_generation, id));
  }

  RenderSliverMultiBoxAdaptor? _sliver() {
    RenderSliverMultiBoxAdaptor? result;
    void visit(RenderObject node) {
      if (result != null) return;
      if (node is RenderSliverMultiBoxAdaptor) {
        result = node;
      } else {
        node.visitChildren(visit);
      }
    }

    final root = _list.currentContext?.findRenderObject();
    if (root != null) visit(root);
    return result;
  }

  RenderBox? _boxAt(RenderSliverMultiBoxAdaptor sliver, int index) {
    for (
      var box = sliver.firstChild;
      box != null;
      box = sliver.childAfter(box)
    ) {
      if (sliver.indexOf(box) == index) return box;
    }
    return null;
  }

  /// Prefer the matched glyphs, not the top of a potentially tall reply.
  ({RenderBox box, List<Rect> rects})? _glyphs(RenderBox row) {
    final query = _field.text;
    if (query.isEmpty) return null;
    final pattern = RegExp(
      RegExp.escape(query),
      caseSensitive: false,
      unicode: true,
    );
    var ordinal = 0;
    ({RenderBox box, List<Rect> rects})? result;
    void visit(RenderObject node) {
      if (result != null) return;
      if (node case RenderParagraph() || RenderEditable()) {
        final text = node is RenderParagraph
            ? node.text.toPlainText()
            : (node as RenderEditable).text?.toPlainText() ?? '';
        for (final m in pattern.allMatches(text)) {
          if (ordinal++ != _occurrence) continue;
          final selection = TextSelection(
            baseOffset: m.start,
            extentOffset: m.end,
          );
          final boxes = node is RenderParagraph
              ? node.getBoxesForSelection(selection)
              : (node as RenderEditable).getBoxesForSelection(selection);
          if (boxes.isNotEmpty) {
            result = (
              box: node as RenderBox,
              rects: boxes.map((b) => b.toRect()).toList(),
            );
          }
          return;
        }
      } else {
        node.visitChildren(visit);
      }
    }

    void findBody(RenderObject node) {
      if (result != null) return;
      if (isTranscriptBody(node)) {
        visit(node);
      } else {
        node.visitChildren(findBody);
      }
    }

    findBody(row);
    return result;
  }

  Future<void> _reveal(int epoch, Object id) async {
    double? lower, upper;
    for (var frame = 0; frame < 48; frame++) {
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted || epoch != _generation || !widget.scroll.hasClients) return;
      final target = widget.entries().where((e) => e.id == id).firstOrNull;
      final sliver = _sliver();
      if (target == null || sliver == null || sliver.firstChild == null) break;
      final pos = widget.scroll.position;
      final row = _boxAt(sliver, target.index);
      if (row != null) {
        final glyphs = _glyphs(row);
        final box = glyphs?.box ?? row;
        final off = RenderAbstractViewport.of(
          box,
        ).getOffsetToReveal(box, 0.32, rect: glyphs?.rects.first).offset;
        pos.jumpTo(
          off.clamp(pos.minScrollExtent, pos.maxScrollExtent).toDouble(),
        );
        _save();
        return;
      }
      // Seek across lazy variable-height bubbles without eagerly building
      // them. A crossed target brackets the next estimate in pixel space.
      final first = sliver.indexOf(sliver.firstChild!),
          last = sliver.indexOf(sliver.lastChild!);
      final forward = target.index > last;
      if (forward) {
        lower = pos.pixels;
      } else {
        upper = pos.pixels;
      }
      final mean =
          (sliver.childScrollOffset(sliver.lastChild!)! +
              sliver.lastChild!.size.height -
              sliver.childScrollOffset(sliver.firstChild!)!) /
          (last - first + 1);
      final guess = lower != null && upper != null
          ? (lower + upper) / 2
          : pos.pixels +
                (forward ? 1 : -1) *
                    math.max(
                      pos.viewportDimension,
                      (target.index - (forward ? last : first)).abs() * mean,
                    );
      final next = guess
          .clamp(pos.minScrollExtent, pos.maxScrollExtent)
          .toDouble();
      if ((next - pos.pixels).abs() < 0.5) break;
      pos.jumpTo(next);
    }
    if (mounted && epoch == _generation) {
      setState(() => _passageUnavailable = true);
    }
  }

  Future<void> _prompts() async {
    final rows = widget.entries().where((e) => e.prompt).toList();
    if (_timeline != null) return;
    late final DialogRoute<_TimelineChoice> route;
    void choose(TranscriptEntry? prompt) {
      if (mounted && identical(_timeline, route) && route.isCurrent) {
        route.navigator!.pop<_TimelineChoice>((prompt: prompt));
      }
    }

    route = DialogRoute<_TimelineChoice>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          context.sharedL10n.release_core_transcript_reader_loaded_prompts,
        ),
        actions: [
          TextButton.icon(
            onPressed: () => choose(null),
            icon: const Icon(Icons.vertical_align_bottom),
            label: Text(
              context.sharedL10n.release_core_transcript_reader_jump_to_latest,
            ),
          ),
        ],
        content: SizedBox(
          width: 400,
          height: 320,
          child: rows.isEmpty
              ? Text(
                  context
                      .sharedL10n
                      .release_core_transcript_reader_no_prompts_loaded,
                )
              : ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (_, i) => ListTile(
                    leading: Text('${i + 1}'),
                    title: Text(
                      rows[i].text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => choose(rows[i]),
                  ),
                ),
        ),
      ),
    );
    _timeline = route;
    final choice = await Navigator.of(context, rootNavigator: true).push(route);
    if (!mounted || !identical(_timeline, route)) return;
    _timeline = null;
    if (choice == null) return;
    final prompt = choice.prompt;
    if (prompt == null) {
      _latest();
    } else {
      _field.clear();
      _select(prompt.id, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _open ? widget.entries() : const <TranscriptEntry>[];
    final hits = _open ? _matches(rows) : const <_Hit>[];
    final at = hits.indexWhere(
      (h) => h.id == _selectedId && h.occurrence == _occurrence,
    );
    final selected = rows.where((e) => e.id == _selectedId).firstOrNull;
    // The active layout's scheme (Classic or NextGen), never a fixed brand.
    final highlight = Theme.of(
      context,
    ).colorScheme.tertiary.withValues(alpha: 0.33);
    return Column(
      children: [
        if (_open)
          Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CallbackShortcuts(
                        bindings: {
                          const SingleActivator(LogicalKeyboardKey.escape):
                              _close,
                          const SingleActivator(
                            LogicalKeyboardKey.enter,
                            shift: true,
                          ): () =>
                              step(-1),
                        },
                        child: TextField(
                          key: const Key('transcript-query'),
                          controller: _field,
                          focusNode: _focus,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) {
                            step(1);
                            _focus.requestFocus();
                          },
                          onChanged: _queryChanged,
                          decoration: InputDecoration(
                            hintText: context
                                .sharedL10n
                                .release_core_transcript_reader_find_in_loaded_messages,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    Text(_field.text.isEmpty ? '' : '${at + 1}/${hits.length}'),
                    IconButton(
                      tooltip: context
                          .sharedL10n
                          .release_core_transcript_reader_previous_match,
                      onPressed: hits.isEmpty ? null : () => step(-1),
                      icon: const Icon(Icons.keyboard_arrow_up),
                    ),
                    IconButton(
                      tooltip: context
                          .sharedL10n
                          .release_core_transcript_reader_next_match,
                      onPressed: hits.isEmpty ? null : () => step(1),
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                    IconButton(
                      tooltip: context
                          .sharedL10n
                          .release_core_transcript_reader_prompt_timeline,
                      onPressed: _prompts,
                      icon: const Icon(Icons.format_list_numbered),
                    ),
                    IconButton(
                      tooltip: context
                          .sharedL10n
                          .release_core_transcript_reader_close_find,
                      onPressed: _close,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                if (_passageUnavailable)
                  Text(
                    context
                        .sharedL10n
                        .release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded,
                  ),
              ],
            ),
          ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.depth != 0) return false;
              if (n is UserScrollNotification &&
                  n.direction != ScrollDirection.idle) {
                _userScrolling = true;
                ++_generation;
              }
              if (n is ScrollEndNotification && _userScrolling) {
                _save();
                _userScrolling = false;
              }
              return false;
            },
            child: ClipRect(
              child: CustomPaint(
                key: _list,
                foregroundPainter: selected == null
                    ? null
                    : _Marker(widget.scroll, (canvas) {
                        final sliver = _sliver();
                        if (sliver == null) return;
                        final row = _boxAt(sliver, selected.index);
                        if (row == null) return;
                        final root = _list.currentContext?.findRenderObject();
                        if (root == null) return;
                        final glyphs = _glyphs(row);
                        final box = glyphs?.box ?? row;
                        final transform = box.getTransformTo(root);
                        final paint = Paint()..color = highlight;
                        for (final rect
                            in glyphs?.rects ??
                                [Rect.fromLTWH(0, 0, 4, row.size.height)]) {
                          canvas.drawRect(
                            MatrixUtils.transformRect(transform, rect),
                            paint,
                          );
                        }
                      }),
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Marker extends CustomPainter {
  _Marker(Listenable scroll, this.draw) : super(repaint: scroll);
  final void Function(Canvas) draw;
  @override
  void paint(Canvas canvas, Size size) => draw(canvas);
  @override
  bool shouldRepaint(_Marker old) => true;
}
