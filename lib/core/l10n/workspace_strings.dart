import '../services/remote_workspace.dart';
import 'l10n.dart';

/// Resolve protocol states at render time; never show wire names as UI copy.
String workspaceFailureLabel(AppLocalizations l10n, WorkspaceFailure reason) =>
    switch (reason) {
      WorkspaceFailure.stale => l10n.release_core_workspace_failure_stale,
      WorkspaceFailure.unbound => l10n.release_core_workspace_failure_unbound,
      WorkspaceFailure.denied => l10n.release_core_workspace_failure_denied,
      WorkspaceFailure.ineligible =>
        l10n.release_core_workspace_failure_ineligible,
      WorkspaceFailure.unsupported =>
        l10n.release_core_workspace_failure_unsupported,
      WorkspaceFailure.mismatch => l10n.release_core_workspace_failure_mismatch,
      WorkspaceFailure.invalid => l10n.release_core_workspace_failure_invalid,
      WorkspaceFailure.insecure => l10n.release_core_workspace_failure_insecure,
      WorkspaceFailure.unavailable =>
        l10n.release_core_workspace_failure_unavailable,
    };

String gatewayQueueStateLabel(AppLocalizations l10n, String state) =>
    switch (state) {
      'queued' => l10n.release_core_queue_state_queued,
      'started' => l10n.release_core_queue_state_started,
      'unknown' => l10n.release_core_queue_state_unknown,
      _ => l10n.release_core_unknown_state,
    };

String fleetGatewayStateLabel(AppLocalizations l10n, String phase) =>
    switch (phase) {
      'idle' => l10n.release_core_fleet_state_idle,
      'connecting' => l10n.appearance_connecting,
      'connected' => l10n.release_core_fleet_state_connected,
      'reconnecting' => l10n.release_core_fleet_state_reconnecting,
      'sessionExpired' => l10n.release_core_fleet_state_sessionExpired,
      'failed' => l10n.release_core_fleet_state_failed,
      _ => l10n.release_core_unknown_state,
    };

String workspaceErrorText(
  AppLocalizations l10n,
  Object error,
) => switch (error) {
  WorkspaceException() => l10n.release_core_workspace_operation_failed(
    workspaceFailureLabel(l10n, error.reason),
  ),
  FormatException(message: 'Invalid delivery target') =>
    l10n.release_core_schedule_invalid_delivery_target,
  FormatException() => l10n.release_core_workspace_invalid_data,
  _ =>
    l10n.release_core_session_files_view_gateway_operation_could_not_be_confirmed,
};

String fleetUpdateStateLabel(AppLocalizations l10n, String state) {
  if (state.startsWith('Eligible · ')) {
    return l10n.release_core_fleet_update_eligible(
      state.substring('Eligible · '.length),
    );
  }
  return switch (state) {
    'Skipped: same installation' => l10n.release_core_fleet_update_state_1,
    'Not checked' => l10n.release_core_fleet_update_state_2,
    'Skipped: Cloud-managed' => l10n.release_core_fleet_update_state_3,
    'Skipped: not enrolled as a direct gateway' =>
      l10n.release_core_fleet_update_state_4,
    'Skipped: disconnected or busy' => l10n.release_core_fleet_update_state_5,
    'No applicable update' => l10n.release_core_fleet_update_state_6,
    'Could not verify eligibility' => l10n.release_core_fleet_update_state_7,
    'Skipped: stale, busy or already requested' =>
      l10n.release_core_fleet_update_state_8,
    'Requesting' => l10n.release_core_fleet_update_state_9,
    'Accepted; receipt unavailable' => l10n.release_core_fleet_update_state_10,
    'Accepted; awaiting receipt' => l10n.release_core_fleet_update_state_11,
    'Skipped: a chat on this installation is running' =>
      l10n.release_core_fleet_update_state_12,
    'Not confirmed; do not resend automatically' =>
      l10n.release_core_fleet_update_state_13,
    'Reconnect to check receipt' => l10n.release_core_fleet_update_state_14,
    'Receipt unavailable' => l10n.release_core_fleet_update_state_15,
    'Awaiting matching receipt' => l10n.release_core_fleet_update_state_16,
    'Updated; follow-up required' => l10n.release_core_fleet_update_state_17,
    'Updated' => l10n.activity_updated,
    'Partially updated' => l10n.release_core_fleet_update_state_19,
    'Update failed' => l10n.release_core_fleet_update_state_20,
    'Not confirmed' => l10n.release_core_fleet_update_state_21,
    _ => state,
  };
}

String cloudAgentStatusLabel(AppLocalizations l10n, String state) =>
    switch (state) {
      'running' => l10n.status_running,
      'ready' => l10n.release_core_cloud_status_ready,
      'online' => l10n.release_core_cloud_status_online,
      'stopped' => l10n.release_core_cloud_status_stopped,
      'pending' => l10n.task_status_pending,
      'error' => l10n.release_core_cloud_status_error,
      'offline' => l10n.release_core_fleet_state_idle,
      _ => state,
    };
