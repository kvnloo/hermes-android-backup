// NextGen settings: the gateway you're signed in to (with Kyllene's staged
// connection check), saved gateways, appearance, and the NextGen switch.
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/parked_automotive.dart';
import '../../core/models/connection.dart';
import '../../core/screens/settings_screen.dart';
import '../../core/settings/settings_browser.dart';
import '../../core/services/background_work_prefs.dart';
import '../../core/services/notification_prefs.dart';
import '../../core/widgets/completion_sound_settings.dart';
import '../../core/utils/platform_capabilities.dart';
import '../../core/services/turn_notification_service.dart';
import '../../core/services/hermes_sign_in.dart';
import '../data/connection_check.dart';
import '../../core/widgets/gateway_wake_controls.dart';
import '../../core/widgets/voice_live_controls.dart';
import '../nextgen_preferences.dart';
import '../theme/nextgen_theme.dart';
import 'models_page.dart';
import 'nextgen_scope.dart';
import 'widgets.dart';
import '../nextgen_l10n.dart';

class NgSettingsPage extends StatefulWidget {
  const NgSettingsPage({super.key, this.initialCategory, this.initialTarget});
  final SettingsCategory? initialCategory;
  final String? initialTarget;

  @override
  State<NgSettingsPage> createState() => _NgSettingsPageState();
}

