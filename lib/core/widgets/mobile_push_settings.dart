import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/l10n.dart';
import '../services/connection_manager.dart';
import '../services/mobile_push_service.dart';
import '../services/notification_prefs.dart';
import 'markdown_link_handler.dart';

/// Explicit opt-in, deliberately separate from local notification preferences.
class MobilePushSettings extends StatefulWidget {
  const MobilePushSettings({
    required this.connection,
    required this.connectionManager,
    this.service,
    super.key,
  });
  final SavedConnection connection;
  final ConnectionManager connectionManager;
  final MobilePushService? service;
  @override
  State<MobilePushSettings> createState() => _MobilePushSettingsState();
}

class _MobilePushSettingsState extends State<MobilePushSettings> {
  static const _serverSetupGuide =
      'https://github.com/rusty4444/hermes-android/blob/main/docs/mobile-push-server.md'
      '#operator-installation-not-performed-by-this-implementation';
  late final MobilePushService service =
      widget.service ?? MobilePushService.shared;
  List<Map<String, dynamic>> transports = [];
  String? distributor;
  bool ready = false;
  bool busy = false;
  int operation = 0;
  String? message;
  MobilePushAvailability? availability;
  @override
  void initState() {
    super.initState();
    service.addListener(_changed);
    unawaited(_load());
  }

  void _changed() {
    if (mounted) setState(() => availability = null);
  }

  @override
  void didUpdateWidget(covariant MobilePushSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (MobilePushService.binding(oldWidget.connection) !=
        MobilePushService.binding(widget.connection)) {
      ++operation;
      busy = false;
      message = null;
      availability = null;
    }
  }

  Future<void> _load() async {
    try {
      await service.initialize(widget.connectionManager);
      if (!mounted) return;
      final options = await service.transportOptions();
      if (!mounted) return;
      setState(() {
        transports = options;
        ready = true;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          ready = true;
          message = context.sharedL10n.rel_svc_push_availability_read_failed;
        });
      }
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    final ticket = ++operation;
    setState(() {
      busy = true;
      message = null;
      availability = null;
    });
    try {
      await action();
    } catch (_) {
      if (mounted && ticket == operation) {
        setState(
          () => message =
              service.error ?? context.sharedL10n.rel_svc_push_setup_failed,
        );
      }
    } finally {
      if (mounted && ticket == operation) setState(() => busy = false);
    }
  }

  Future<void> _refresh() async {
    final ticket = operation;
    final connection = widget.connection;
    final fingerprint = MobilePushService.binding(connection);
    bool current() =>
        mounted &&
        ticket == operation &&
        MobilePushService.binding(widget.connection) == fingerprint;
    await _load();
    if (!current()) return;
    if (service.enabled) {
      await service.retry();
    } else {
      await service.refresh();
      if (!current()) return;
      final result = await service.checkAvailability(connection);
      if (!current()) return;
      setState(() => availability = result);
    }
  }

  String? _boundConnectionLabel(String boundId) {
    if (boundId.isEmpty) return null;
    final raw = widget.connectionManager
        .getConnections()
        .where((c) => c.id == boundId)
        .firstOrNull
        ?.label
        .trim();
    return (raw != null && raw.isNotEmpty) ? raw : null;
  }

