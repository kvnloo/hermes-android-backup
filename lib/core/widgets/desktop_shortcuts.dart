/// macOS/desktop keyboard shortcuts for Ares.
///
/// Actions are broadcast on a tiny stream so the active shell (Classic or
/// NextGen) can own the concrete implementation without the app root needing
/// to know which shell is mounted. On touch platforms the wrapper is a plain
/// passthrough, so mobile behaviour and widget tests are untouched.
library;

import 'dart:async';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/shortcuts_store.dart' as shortcuts_store;

/// Primary desktop actions exposed by the shells.
enum DesktopShortcut {
  commandPalette,
  newChat,
  search,
  settings,
  tab1,
  tab2,
  tab3,
  tab4,
}

/// Broadcast bus between [DesktopShortcuts] and the active shell.
final StreamController<DesktopShortcut> desktopShortcutBus =
    StreamController<DesktopShortcut>.broadcast();

/// Fires a shortcut. Used by the key handler and by tests.
void fireDesktopShortcut(DesktopShortcut shortcut) {
  if (!desktopShortcutBus.isClosed) desktopShortcutBus.add(shortcut);
}

/// Whether the in-app keyboard shortcuts fire on [platform]: the desktop
/// runners only. On Android and iOS [DesktopShortcuts] is a passthrough, so
/// Settings hides the shortcuts card there instead of offering bindings that
/// can never fire.
bool desktopShortcutsAvailable([TargetPlatform? platform]) =>
    switch (platform ?? defaultTargetPlatform) {
      TargetPlatform.macOS ||
      TargetPlatform.linux ||
      TargetPlatform.windows => true,
      _ => false,
    };

/// Wraps [child] with desktop shortcut bindings when running on a desktop
/// platform. Pass [forceEnabled] in tests to exercise the bindings without
/// changing the process-wide target platform.
class DesktopShortcuts extends StatelessWidget {
  const DesktopShortcuts({
    required this.child,
    this.store,
    this.forceEnabled,
    super.key,
  });

  final Widget child;
  final shortcuts_store.ShortcutsStore? store;

  /// Overrides the platform gate. Null uses the real target platform.
  final bool? forceEnabled;

  bool get _enabled => forceEnabled ?? desktopShortcutsAvailable();

  static DesktopShortcut _shortcutFor(shortcuts_store.ShortcutAction action) =>
      switch (action) {
        shortcuts_store.ShortcutAction.commandPalette =>
          DesktopShortcut.commandPalette,
        shortcuts_store.ShortcutAction.newChat => DesktopShortcut.newChat,
        shortcuts_store.ShortcutAction.search => DesktopShortcut.search,
        shortcuts_store.ShortcutAction.settings => DesktopShortcut.settings,
        shortcuts_store.ShortcutAction.tab1 => DesktopShortcut.tab1,
        shortcuts_store.ShortcutAction.tab2 => DesktopShortcut.tab2,
        shortcuts_store.ShortcutAction.tab3 => DesktopShortcut.tab3,
        shortcuts_store.ShortcutAction.tab4 => DesktopShortcut.tab4,
      };

  static SingleActivator _activatorFor(shortcuts_store.KeyChord chord) =>
      SingleActivator(
        chord.key,
        meta: chord.meta,
        control: chord.ctrl,
        shift: chord.shift,
        alt: chord.alt,
      );

  Map<ShortcutActivator, VoidCallback> _buildBindings() {
    // One plan for the key handler and Settings: the same chords that fire
    // here are the ones the conflict check sees (including the Windows/Linux
    // Ctrl twins), and a custom chord that collides falls back to its default.
    final plan =
        store?.plan(platform: defaultTargetPlatform) ??
        shortcuts_store.ShortcutPlan.resolve(
          const <String, String>{},
          defaultTargetPlatform,
        );
    return {
      for (final binding in plan.bindings)
        _activatorFor(binding.chord): () =>
            fireDesktopShortcut(_shortcutFor(binding.action)),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return child;

    return ValueListenableBuilder<int>(
      valueListenable: shortcuts_store.shortcutsStoreChanges,
      builder: (context, _, _) {
        return CallbackShortcuts(
          bindings: _buildBindings(),
          child: Focus(autofocus: true, includeSemantics: false, child: child),
        );
      },
    );
  }
}

/// Wraps a composer field so plain Enter (without Shift) triggers [onSend]
/// on desktop. Key events from the focused descendant bubble to this Focus.
class SendOnEnter extends StatelessWidget {
  const SendOnEnter({
    required this.child,
    required this.onSend,
    this.onNavigate,
    this.enabled = true,
    super.key,
  });

  final Widget child;
  final VoidCallback onSend;
  final KeyEventResult Function(KeyEvent)? onNavigate;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Focus(
    onKeyEvent: (node, event) {
      if (enabled && shouldSendOnEnter(event)) {
        onSend();
        return KeyEventResult.handled;
      }
      return onNavigate?.call(event) ?? KeyEventResult.ignored;
    },
    child: child,
  );
}

/// Whether an Enter key event should send the composer rather than insert a
/// newline: plain Enter sends, Shift+Enter inserts a newline (the desktop
/// convention; mobile soft keyboards keep their own action button).
bool shouldSendOnEnter(KeyEvent event) =>
    (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) &&
    !HardwareKeyboard.instance.isShiftPressed;
