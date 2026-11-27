/// App-wide command palette overlay.
///
/// Rendered by both shells (Classic and NextGen) against the same widget so
/// behavior is identical. On wide screens it presents as a centered dialog;
/// on narrow panes (< 480 px) it presents as a full-screen takeover — the
/// narrow-device alternative is the same code path, not a separate widget.
///
/// The palette never executes a command on open; selection is reported via
/// [onSelected]. Actions are supplied by the caller.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';

/// Opens [CommandPalette] as a centered dialog on wide screens and a
/// full-screen route on narrow panes (< 480 px).
Future<void> showAppCommandPalette(
  BuildContext context, {
  required List<PaletteAction> actions,
  required ValueChanged<PaletteAction> onSelected,
}) {
  final isNarrow = MediaQuery.sizeOf(context).width < 480;
  if (isNarrow) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) =>
            CommandPalette(actions: actions, onSelected: onSelected),
      ),
    );
  }
  return showDialog<void>(
    context: context,
    builder: (_) => CommandPalette(actions: actions, onSelected: onSelected),
  );
}

/// One selectable action in the palette.
class PaletteAction {
  const PaletteAction({
    required this.id,
    required this.label,
    required this.icon,
    this.hint,
    this.keywords = const [],
  });

  final String id;
  final String label;
  final IconData icon;
  final String? hint;
  final List<String> keywords;
}

/// Shared command palette. Render-only; selection and navigation are delegated.
class CommandPalette extends StatefulWidget {
  const CommandPalette({
    required this.actions,
    required this.onSelected,
    super.key,
  });

  final List<PaletteAction> actions;
  final ValueChanged<PaletteAction> onSelected;

  @override
  State<CommandPalette> createState() => CommandPaletteState();
}

class CommandPaletteState extends State<CommandPalette> {
  /// Tallest the dialog's action list grows on a roomy screen.
  static const double maxListHeight = 320;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final GlobalKey _selectedKey = GlobalKey();
  List<PaletteAction> _filtered = const [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _filter('');
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _filter(String text) {
    final query = text.trim().toLowerCase();
    if (query.isEmpty) {
      _filtered = List<PaletteAction>.of(widget.actions);
    } else {
      _filtered = widget.actions.where((action) {
        final haystack = <String>[
          action.label,
          if (action.hint != null) action.hint!,
          ...action.keywords,
        ].join(' ').toLowerCase();
        return haystack.contains(query);
      }).toList();
    }
    _selectedIndex = _filtered.isEmpty
        ? 0
        : _selectedIndex.clamp(0, _filtered.length - 1);
    setState(() {});
  }

  void _close() {
    Navigator.of(context).pop();
  }

  void _select(PaletteAction action) {
    _close();
    widget.onSelected(action);
  }

  void _selectCurrent() {
    if (_filtered.isEmpty) return;
    _select(_filtered[_selectedIndex]);
  }

  void _moveSelection(int delta) {
    if (_filtered.isEmpty) return;
    final next = (_selectedIndex + delta) % _filtered.length;
    setState(() => _selectedIndex = next < 0 ? next + _filtered.length : next);
    // The list can be short (landscape phone, keyboard up): keep the
    // keyboard selection on screen.
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelection());
  }

  void _revealSelection() {
    if (!mounted || !_scroll.hasClients) return;
    final item = _selectedKey.currentContext;
    if (item != null) {
      Scrollable.ensureVisible(
        item,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
      Scrollable.ensureVisible(
        item,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
      return;
    }
    // Not built yet (lazy list): jump near it, then align precisely.
    final position = _scroll.position;
    final fraction = _filtered.length <= 1
        ? 0.0
        : _selectedIndex / (_filtered.length - 1);
    _scroll.jumpTo(position.maxScrollExtent * fraction);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final built = _selectedKey.currentContext;
      if (mounted && built != null) Scrollable.ensureVisible(built);
    });
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _moveSelection(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _moveSelection(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter:
        _selectCurrent();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        _close();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNarrow = MediaQuery.of(context).size.width < 480;
    final body = _buildBody(context, theme, isNarrow: isNarrow);
    return Focus(
      autofocus: true,
      onKeyEvent: _handleKey,
      child: isNarrow
          ? Scaffold(
              backgroundColor: theme.colorScheme.surface,
              body: SafeArea(child: body),
            )
          : Dialog(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: body,
                ),
              ),
            ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme, {
    required bool isNarrow,
  }) {
    final list = _filtered.isEmpty
        ? Center(child: Text(context.sharedL10n.palette_no_matches))
        : ListView.builder(
            key: const Key('app-command-palette-list'),
            controller: _scroll,
            itemCount: _filtered.length,
            itemBuilder: (context, index) {
              final action = _filtered[index];
              final selected = index == _selectedIndex;
              return Material(
                key: selected ? _selectedKey : null,
                color: selected
                    ? theme.colorScheme.surfaceContainerHighest
                    : Colors.transparent,
                child: InkWell(
                  onTap: () => _select(action),
                  onHover: (hovered) {
                    if (hovered) {
                      setState(() => _selectedIndex = index);
                    }
                  },
                  child: ListTile(
                    leading: Icon(action.icon),
                    title: Text(action.label),
                    subtitle: action.hint == null ? null : Text(action.hint!),
                    trailing: selected ? const Icon(Icons.arrow_forward) : null,
                  ),
                ),
              );
            },
          );
    final header = Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: const Key('app-command-palette-query'),
              controller: _controller,
              autofocus: true,
              onChanged: _filter,
              onSubmitted: (_) => _selectCurrent(),
              decoration: InputDecoration(
                hintText: context.sharedL10n.palette_filter_hint,
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
              ),
            ),
          ),
          if (isNarrow)
            IconButton(
              tooltip: context.sharedL10n.close,
              icon: const Icon(Icons.close),
              onPressed: _close,
            ),
        ],
      ),
    );
    final footer = Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      child: Wrap(
        spacing: 10,
        runSpacing: 2,
        children: [
          for (final hint in [
            context.sharedL10n.palette_keys_move,
            context.sharedL10n.palette_keys_run,
            context.sharedL10n.palette_keys_close,
          ])
            Text(hint, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
    if (isNarrow) {
      // Full-screen takeover: the Scaffold already resizes above the
      // keyboard, so the list takes whatever is left.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          Expanded(child: list),
          footer,
        ],
      );
    }
    // Dialog: it already sits above the keyboard (Dialog pads by the
    // MediaQuery view insets), so size the list from the height that is left
    // instead of a fixed 320 px. Landscape phones and tablets with the
    // keyboard up get a shorter, scrolling list; very short windows drop the
    // key hints and, at worst, scroll the whole palette.
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        if (height.isFinite && height < 120) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                header,
                SizedBox(height: 96, child: list),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            header,
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: maxListHeight),
                child: list,
              ),
            ),
            if (!height.isFinite || height >= 240) footer,
          ],
        );
      },
    );
  }
}
