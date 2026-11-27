import 'package:flutter/widgets.dart';

/// The on-screen keyboard's height over this window, in logical pixels.
///
/// Unlike `MediaQuery.viewInsetsOf`, this also sees a keyboard that an
/// ancestor Scaffold has already resized for: that Scaffold removes the
/// bottom inset from its body's MediaQuery, so a chat nested in it (a
/// Parallel workspace pane, a tab of another page) would otherwise never
/// know the keyboard is up and keep chrome it has no room for.
double keyboardHeightOf(BuildContext context) {
  final local = MediaQuery.viewInsetsOf(context).bottom;
  if (local > 0) return local;
  final view = View.maybeOf(context);
  if (view == null || view.devicePixelRatio <= 0) return 0;
  return view.viewInsets.bottom / view.devicePixelRatio;
}

/// Under this much height above the keyboard (the whole chat, its own app
/// bar included), a chat folds its header chrome while the keyboard is up.
const double foldChatChromeBelow = 440;

/// Under this much height for the transcript and composer together, the
/// composer folds its model/status row while the keyboard is up.
const double foldComposerStatusBelow = 200;

/// Under this much height above the keyboard, a workspace folds its tab
/// strip and pane switcher while the keyboard is up.
const double foldWorkspaceStripBelow = 480;

/// Under this much height above the keyboard, a workspace also folds its
/// own app bar while the keyboard is up (landscape phones).
const double foldWorkspaceBarBelow = 280;