class _NgSettingsPageState extends State<NgSettingsPage> {
  ConnectionReport? _report;
  bool _checking = false;
  String? _signedInAs;
  Object? _owner;
  int _generation = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gateway = NgScope.of(context).gateway;
    if (identical(_owner, gateway)) return;
    _owner = gateway;
    _generation++;
    _signedInAs = null;
    _report = null;
    _checking = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && identical(_owner, gateway)) _loadMe();
    });
  }

  Future<void> _loadMe() async {
    final gateway = NgScope.of(context).gateway;
    final generation = _generation;
    if (!isParkedAutomotive) unawaited(gateway.voiceLiveMode.refresh());
    if (!isParkedAutomotive && gateway.state.isConnected) {
      unawaited(gateway.wakeWord.refreshStatus());
      unawaited(gateway.wakeWord.refreshClientInputDevices());
    }
    try {
      final res = await gateway.dashboard.apiRequest('GET', 'auth/me');
      if (res.statusCode == 200 && mounted && generation == _generation) {
        final user = AuthUser.fromJson(
          Map<String, dynamic>.from(jsonDecode(res.body) as Map),
        );
        setState(() => _signedInAs = user.label);
      }
    } catch (_) {
      // Shown as unknown.
    }
  }

  Future<void> _check() async {
    final conn = NgScope.of(context).connection;
    final generation = _generation;
    setState(() {
      _checking = true;
      _report = null;
    });
    final report = await runConnectionCheck(
      conn,
      onProgress: (r) {
        if (mounted && generation == _generation) setState(() => _report = r);
      },
    );
    if (!mounted || generation != _generation) return;
    setState(() {
      _checking = false;
      _report = report;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scope = NgScope.of(context);
    final conn = scope.connection;
    return ListenableBuilder(
      listenable: NextGenLook.instance,
      builder: (context, _) {
        final c = NgColors.of(context);
        final look = NextGenLook.instance;
        final brightness = Theme.of(context).brightness;
        return SettingsScreen(
          connection: conn,
          dashboardClient: scope.gateway.dashboard,
          connectionManager: scope.connManager,
          mode: SettingsMode.nextgen,
          initialCategory: widget.initialCategory,
          initialTarget: widget.initialTarget,
          extraItems: [
            SettingsItem(
              id: 'ng.theme',
              category: SettingsCategory.appearance,
              scope: SettingsScope.nextgen,
              title: (l) => l.ng_theme,
              summary: (l) =>
                  '${l.ng_theme}: ${switch (look.themeMode) {
                    ThemeMode.light => l.ng_light,
                    ThemeMode.dark => l.ng_dark,
                    ThemeMode.system => l.ng_system,
                  }}',
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NgSectionLabel(ngL.ng_appearance),
                  NgCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ngL.ng_theme,
                          style: NgType.label.copyWith(color: c.text2),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<ThemeMode>(
                          key: const ValueKey('ng-theme-mode'),
                          showSelectedIcon: false,
                          style: const ButtonStyle(
                            minimumSize: WidgetStatePropertyAll(Size(48, 48)),
                          ),
                          segments: [
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text(ngL.ng_system),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text(ngL.ng_light),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text(ngL.ng_dark),
                            ),
                          ],
                          selected: {look.themeMode},
                          onSelectionChanged: (m) =>
                              NextGenPreferences.setThemeMode(
                                scope.prefs,
                                m.single,
                              ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          ngL.ng_accent,
                          style: NgType.label.copyWith(color: c.text2),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (final a in NgAccent.values)
                              Semantics(
                                selected: a == look.accent,
                                child: IconButton(
                                  tooltip: switch (a) {
                                    NgAccent.blue => ngL.theme_palette_blue,
                                    NgAccent.violet => ngL.theme_palette_purple,
                                    NgAccent.green => ngL.theme_palette_green,
                                    NgAccent.orange => ngL.theme_palette_orange,
                                    NgAccent.pink => ngL.theme_palette_pink,
                                    NgAccent.teal => ngL.theme_palette_teal,
                                  },
                                  constraints: const BoxConstraints(
                                    minWidth: 48,
                                    minHeight: 48,
                                  ),
                                  onPressed: () => NextGenPreferences.setAccent(
                                    scope.prefs,
                                    a,
                                  ),
                                  icon: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: ngAccentSwatch(
                                      a,
                                      brightness,
                                    ),
                                    child: a == look.accent
                                        ? Icon(
                                            Icons.check,
                                            size: 18,
                                            color: c.onAccent,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(ngL.ng_pure_black),
                          subtitle: Text(
                            ngL.ng_dark_theme_uses_true_black_oled,
                          ),
                          value: look.pureBlack,
                          onChanged: (v) =>
                              NextGenPreferences.setPureBlack(scope.prefs, v),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(ngL.ng_glow),
                          subtitle: Text(
                            ngL.ng_soft_accent_light_behind_each_screen,
                          ),
                          value: look.glow,
                          onChanged: (v) =>
                              NextGenPreferences.setGlow(scope.prefs, v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SettingsItem(
              id: 'ng.chat.reopen',
              category: SettingsCategory.chat,
              scope: SettingsScope.nextgen,
              title: (l) => l.settings_reopen_chat,
              builder: (_) => Card(
                child: SwitchListTile(
                  key: const ValueKey('ng-reopen-chat'),
                  title: Text(ngL.settings_reopen_chat),
                  subtitle: Text(ngL.settings_reopen_chat_hint),
                  value: NextGenPreferences.reopenLastChat(scope.prefs),
                  onChanged: (value) async {
                    await scope.prefs.setBool(
                      NextGenPreferences.reopenKey,
                      value,
                    );
                    if (mounted) setState(() {});
                  },
                ),
              ),
            ),
            if (!isParkedAutomotive)
              SettingsItem(
                id: 'voice.gateway',
                category: SettingsCategory.voice,
                title: (l) => l.wake_word_title,
                builder: (_) => NgCard(
                  child: Column(
                    children: [
                      ListenableBuilder(
                        listenable: scope.gateway.voiceLiveMode,
                        builder: (context, _) =>
                            scope.gateway.voiceLiveMode.hasStatus
                            ? VoiceEngineSettingsPanel(
                                controller: scope.gateway.voiceLiveMode,
                              )
                            : const SizedBox.shrink(),
                      ),
                      GatewayWakeSettingsPanel(
                        controller: scope.gateway.wakeWord,
                      ),
                    ],
                  ),
                ),
              ),
            SettingsItem(
              id: 'ng.connection',
              category: SettingsCategory.connections,
              scope: SettingsScope.nextgen,
              title: (l) => l.ng_saved_gateways,
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NgSectionLabel(ngL.ng_gateway_2),
                  NgCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.dns_outlined, color: c.accentText),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    conn.label,
                                    style: NgType.heading.copyWith(
                                      color: c.text,
                                    ),
                                  ),
                                  Text(
                                    scope.gateway.url.display,
                                    style: NgType.caption.copyWith(
                                      color: c.text3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListenableBuilder(
                              listenable: scope.gateway,
                              builder: (context, _) => NgPill(
                                scope.gateway.state.label,
                                tone: scope.gateway.state.isConnected
                                    ? NgTone.success
                                    : NgTone.warning,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _kv(c, ngL.ng_signed_in, switch (conn) {
                          _ when !conn.singleLogin =>
                            ngL.ng_classic_connection_2,
                          _ when conn.usesBrowserSignIn =>
                            _signedInAs == null
                                ? ngL.ng_in_the_browser
                                : ngL.ng_in_the_browser_as(_signedInAs!),
                          _ when conn.signInMethod == 'none' =>
                            ngL.ng_not_required,
                          _ =>
                            _signedInAs ??
                                conn.dashboardUsername ??
                                ngL.ng_password,
                        }),
                        if (conn.gatewayProfile != null)
                          _kv(c, ngL.ng_profile, conn.gatewayProfile!),
                        if (_report != null) ...[
                          const Divider(height: 24),
                          for (final stage in CheckStage.values)
                            _stage(c, stage, _report!.results[stage]!),
                        ],
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: [
                            TextButton.icon(
                              onPressed: _checking ? null : _check,
                              icon: const Icon(Icons.network_check, size: 18),
                              label: Text(
                                _checking
                                    ? ngL.ng_testing
                                    : ngL.ng_test_connection,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: scope.signInAgain,
                              icon: const Icon(Icons.login, size: 18),
                              label: Text(ngL.ng_sign_in_again_2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ...[
                    NgSectionLabel(ngL.ng_saved_gateways),
                    NgCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Column(
                        children: [
                          for (final other in scope.connections)
                            NgRow(
                              icon: other.id == conn.id
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              title: other.label,
                              subtitle: other.singleLogin
                                  ? (other.singleLoginUrl ?? other.baseUrl)
                                  : ngL.ng_classic_connection(other.baseUrl),
                              trailing: other.id == conn.id
                                  ? ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 96,
                                      ),
                                      child: NgPill(
                                        ngL.ng_in_use,
                                        tone: NgTone.accent,
                                      ),
                                    )
                                  : null,
                              onTap: other.id == conn.id
                                  ? null
                                  : () => scope.switchTo(other.id),
                            ),
                          NgRow(
                            icon: Icons.add,
                            title: ngL.ng_add_a_gateway,
                            onTap: scope.addGateway,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SettingsItem(
              id: 'models',
              category: SettingsCategory.connections,
              title: (l) => l.ng_model_management,
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NgSectionLabel(ngL.ng_models_and_providers),
                  NgCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: NgRow(
                      key: const ValueKey('ng-settings-model-management'),
                      icon: Icons.tune,
                      title: ngL.ng_model_management,
                      subtitle: ngL.ng_default_fallback_and_auxiliary_models,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => NgModelsPage(
                            connection: conn,
                            client: scope.gateway.dashboard,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SettingsItem(
              id: 'ng.connection.sign-out',
              category: SettingsCategory.security,
              scope: SettingsScope.nextgen,
              title: (l) => l.ng_sign_out,
              builder: (_) => NgCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ngL.settings_danger,
                      style: NgType.heading.copyWith(color: c.danger),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: c.danger),
                      onPressed: () => _signOut(conn),
                      icon: const Icon(Icons.logout),
                      label: Text(ngL.ng_sign_out_of(conn.label)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut(SavedConnection conn) async {
    final generation = _generation;
    final scope = NgScope.of(context);
    final ok = await ngConfirm(
      context,
      title: ngL.ng_sign_out_of(conn.label),
      body: ngL.ng_this_gateway_and_its_saved_sign,
      confirm: ngL.ng_sign_out,
    );
    if (!ok || !mounted || generation != _generation) return;
    await scope.signOut(conn);
  }

  Widget _kv(NgColors c, String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: NgType.label.copyWith(color: c.text3)),
        const SizedBox(height: 4),
        Text(v, style: NgType.label.copyWith(color: c.text)),
      ],
    ),
  );

  Widget _stage(NgColors c, CheckStage stage, StageResult r) {
    final (icon, color) = switch (r.outcome) {
      CheckOutcome.passed => (Icons.check_circle, c.success),
      CheckOutcome.failed => (Icons.cancel, c.danger),
      CheckOutcome.checking => (Icons.more_horiz, c.accent),
      CheckOutcome.skipped => (Icons.remove_circle_outline, c.text3),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stage.label, style: NgType.label.copyWith(color: c.text)),
                Text(r.detail, style: NgType.caption.copyWith(color: c.text2)),
                if (r.fix != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      r.fix!,
                      style: NgType.caption.copyWith(color: c.accentText),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kyllene's notification settings: replies and requests while the app is
/// out of sight, and keeping a running reply connected in the background.
class NgNotificationSettings extends StatelessWidget {
  const NgNotificationSettings({super.key});

  static const _replyKinds = [
    HermesNotificationKind.turnDone,
    HermesNotificationKind.turnError,
  ];
  static const _requestKinds = [
    HermesNotificationKind.approval,
    HermesNotificationKind.input,
  ];

  Future<void> _setKinds(List<HermesNotificationKind> kinds, bool on) async {
    for (final k in kinds) {
      await NotificationPrefsStore.setKind(k, on);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    return NgCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListenableBuilder(
        listenable: Listenable.merge([
          notificationPrefs,
          backgroundWorkEnabled,
        ]),
        builder: (context, _) {
          final prefs = notificationPrefs.value;
          final on = prefs.enabled;
          bool all(List<HermesNotificationKind> kinds) =>
              kinds.every((k) => prefs.kinds[k] == true);
          return Column(
            children: [
              SwitchListTile(
                key: const ValueKey('ng-notify-enabled'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: Text(ngL.ng_notifications),
                subtitle: Text(ngL.ng_notifications_hint),
                value: on,
                onChanged: (v) async {
                  await NotificationPrefsStore.setEnabled(v);
                  if (v) {
                    await TurnNotificationService.shared.ensureInitialized(
                      requestPermission: true,
                    );
                  }
                },
              ),
              SwitchListTile(
                key: const ValueKey('ng-notify-replies'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: Text(ngL.ng_notify_replies),
                subtitle: Text(ngL.ng_notify_replies_hint),
                value: on && all(_replyKinds),
                onChanged: on ? (v) => _setKinds(_replyKinds, v) : null,
              ),
              SwitchListTile(
                key: const ValueKey('ng-notify-requests'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: Text(ngL.ng_notify_requests),
                subtitle: Text(ngL.ng_notify_requests_hint),
                value: on && all(_requestKinds),
                onChanged: on ? (v) => _setKinds(_requestKinds, v) : null,
              ),
              CompletionSoundSettings(prefs: prefs),
              if (!isWindowsPlatform)
                SwitchListTile(
                  key: const ValueKey('ng-keep-running'),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: Text(ngL.ng_keep_running),
                  subtitle: Text(ngL.ng_keep_running_hint),
                  value: backgroundWorkEnabled.value,
                  onChanged: (v) =>
                      BackgroundWorkPrefsStore.setEnabled(v).catchError((_) {}),
                ),
              if (!isWindowsPlatform)
                NgRow(
                  icon: Icons.battery_saver_outlined,
                  title: ngL.ng_battery_settings,
                  subtitle: ngL.ng_battery_settings_hint,
                  onTap: () => BackgroundWorkPlatform.openBatterySettings(),
                ),
              NgRow(
                key: const ValueKey('ng-recent-notifications'),
                icon: Icons.history,
                title: ngL.ng_recent_notifications,
                subtitle: isWindowsPlatform
                    ? ngL.windows_notification_diagnostics
                    : ngL.ng_recent_notifications_hint,
                onTap: () {
                  unawaited(TurnNotificationService.loadRecentAttempts());
                  showNgSheet<void>(
                    context,
                    builder: (_) => const NgRecentNotificationsSheet(),
                  );
                },
              ),
              NgRow(
                icon: Icons.notifications_active_outlined,
                title: ngL.ng_send_test_notification,
                onTap: () async {
                  final ok = await TurnNotificationService.shared
                      .sendTestNotification(
                        title: ngL.ng_test_notification_title,
                        body: ngL.ng_test_notification_body,
                      );
                  if (context.mounted) {
                    ngToast(
                      context,
                      ok
                          ? ngL.ng_test_notification_sent
                          : isWindowsPlatform
                          ? ngL.windows_notifications_blocked
                          : ngL.ng_notifications_blocked,
                    );
                  }
                },
              ),
              if (!on)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 10),
                  child: Text(
                    ngL.ng_notifications_off_hint,
                    style: NgType.caption.copyWith(color: c.text3),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// What Ares tried to post lately and what came of it, so a notification
/// that never showed can be explained on the device. Earlier runs' entries
/// keep only kind, id, outcome and error class.
class NgRecentNotificationsSheet extends StatelessWidget {
  const NgRecentNotificationsSheet({super.key});

  static String _detail(String detail) =>
      TurnNotificationService.localizedAttemptDetail(ngL, detail);

  @override
  Widget build(BuildContext context) {
    final c = NgColors.of(context);
    final service = TurnNotificationService.shared;
    return SafeArea(
      child: ValueListenableBuilder<List<NotificationAttempt>>(
        valueListenable: TurnNotificationService.recentAttempts,
        builder: (context, attempts, _) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.7,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            children: [
              Text(
                ngL.ng_recent_notifications,
                style: NgType.heading.copyWith(color: c.text),
              ),
              const SizedBox(height: 6),
              Text(
                [
                  service.permissionGranted
                      ? ngL.ng_notify_permission_granted
                      : ngL.ng_notify_permission_denied,
                  notificationPrefs.value.enabled
                      ? ngL.ng_notify_master_on
                      : ngL.ng_notify_master_off,
                ].join(' · '),
                style: NgType.bodySmall.copyWith(color: c.text2),
              ),
              const SizedBox(height: 12),
              if (attempts.isEmpty)
                Text(
                  ngL.ng_recent_notifications_empty,
                  style: NgType.bodySmall.copyWith(color: c.text3),
                ),
              for (final a in attempts)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        a.succeeded
                            ? Icons.check_circle_outline
                            : switch (a.outcome) {
                                'skipped' => Icons.remove_circle_outline,
                                'unknown' => Icons.help_outline,
                                _ => Icons.error_outline,
                              },
                        size: 18,
                        color: a.succeeded
                            ? c.success
                            : switch (a.outcome) {
                                'skipped' => c.text3,
                                'unknown' => c.text2,
                                _ => c.danger,
                              },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${ngStamp(context, a.at, seconds: true)} · ${a.kind} · ${a.outcome}',
                              style: NgType.caption.copyWith(color: c.text3),
                            ),
                            if (a.title.isNotEmpty)
                              Text(
                                a.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: NgType.bodySmall.copyWith(color: c.text),
                              ),
                            if (a.reference.isNotEmpty)
                              Text(
                                a.reference,
                                style: NgType.caption.copyWith(color: c.text2),
                              ),
                            if (a.detail != null)
                              Text(
                                _detail(a.detail!),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: NgType.caption.copyWith(
                                  color: a.outcome == 'failed'
                                      ? c.danger
                                      : c.text2,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
