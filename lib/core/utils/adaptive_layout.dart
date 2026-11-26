/// Window-size-driven adaptive layout breakpoints shared by the Classic and
/// NextGen shells on every platform (phone, foldable, tablet, desktop).
///
/// Layout is decided strictly by the current window width — never by a
/// device-name or model check — so the same code serves an unfolded foldable,
/// an iPad in Split View, and an arbitrarily resized Mac window.
library;

import 'package:flutter/material.dart';

/// The three adaptive size classes the Apple port (and Android foldables)
/// share.
enum AdaptiveSizeClass {
  /// Phone / compact outer window: normal stacked navigation.
  compact,

  /// Medium window (large phone landscape, small tablet, half Split View):
  /// a navigation rail / sidebar where appropriate.
  medium,

  /// Wide window with useful height (unfolded foldable, iPad landscape, Mac):
  /// list+detail / two-pane / docked sidebar.
  expanded,
}

/// Breakpoints in logical points, per the Apple port contract.
abstract final class AdaptiveBreakpoints {
  /// Below this width the window is compact (phone navigation/stack).
  static const double medium = 600;

  /// At or above this width (with useful height) the window is expanded
  /// (two-pane / docked sidebar).
  static const double expanded = 840;

  /// Minimum height for a productive multi-column / two-pane layout. Below
  /// this an otherwise-wide window falls back to the medium rail so a short
  /// landscape phone does not get a cramped split view.
  static const double expandedMinHeight = 480;

  /// Width of the docked NextGen sessions sidebar / Classic detail rail.
  static const double dockedSidebarWidth = 300;
}

/// Classifies a window [size] into an [AdaptiveSizeClass].
AdaptiveSizeClass adaptiveSizeClassOf(Size size) {
  if (size.width >= AdaptiveBreakpoints.expanded &&
      size.height >= AdaptiveBreakpoints.expandedMinHeight) {
    return AdaptiveSizeClass.expanded;
  }
  if (size.width >= AdaptiveBreakpoints.medium) {
    return AdaptiveSizeClass.medium;
  }
  return AdaptiveSizeClass.compact;
}

/// Convenience accessor reading the current [MediaQuery] window size.
AdaptiveSizeClass adaptiveSizeClassOfContext(BuildContext context) =>
    adaptiveSizeClassOf(MediaQuery.sizeOf(context));

/// Whether the window is wide enough (and tall enough) for a docked
/// two-pane / list+detail layout.
bool isExpandedWindow(BuildContext context) =>
    adaptiveSizeClassOfContext(context) == AdaptiveSizeClass.expanded;

/// Keeps every route inside the system's left and right insets on an
/// expanded window.
///
/// An unfolded iPhone Duo reports its status cluster (clock and battery ring)
/// as a right-hand safe-area inset. Wide layouts put panes edge to edge and a
/// pane cannot tell which screen edge it touches: the docked sidebar's
/// [SafeArea] gave up that width on the wrong side, while lists and
/// transcripts ran underneath the cluster. The inset is therefore taken once,
/// above the navigator, and removed from the [MediaQuery] below it.
///
/// Compact and medium windows are left alone, so a phone in landscape still
/// draws edge to edge. The widget tree has the same shape in every size class,
/// so folding or resizing never remounts the routes underneath.
class ExpandedWindowSideInsets extends StatelessWidget {
  const ExpandedWindowSideInsets({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final apply = isExpandedWindow(context);
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        left: apply,
        right: apply,
        top: false,
        bottom: false,
        child: child,
      ),
    );
  }
}
