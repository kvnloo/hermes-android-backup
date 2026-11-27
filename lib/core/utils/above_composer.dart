import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The tallest a card stacked above the composer may be. Classic's Kanban
/// strip uses it; it is the same rule as NextGen's `ngAboveComposerMaxHeight`
/// (lib/nextgen/ui/session_dock.dart), which core code cannot import.
///
/// [available] is the height the chat body really has: Scaffold has already
/// taken the on-screen keyboard off it. Never use the window height: it does
/// not shrink when the keyboard opens, and Scaffold also removes the keyboard
/// from the MediaQuery its body sees, so a share of the window pushed the
/// composer under the keyboard. The keyboard itself is read from the View,
/// which Scaffold leaves untouched. With no bounded [available] (a card shown
/// on its own), the window less the keyboard and status bar is used.
double aboveComposerMaxHeight(
  BuildContext context, {
  double available = double.infinity,
  required double fraction,
  double? withKeyboard,
}) {
  final media = MediaQuery.of(context);
  final view = View.maybeOf(context);
  final viewKeyboard = view == null
      ? 0.0
      : view.viewInsets.bottom / view.devicePixelRatio;
  final keyboard = math.max(media.viewInsets.bottom, viewKeyboard);
  final height = available.isFinite
      ? available
      : math.max(0.0, media.size.height - keyboard - media.padding.top);
  return height * (keyboard > 0 ? (withKeyboard ?? fraction) : fraction);
}
