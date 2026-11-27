import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../composer/emoji_completion.dart';
import '../composer/reference_completion.dart';
import '../composer/composer_commands.dart';

/// Chips for references already in the draft, plus @ / : / argument rows.
/// Suggestions come from [completePath] and [completeSlash]; a missing or
/// failed completer leaves the list empty rather than inventing entries.
///
/// Like Desktop's live completion adapter, a lookup waits [debounce] after
/// the last keystroke unless its answer is cached; answers are cached per
/// prefix so typing back over a prefix never asks the gateway again.
class ComposerReferenceAssist extends StatefulWidget {
  const ComposerReferenceAssist({
    super.key,
    required this.controller,
    this.completePath,
    this.completeSlash,
    this.cacheScope,
    this.debounce = const Duration(milliseconds: 60),
  });

  final TextEditingController controller;
  final Future<List<ReferenceSuggestion>> Function(String query)? completePath;
  final Future<ArgumentCompletion> Function(String text)? completeSlash;

  /// Answers belong to one session/gateway: a new scope empties the cache.
  final Object? cacheScope;
  final Duration debounce;

  @override
  State<ComposerReferenceAssist> createState() =>
      _ComposerReferenceAssistState();
}

class _ComposerReferenceAssistState extends State<ComposerReferenceAssist> {
  static const _cacheLimit = 64;

  List<ReferenceSuggestion> _references = const [];
  List<EmojiHit> _emoji = const [];
  ArgumentCompletion _arguments = ArgumentCompletion.empty;

