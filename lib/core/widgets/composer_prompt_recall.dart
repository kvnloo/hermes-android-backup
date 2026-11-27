import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// An editor-local snapshot of the visible session's sent prompts. Never
/// submits a turn. Editing, selecting text or moving the caret ends browsing.
class ComposerPromptRecall {
  List<String> _prompts = const [];
  int _position = 0;
  bool _applying = false;

  void editorChanged() {
    if (!_applying) _prompts = const [];
  }

  KeyEventResult handle(
    KeyEvent event,
    TextEditingController editor,
    Iterable<String> Function() history,
  ) {
    final up = event.logicalKey == LogicalKeyboardKey.arrowUp;
    if ((!up && event.logicalKey != LogicalKeyboardKey.arrowDown) ||
        event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final keys = HardwareKeyboard.instance;
    if (keys.isControlPressed ||
        keys.isMetaPressed ||
        keys.isAltPressed ||
        keys.isShiftPressed ||
        !editor.selection.isCollapsed ||
        !editor.value.composing.isCollapsed) {
      return KeyEventResult.ignored;
    }
    if (_prompts.isEmpty) {
      if (!up || editor.text.isNotEmpty) return KeyEventResult.ignored;
      _prompts = history().where((s) => s.trim().isNotEmpty).toList();
      if (_prompts.isEmpty) return KeyEventResult.ignored;
      _position = _prompts.length;
    }
    _position = (_position + (up ? -1 : 1)).clamp(0, _prompts.length);
    final text = _position < _prompts.length ? _prompts[_position] : '';
    _applying = true;
    try {
      editor.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } finally {
      _applying = false;
    }
    if (_position == _prompts.length) _prompts = const [];
    return KeyEventResult.handled;
  }
}
