import 'package:flutter/widgets.dart';

import '../models/connection.dart';

/// The saved connection and gateway profile a render surface belongs to.
String renderConnectionKey(SavedConnection connection) =>
    '${connection.id}\u0000${connection.gatewayProfile ?? ''}';

/// Names the chat that rich transcript pieces render for. Per-chat render
/// state is keyed by [chatKey] and contribution grants by [connection], so
/// nothing chosen in one chat (or on one gateway) shows up in another.
/// Classic and NextGen wrap each chat view in one.
class RenderScope extends InheritedWidget {
  const RenderScope({
    super.key,
    required this.connection,
    required this.chat,
    required super.child,
  });

  /// [renderConnectionKey] of the chat's connection.
  final String connection;

  /// The stored chat id, or a key unique to the view before it is stored.
  final String chat;

  /// Connection, profile and chat together.
  String get chatKey => '$connection\u0000$chat';

  static RenderScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RenderScope>();

  @override
  bool updateShouldNotify(RenderScope oldWidget) =>
      oldWidget.connection != connection || oldWidget.chat != chat;
}
