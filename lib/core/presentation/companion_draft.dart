import 'package:flutter/widgets.dart';

/// A message typed in the popped-out companion. The pet window never receives
/// a session id; the open chat applies the text to its own composer.
class CompanionDraft {
  CompanionDraft._();

  static final pending = ValueNotifier<String?>(null);

  static const maxLength = 2000;

  /// Accepts one short message. Control characters other than newlines are
  /// dropped so a companion window cannot smuggle terminal sequences.
  static void offer(String text) {
    final cleaned = String.fromCharCodes(
      text.runes.where(
        (rune) => rune == 10 || rune == 9 || (rune >= 32 && rune != 127),
      ),
    ).trim();
    if (cleaned.isEmpty || cleaned.length > maxLength) return;
    pending.value = cleaned;
  }

  static void applyTo(TextEditingController controller) {
    final text = pending.value;
    if (text == null) return;
    pending.value = null;
    final current = controller.text;
    final next = current.trim().isEmpty ? text : '$current\n$text';
    if (next.length > 8000) return;
    controller.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
  }
}
