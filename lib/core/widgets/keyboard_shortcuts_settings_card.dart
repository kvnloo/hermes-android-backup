/// Shared remappable keyboard shortcuts card + conflict inspector for Classic
/// and NextGen, with a narrow-device / touch-friendly chord editor fallback.
library;

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../services/shortcuts_store.dart' as shortcuts_store;
import 'desktop_shortcuts.dart' show desktopShortcutsAvailable;

/// The localised name of a bindable action.
String shortcutActionLabel(
  AppLocalizations l10n,
  shortcuts_store.ShortcutAction action,
) => switch (action) {
  shortcuts_store.ShortcutAction.commandPalette =>
    l10n.shortcut_action_command_palette,
  shortcuts_store.ShortcutAction.newChat => l10n.shortcut_action_new_chat,
  shortcuts_store.ShortcutAction.search => l10n.shortcut_action_search,
  shortcuts_store.ShortcutAction.settings => l10n.shortcut_action_settings,
  shortcuts_store.ShortcutAction.tab1 => l10n.shortcut_action_go_to_tab(1),
  shortcuts_store.ShortcutAction.tab2 => l10n.shortcut_action_go_to_tab(2),
  shortcuts_store.ShortcutAction.tab3 => l10n.shortcut_action_go_to_tab(3),
  shortcuts_store.ShortcutAction.tab4 => l10n.shortcut_action_go_to_tab(4),
};

class KeyboardShortcutsSettingsCard extends StatelessWidget {
  const KeyboardShortcutsSettingsCard({required this.preferences, super.key});

  final SharedPreferences preferences;

  bool get _appleSymbols =>
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> _rebind(
    BuildContext context,
    shortcuts_store.ShortcutsStore store,
    shortcuts_store.ShortcutAction action,
  ) async {
    final current = store.chordFor(action);
    final isNarrow = MediaQuery.sizeOf(context).width < 480;
    final editor = _ShortcutChordEditor(
      action: action,
      initial: current,
      fullscreen: isNarrow,
    );
    final next = isNarrow
        ? await Navigator.of(context).push<shortcuts_store.KeyChord>(
            MaterialPageRoute<shortcuts_store.KeyChord>(
              fullscreenDialog: true,
              builder: (_) => editor,
            ),
          )
        : await showDialog<shortcuts_store.KeyChord>(
            context: context,
            builder: (_) => editor,
          );
    if (next == null) return;
    await store.setChord(action, next);
  }