  @override
  void dispose() {
    ++operation;
    service.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!service.supported) return const SizedBox.shrink();
    final l10n = context.sharedL10n;
    final on = service.enabled || service.enabling;
    final boundId = service.enabling
        ? service.pendingConnectionId
        : service.connectionId;
    final another = on && boundId != widget.connection.id;
    final boundLabel = another ? _boundConnectionLabel(boundId) : null;
    final rawStatus = availability?.status ?? service.status;
    final statusText = another
        ? l10n.rel_svc_push_status_bound(
            boundLabel ?? l10n.rel_svc_push_another_saved_connection,
            widget.connection.label,
            rawStatus,
          )
        : l10n.rel_svc_push_status(rawStatus);
    return ValueListenableBuilder<NotificationPrefs>(
      valueListenable: notificationPrefs,
      builder: (context, prefs, _) => Card(
        key: const Key('mobile-push-card'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                identifier: 'mobile-push-switch',
                child: SwitchListTile(
                  key: const Key('mobile-push-switch'),
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.rel_svc_push_background_notifications),
                  subtitle: Text(
                    another
                        ? l10n.rel_svc_push_bound_subtitle(
                            boundLabel ??
                                l10n.rel_svc_push_another_saved_connection,
                            widget.connection.label,
                          )
                        : l10n.rel_svc_push_private_activity(
                            widget.connection.label,
                          ),
                  ),
                  value: on && !another,
                  // Opt-out stays actionable through capabilities, permission, native
                  // registration and HTTP. It must never wait for _run's old future.
                  onChanged: another || (!on && (!ready || busy))
                      ? null
                      : (value) => _run(
                          value
                              ? () => service.enableAutomatic(
                                  widget.connection,
                                  distributor: distributor,
                                )
                              : service.disable,
                        ),
                ),
              ),
              Text(statusText, key: const Key('mobile-push-status')),
              if (busy) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
              ],
              if (another) ...[
                const SizedBox(height: 8),
                Text(
                  boundLabel != null
                      ? l10n.rel_svc_push_bound_warning_named(boundLabel)
                      : l10n.rel_svc_push_bound_warning,
                  key: const Key('mobile-push-another-warning'),
                ),
              ],
              if (service.enabled && !another && !prefs.enabled) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.rel_svc_push_local_notifications_muted,
                  key: const Key('mobile-push-local-mute-warning'),
                ),
              ],
              if (service.enabled &&
                  !another &&
                  service.sessionScope == 'explicit') ...[
                const SizedBox(height: 8),
                Text(
                  l10n.rel_svc_push_legacy_subscription(
                    service.sessionIds.length,
                  ),
                ),
              ],
              if (service.enabled &&
                  !another &&
                  service.sessionScope == 'authorized') ...[
                const SizedBox(height: 8),
                Text(l10n.rel_svc_push_authorized_binding),
              ],
              if (service.pendingRevocations > 0) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.rel_svc_push_revocation_pending,
                  key: const Key('mobile-push-revocation-pending'),
                ),
              ],
              if (message ?? availability?.error ?? service.error
                  case final String text) ...[
                const SizedBox(height: 8),
                Text(
                  text,
                  key: const Key('mobile-push-error'),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OutlinedButton(
                    key: const Key('mobile-push-refresh-retry'),
                    onPressed: busy || !ready ? null : () => _run(_refresh),
                    child: Text(l10n.rel_svc_push_refresh_retry),
                  ),
                  if (on)
                    TextButton(
                      key: const Key('mobile-push-disable-revoke'),
                      onPressed: () => _run(service.disable),
                      child: Text(
                        another
                            ? l10n.rel_svc_push_disable_named(
                                boundLabel ??
                                    l10n.rel_svc_push_other_connection,
                              )
                            : l10n.rel_svc_push_disable,
                      ),
                    ),
                ],
              ),
              Text(l10n.rel_svc_push_refresh_explanation),
              Text(l10n.rel_svc_push_companion_required),
              TextButton.icon(
                onPressed: () =>
                    openMarkdownWebLink(context, _serverSetupGuide),
                icon: const Icon(Icons.open_in_new),
                label: Text(l10n.rel_svc_push_server_setup_guide),
              ),
              Text(l10n.rel_svc_push_enable_disclosure),
              Text(l10n.rel_svc_push_transport_disclosure),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(l10n.rel_svc_push_advanced_transport),
                children: [
                  Text(l10n.rel_svc_push_automatic_explanation),
                  DropdownButtonFormField<String>(
                    key: ValueKey(distributor),
                    initialValue: distributor ?? 'automatic',
                    decoration: InputDecoration(
                      labelText: l10n.rel_svc_push_transport_label,
                    ),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(
                        value: 'automatic',
                        child: Text(l10n.rel_svc_push_automatic_recommended),
                      ),
                      if (distributor != null &&
                          !transports.any(
                            (option) => option['id'] == distributor,
                          ))
                        DropdownMenuItem(
                          value: distributor,
                          enabled: false,
                          child: Text(l10n.rel_svc_push_selected_unavailable),
                        ),
                      for (final option in transports)
                        DropdownMenuItem(
                          value: option['id'] as String,
                          child: Text(
                            option['label'] as String,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: on || busy
                        ? null
                        : (value) => setState(
                            () => distributor = value == 'automatic'
                                ? null
                                : value,
                          ),
                  ),
                  if (transports.isEmpty)
                    Text(l10n.rel_svc_push_no_transport_detected),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
