import 'package:flutter/foundation.dart';

import 'connection_manager.dart';
import 'desktop_gateway_client.dart';
import 'remote_workspace.dart';

/// Test seam for widget tests, whose binding blocks the real HTTP client.
/// Production leaves this null and opens a profile-scoped gateway client.
@visibleForTesting
Future<Object?> Function(
  SavedConnection connection,
  String profile,
  Future<Object?> Function(WorkspaceTarget target) action,
)?
debugProfileOwnerBinding;

/// Binds a fresh owner for [profile] on the same saved gateway. The caller's
/// chat profile is left alone, and this client does not reconnect on its own.
Future<T> withProfileOwner<T>(
  SavedConnection connection,
  String profile,
  Future<T> Function(WorkspaceTarget target) action,
) async {
  final hook = debugProfileOwnerBinding;
  if (hook != null) {
    final value = await hook(
      connection,
      profile,
      (target) async => action(target),
    );
    return value as T;
  }
  if (!isProfileId(profile)) {
    throw const WorkspaceException(WorkspaceFailure.invalid);
  }
  final gateway = DesktopGatewayClient.fromConnection(
    connection.copyWith(gatewayProfile: profile),
  );
  gateway.setReconnectAllowed(false);
  final pane = gateway.workspace.pane();
  try {
    final target = await pane.bind(gateway.workspace.route());
    if (!target.isCurrent || target.effectiveProfile != profile) {
      throw const WorkspaceException(WorkspaceFailure.mismatch);
    }
    return await action(target);
  } finally {
    pane.close();
    gateway.close();
  }
}