  @override
  Widget build(BuildContext context) {
    // Bindings only fire on the desktop runners; never show a dead control.
    if (!desktopShortcutsAvailable()) return const SizedBox.shrink();
    final l10n = context.sharedL10n;
    final theme = Theme.of(context);
    final store = shortcuts_store.ShortcutsStore(preferences);
    final apple = _appleSymbols;
    String chordText(shortcuts_store.KeyChord chord) =>
        shortcuts_store.formatKeyChord(chord, appleSymbols: apple);
    return Card(
      key: const Key('keyboard-shortcuts-settings-card'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<int>(
          valueListenable: shortcuts_store.shortcutsStoreChanges,
          builder: (context, _, _) {
            final customMap = store.readMap();
            final plan = store.plan();
            final conflicts = plan.conflicts;
            // Custom chords that take a text-editing command (copy, paste,
            // cut, undo, redo, select all) away from text fields.
            final editing = [
              for (final action in shortcuts_store.ShortcutRegistry.actions)
                if (customMap.containsKey(action.id) &&
                    !plan.reverted.contains(action) &&
                    shortcuts_store.isTextEditingChord(store.chordFor(action)))
                  action,
            ];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.keyboard_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.keyboard_shortcuts_title,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    if (customMap.isNotEmpty)
                      TextButton(
                        key: const Key('shortcuts-reset-all'),
                        onPressed: store.resetToDefaults,
                        child: Text(l10n.shortcuts_reset_all),
                      ),
                  ],
                ),
                if (conflicts.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    key: const Key('shortcuts-conflict-banner'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final conflict in conflicts)
                          Text(
                            l10n.shortcuts_conflict(
                              shortcutActionLabel(l10n, conflict.first),
                              shortcutActionLabel(l10n, conflict.second),
                              chordText(conflict.chord),
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                if (editing.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    key: const Key('shortcuts-text-editing-warning'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final action in editing)
                          Text(
                            l10n.shortcuts_text_editing_in_use(
                              shortcutActionLabel(l10n, action),
                              chordText(store.chordFor(action)),
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onTertiaryContainer,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                for (final action in shortcuts_store.ShortcutRegistry.actions)
                  Builder(
                    builder: (context) {
                      final chord = store.chordFor(action);
                      final isCustom = customMap.containsKey(action.id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(shortcutActionLabel(l10n, action)),
                            ),
                            ActionChip(
                              key: Key('shortcut-rebind-${action.id}'),
                              label: Text(
                                shortcuts_store.formatKeyChord(
                                  chord,
                                  appleSymbols: apple,
                                ),
                              ),
                              onPressed: () => _rebind(context, store, action),
                            ),
                            if (isCustom)
                              IconButton(
                                key: Key('shortcut-reset-${action.id}'),
                                tooltip: l10n.shortcuts_reset_to_default,
                                icon: const Icon(Icons.restart_alt, size: 18),
                                onPressed: () => store.resetAction(action),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Opens the chord editor (dialog, or a full-screen page below 480 px) and
/// returns the chosen chord, or null when cancelled. Shared with the desktop
/// quick-entry hotkey setting.
Future<shortcuts_store.KeyChord?> showShortcutChordEditor(
  BuildContext context, {
  required String title,
  required shortcuts_store.KeyChord initial,
}) {
  final isNarrow = MediaQuery.sizeOf(context).width < 480;
  final editor = _ShortcutChordEditor(
    title: title,
    initial: initial,
    fullscreen: isNarrow,
  );
  return isNarrow
      ? Navigator.of(context).push<shortcuts_store.KeyChord>(
          MaterialPageRoute<shortcuts_store.KeyChord>(
            fullscreenDialog: true,
            builder: (_) => editor,
          ),
        )
      : showDialog<shortcuts_store.KeyChord>(
          context: context,
          builder: (_) => editor,
        );
}

class _ShortcutChordEditor extends StatefulWidget {
  const _ShortcutChordEditor({
    this.action,
    this.title,
    required this.initial,
    required this.fullscreen,
  });

  final shortcuts_store.ShortcutAction? action;
  final String? title;
  final shortcuts_store.KeyChord initial;
  final bool fullscreen;

  @override
  State<_ShortcutChordEditor> createState() => _ShortcutChordEditorState();
}

class _ShortcutChordEditorState extends State<_ShortcutChordEditor> {
  late bool _meta = widget.initial.meta;
  late bool _ctrl = widget.initial.ctrl;
  late bool _alt = widget.initial.alt;
  late bool _shift = widget.initial.shift;
  late String _keyName =
      shortcuts_store.supportedShortcutKeys.containsKey(widget.initial.keyName)
      ? widget.initial.keyName
      : 'keyK';

  static final Set<LogicalKeyboardKey> _modifierKeys = {
    LogicalKeyboardKey.meta,
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.controlRight,
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
  };

  shortcuts_store.KeyChord get _chord => shortcuts_store.KeyChord(
    key: shortcuts_store.supportedShortcutKeys[_keyName]!,
    meta: _meta,
    ctrl: _ctrl,
    alt: _alt,
    shift: _shift,
  );

  bool get _hasModifier => _meta || _ctrl || _alt;

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (_modifierKeys.contains(event.logicalKey)) {
      return KeyEventResult.ignored;
    }
    for (final entry in shortcuts_store.supportedShortcutKeys.entries) {
      if (entry.value.keyId == event.logicalKey.keyId) {
        final hw = HardwareKeyboard.instance;
        final meta = hw.isMetaPressed;
        final ctrl = hw.isControlPressed;
        final alt = hw.isAltPressed;
        final shift = hw.isShiftPressed;
        if (meta || ctrl || alt) {
          setState(() {
            _keyName = entry.key;
            _meta = meta;
            _ctrl = ctrl;
            _alt = alt;
            _shift = shift;
          });
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.sharedL10n;
    final keys = shortcuts_store.supportedShortcutKeys.keys.toList();
    final content = Focus(
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.shortcuts_editor_help),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                key: const Key('chord-mod-meta'),
                label: const Text('Cmd / Meta'),
                selected: _meta,
                onSelected: (v) => setState(() => _meta = v),
              ),
              FilterChip(
                key: const Key('chord-mod-ctrl'),
                label: const Text('Ctrl'),
                selected: _ctrl,
                onSelected: (v) => setState(() => _ctrl = v),
              ),
              FilterChip(
                key: const Key('chord-mod-alt'),
                label: const Text('Alt'),
                selected: _alt,
                onSelected: (v) => setState(() => _alt = v),
              ),
              FilterChip(
                key: const Key('chord-mod-shift'),
                label: const Text('Shift'),
                selected: _shift,
                onSelected: (v) => setState(() => _shift = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final k in keys)
                FilterChip(
                  key: Key('chord-key-$k'),
                  label: Text(shortcuts_store.formatShortcutKeyName(k)),
                  selected: _keyName == k,
                  onSelected: (v) {
                    if (v) setState(() => _keyName = k);
                  },
                ),
            ],
          ),
          if (!_hasModifier) ...[
            const SizedBox(height: 8),
            Text(
              l10n.shortcuts_editor_needs_modifier,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ] else if (shortcuts_store.isTextEditingChord(_chord)) ...[
            const SizedBox(height: 8),
            Text(
              l10n.shortcuts_text_editing_warning(
                shortcuts_store.formatKeyChord(
                  _chord,
                  appleSymbols:
                      defaultTargetPlatform == TargetPlatform.macOS ||
                      defaultTargetPlatform == TargetPlatform.iOS,
                ),
              ),
              key: const Key('chord-text-editing-warning'),
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ],
        ],
      ),
    );

    final title =
        widget.title ??
        l10n.shortcuts_editor_title(shortcutActionLabel(l10n, widget.action!));
    if (widget.fullscreen) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            TextButton(
              key: const Key('chord-save-button'),
              onPressed: _hasModifier
                  ? () => Navigator.of(context).pop(_chord)
                  : null,
              child: Text(l10n.save),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ),
      );
    }

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const Key('chord-save-button'),
          onPressed: _hasModifier
              ? () => Navigator.of(context).pop(_chord)
              : null,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