  /// The line (up to the caret, leading spaces dropped) [_arguments]
  /// answered, and where it starts in the composer text.
  String _argumentLine = '';
  int _argumentShift = 0;
  int _generation = 0;
  Timer? _debounce;
  // Map literals are insertion-ordered: the oldest key goes first.
  final _pathCache = <String, List<ReferenceSuggestion>>{};
  final _slashCache = <String, ArgumentCompletion>{};

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
    _collect(notify: false);
  }

  @override
  void didUpdateWidget(covariant ComposerReferenceAssist oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cacheScope != widget.cacheScope) {
      _pathCache.clear();
      _slashCache.clear();
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_refresh);
      widget.controller.addListener(_refresh);
      _refresh();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => _collect(notify: true);

  static void _remember<T>(Map<String, T> cache, String key, T v) {
    cache.remove(key);
    cache[key] = v;
    while (cache.length > _cacheLimit) {
      cache.remove(cache.keys.first);
    }
  }

  void _collect({required bool notify}) {
    final value = widget.controller.value;
    final caret = value.selection.isValid
        ? value.selection.extentOffset.clamp(0, value.text.length)
        : value.text.length;
    final at = activeTrigger(value.text, caret, '@');
    final emoji = at == null ? activeTrigger(value.text, caret, ':') : null;
    final line = value.text.substring(0, caret);
    final slash = _argumentQuery(line);
    final shift = line.length - line.trimLeft().length;
    final generation = ++_generation;
    _debounce?.cancel();
    final references = at == null
        ? const <ReferenceSuggestion>[]
        : _pathCache[at.query] ?? starterSuggestions(at.query);
    final emojiHits = emoji == null
        ? const <EmojiHit>[]
        : emojiMatches(emoji.query);
    final cachedSlash = slash == null ? null : _slashCache[slash.toLowerCase()];
    void apply() {
      _references = references;
      _emoji = emojiHits;
      if (slash == null) {
        _arguments = ArgumentCompletion.empty;
      } else if (cachedSlash != null) {
        _arguments = cachedSlash;
        _argumentLine = slash;
        _argumentShift = shift;
      } else if (_argumentLine != slash) {
        // Rows for another line would replace the wrong span.
        _arguments = ArgumentCompletion.empty;
      }
    }

    if (notify) {
      setState(apply);
    } else {
      apply();
    }
    final complete = widget.completePath;
    final needPath =
        at != null && complete != null && !_pathCache.containsKey(at.query);
    final slashComplete = widget.completeSlash;
    final needSlash =
        slash != null && slashComplete != null && cachedSlash == null;
    if (!needPath && !needSlash) return;
    void run() {
      if (!mounted || generation != _generation) return;
      if (needPath) {
        complete(at.query).then(
          (rows) {
            _remember(_pathCache, at.query, rows);
            if (!mounted || generation != _generation) return;
            setState(() {
              _references = rows.isEmpty ? starterSuggestions(at.query) : rows;
            });
          },
          onError: (_) {
            if (!mounted || generation != _generation) return;
            setState(() => _references = starterSuggestions(at.query));
          },
        );
      }
      if (needSlash) {
        slashComplete(slash).then(
          (answer) {
            _remember(_slashCache, slash.toLowerCase(), answer);
            if (!mounted || generation != _generation) return;
            setState(() {
              _arguments = answer;
              _argumentLine = slash;
              _argumentShift = shift;
            });
          },
          onError: (_) {
            if (!mounted || generation != _generation) return;
            setState(() => _arguments = ArgumentCompletion.empty);
          },
        );
      }
    }

    _debounce = Timer(widget.debounce, run);
  }

  void _apply(int start, int end, String insert) {
    final text = widget.controller.text;
    final next = applyInsert(text, start, end, insert);
    final added = next.length - (text.length - (end - start));
    widget.controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(
        offset: (start + added).clamp(0, next.length),
      ),
    );
  }

  /// The `/command arg…` line the caret is in, without leading spaces; null
  /// before the command has an argument.
  String? _argumentQuery(String line) {
    final trimmed = line.trimLeft();
    if (!trimmed.startsWith('/') || !trimmed.contains(' ')) return null;
    if (trimmed.contains('\n')) return null;
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    final chips = referenceChips(widget.controller.text);
    final arguments = _arguments.hints;
    if (chips.isEmpty &&
        _references.isEmpty &&
        _emoji.isEmpty &&
        arguments.isEmpty) {
      return const SizedBox.shrink();
    }
    final value = widget.controller.value;
    final caret = value.selection.isValid
        ? value.selection.extentOffset
        : value.text.length;
    final at = activeTrigger(value.text, caret, '@');
    final emoji = at == null ? activeTrigger(value.text, caret, ':') : null;
    // Rows are ListTiles: their ink needs a Material between them and the
    // composer's decorated pill.
    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (chips.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final chip in chips)
                  InputChip(
                    label: Text(chip.raw, overflow: TextOverflow.ellipsis),
                    onPressed: () => _chipMenu(context, l10n, chip),
                    onDeleted: () => _remove(chip),
                  ),
              ],
            ),
          if (_references.isNotEmpty && at != null)
            _rows(
              _references.map(
                (row) => (
                  row.label,
                  row.meta,
                  () => _apply(at.start, at.end, row.insert),
                ),
              ),
            ),
          if (_emoji.isNotEmpty && emoji != null)
            _rows(
              _emoji.map(
                (row) => (
                  '${row.character} :${row.code}',
                  '',
                  () => _apply(emoji.start, emoji.end, row.character),
                ),
              ),
            ),
          if (arguments.isNotEmpty)
            _rows(
              arguments.map(
                (row) => (
                  row.label,
                  row.label == row.text ? '' : row.text,
                  () => _replaceArgument(row),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Puts [hint] in place of the argument being typed: from the gateway's
  /// `replace_from` to the caret. The command before it and anything after
  /// the caret stay.
  void _replaceArgument(ArgumentHint hint) {
    final value = widget.controller.value;
    final text = value.text;
    final caret = value.selection.isValid
        ? value.selection.extentOffset.clamp(0, text.length)
        : text.length;
    final start = _argumentShift;
    final end = start + _argumentLine.length;
    if (end != caret || text.substring(start, end) != _argumentLine) {
      return; // the line changed under the rows; they no longer apply
    }
    final line = _arguments.apply(_argumentLine, hint);
    final next = text.replaceRange(start, end, line);
    widget.controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: start + line.length),
    );
  }

  void _remove(ReferenceChip chip) {
    final next = removeChip(widget.controller.text, chip);
    widget.controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
  }

  Future<void> _chipMenu(
    BuildContext context,
    AppLocalizations l10n,
    ReferenceChip chip,
  ) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.composer_reference_copy),
              onTap: () => Navigator.pop(context, 'copy'),
            ),
            ListTile(
              title: Text(l10n.composer_reference_remove),
              onTap: () => Navigator.pop(context, 'remove'),
            ),
          ],
        ),
      ),
    );
    if (!mounted) return;
    if (action == 'copy') {
      await Clipboard.setData(ClipboardData(text: chip.value));
    } else if (action == 'remove') {
      _remove(chip);
    }
  }

  Widget _rows(Iterable<(String, String, VoidCallback)> rows) {
    return Column(
      children: [
        for (final row in rows.take(8))
          ListTile(
            dense: true,
            title: Text(row.$1),
            subtitle: row.$2.isEmpty ? null : Text(row.$2),
            onTap: row.$3,
          ),
      ],
    );
  }
}
