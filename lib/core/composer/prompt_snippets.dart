import 'package:flutter/services.dart';

/// Insert [snippet] at the caret, replacing a selection.
String insertSnippet(String current, TextSelection selection, String snippet) {
  if (!selection.isValid ||
      selection.start < 0 ||
      selection.end > current.length) {
    if (current.trim().isEmpty) return snippet;
    return '${current.trimRight()}\n\n$snippet';
  }
  return current.replaceRange(selection.start, selection.end, snippet);
}
