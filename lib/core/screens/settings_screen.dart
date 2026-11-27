// Device settings, appearance, connection information and app info.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../parked_automotive.dart';
import '../settings/settings_browser.dart';
import '../services/theme_preference.dart';
import 'model_management_screen.dart';
import '../services/app_licenses.dart';
import '../utils/platform_capabilities.dart';
import '../widgets/completion_sound_settings.dart';
import '../widgets/recent_notifications_sheet.dart';
import '../services/locale_preference.dart';
import 'provider_oauth_screen.dart';
import '../services/config_backup_io.dart';
import '../services/config_backup_service.dart';
import '../services/connection_manager.dart';
import '../services/auto_speak_replies.dart';
import '../services/barge_in_preference.dart';
import '../services/desktop_gateway_client.dart';
import '../services/gateway_wake_word.dart';
import '../services/gpt_live_conversation.dart';
import '../services/voice_live_mode.dart';
import '../widgets/gateway_wake_controls.dart';
import '../widgets/voice_live_controls.dart';
import '../services/hands_free_preference.dart';
import '../services/notification_prefs.dart';
import '../widgets/background_work_settings.dart';
import '../services/turn_notification_service.dart';
import '../widgets/config_backup_card.dart';
import '../widgets/mobile_push_settings.dart';
import '../widgets/chat_density_settings_card.dart';
import '../widgets/text_size_settings_card.dart';
import '../widgets/keep_awake_settings_card.dart';
import '../widgets/desktop_shortcuts.dart' show desktopShortcutsAvailable;
import '../widgets/keyboard_shortcuts_settings_card.dart';
import '../widgets/theme_palette_picker.dart';
import '../theme/hermes_theme.dart';
import '../presentation/presentation_settings.dart';
import '../../main.dart';
import '../../nextgen/nextgen_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/legal_links.dart';
import '../desktop/desktop_integration_card.dart';
import '../desktop/desktop_os.dart';

import 'package:hermes_android/core/l10n/l10n.dart';

class SettingsScreen extends StatefulWidget {
  final SavedConnection connection;
  final DashboardClient? dashboardClient;
  final ConnectionManager? connectionManager;
  final SettingsMode mode;
  final List<SettingsItem> extraItems;
  final SettingsCategory? initialCategory;
  final String? initialTarget;
  const SettingsScreen({
    required this.connection,
    this.dashboardClient,
    this.connectionManager,
    this.mode = SettingsMode.classic,
    this.extraItems = const [],
    this.initialCategory,
    this.initialTarget,
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ConnectionManager get _manager =>
      widget.connectionManager ??
      context.findAncestorStateOfType<HermesAppState>()!.widget.connManager;

  @override
  Widget build(BuildContext context) {
    final prefs = _manager.prefs;
    final app = context.findAncestorStateOfType<HermesAppState>();
    return SettingsBrowser(
      key: ValueKey((
        widget.mode,
        widget.connection.id,
        widget.connection.gatewayProfile,
        widget.connection.baseUrl,
        widget.dashboardClient,
      )),
      mode: widget.mode,
      initialCategory: widget.initialCategory,
      initialTarget: widget.initialTarget,
      items: [
        ...widget.extraItems.where(
          (item) => item.id != 'ng.connection.sign-out',
        ),
        SettingsItem(
          id: 'interface.mode',
          category: SettingsCategory.general,
          title: (l) => l.nextgen_toggle,
          summary: (l) => nextGenEnabled.value
              ? l.setup_interface_nextgen
              : l.setup_interface_classic,
          builder: (_) => Card(
            child: ValueListenableBuilder<bool>(
              valueListenable: nextGenEnabled,
              builder: (context, enabled, _) => SwitchListTile(
                key: const ValueKey('nextgen-toggle'),
                secondary: const Icon(Icons.auto_awesome),
                title: Text(context.l10n.nextgen_toggle),
                subtitle: Text(context.l10n.nextgen_toggle_subtitle),
                value: enabled,
                onChanged: (value) =>
                    NextGenPreferences.setEnabled(prefs, value),
              ),
            ),
          ),
        ),
        SettingsItem(
          id: 'language',
          category: SettingsCategory.general,
          title: (l) => l.app_language,
          summary: (l) =>
              '${l.app_language}: ${LocalePreference.read(prefs) == null ? l.app_language_system : LocalePreference.name(LocalePreference.read(prefs)!)}',
          builder: (context) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DropdownButtonFormField<String>(
                key: ValueKey(
                  'app-language-${LocalePreference.read(prefs)?.toLanguageTag() ?? 'system'}',
                ),
                initialValue:
                    LocalePreference.read(prefs)?.toLanguageTag() ?? 'system',
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: context.l10n.app_language,
                  prefixIcon: const Icon(Icons.language),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'system',
                    child: Text(context.l10n.app_language_system),
                  ),
                  for (final locale in preferredSupportedLocales())
                    DropdownMenuItem(
                      value: locale.toLanguageTag(),
                      child: Text(LocalePreference.name(locale)),
                    ),
                ],
                onChanged: (tag) async {
                  final locale = tag == 'system'
                      ? null
                      : preferredSupportedLocales().firstWhere(
                          (l) => l.toLanguageTag() == tag,
                        );
                  if (app != null) {
                    await app.setLocale(locale);
                  } else {
                    await LocalePreference.save(prefs, locale);
                  }
                  if (mounted) setState(() {});
                },
              ),
            ),
          ),
        ),
        SettingsItem(
          id: 'classic.theme',
          category: SettingsCategory.appearance,
          scope: SettingsScope.classic,
          title: (l) => l.ng_theme,
          summary: (l) =>
              '${l.ng_theme}: ${switch (ThemePreferenceStore(prefs).readMode()) {
                ThemeMode.light => l.ng_light,
                ThemeMode.dark => l.ng_dark,
                ThemeMode.system => l.ng_system,
              }}',
          builder: (_) => ThemeAppearanceSettings(
            preferences: prefs,
            onChanged: app?.refreshAppearancePreferences ?? () {},
          ),
        ),
        SettingsItem(
          id: 'text-size',
          category: SettingsCategory.appearance,
          title: (l) => l.text_size,
          builder: (_) => TextSizeSettingsCard(
            preferences: prefs,
            onChanged: (preference) => app?.setTextSizePreference(preference),
          ),
        ),
        SettingsItem(
          id: 'presentation',
          category: SettingsCategory.appearance,
          title: (l) => l.appearance_imported_themes,
          targets: [
            SettingsTarget(
              'presentation.font.chat',
              (l) => l.appearance_chat_font,
              const ValueKey('presentation-chat-font'),
            ),
            SettingsTarget(
              'presentation.font.terminal',
              (l) => l.appearance_terminal_font,
              const ValueKey('presentation-terminal-font'),
            ),
            SettingsTarget(
              'presentation.direction',
              (l) => l.appearance_tour_direction_title,
              const ValueKey('presentation-direction'),
            ),
            SettingsTarget(
              'presentation.bubble',
              (l) => l.appearance_user_bubble_opacity,
              const ValueKey('presentation-bubble-opacity'),
            ),
            SettingsTarget(
              'presentation.embeds',
              (l) => l.appearance_inline_embeds,
              const ValueKey('presentation-embeds'),
            ),
            SettingsTarget(
              'presentation.reactions',
              (l) => l.appearance_emoji_reactions,
              const ValueKey('presentation-reactions'),
            ),
            SettingsTarget(
              'presentation.hearts',
              (l) => l.appearance_celebration_hearts,
              const ValueKey('presentation-hearts'),
            ),
            SettingsTarget(
              'presentation.pet.enabled',
              (l) => l.appearance_pet_companion,
              const ValueKey('presentation-pet-enabled'),
            ),
            SettingsTarget(
              'presentation.radio.enabled',
              (l) => l.appearance_radio,
              const ValueKey('presentation-radio-enabled'),
            ),
            SettingsTarget(
              'presentation.tour',
              (l) => l.appearance_replay_tour,
              const ValueKey('presentation-replay-tour'),
            ),
          ],
          terms: (l) =>
              '${l.appearance_chat_font} ${l.appearance_terminal_font} ${l.appearance_tour_direction_title} ${l.appearance_inline_embeds} ${l.appearance_pet_companion} ${l.appearance_radio} ${l.appearance_replay_tour}',
          builder: (_) => PresentationSettingsPanel(preferences: prefs),
        ),
        SettingsItem(
          id: 'classic.chat.density',
          category: SettingsCategory.chat,
          scope: SettingsScope.classic,
          title: (l) => l.chat_density,
          builder: (_) => ChatDensitySettingsCard(preferences: prefs),
        ),
        SettingsItem(
          id: 'classic.chat.verbose',
          category: SettingsCategory.chat,
          scope: SettingsScope.classic,
          title: (l) => l.verbose_mode,
          builder: (_) => _VerboseToggle(),
        ),
        SettingsItem(
          id: 'classic.session.sources',
          category: SettingsCategory.chat,
          scope: SettingsScope.classic,
          title: (l) => l.session_sources,
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context.l10n.session_sources),
              _SessionSourcesFilter(connectionId: widget.connection.id),
            ],
          ),
        ),
        if (!isParkedAutomotive) ...[
          SettingsItem(
            id: 'voice.reply',
            category: SettingsCategory.voice,
            title: (l) => l.voice,
            builder: (_) => _VoicePicker(),
          ),
          SettingsItem(
            id: 'classic.voice.handsfree',
            category: SettingsCategory.voice,
            scope: SettingsScope.classic,
            title: (l) => l.hands_free_settings_title,
            builder: (_) => const _HandsFreeToggle(),
          ),
          SettingsItem(
            id: 'voice.auto-read',
            category: SettingsCategory.voice,
            title: (l) => l.auto_speak_replies_title,
            builder: (_) => const _AutoSpeakToggle(),
          ),
          SettingsItem(
            id: 'voice.barge-in',
            category: SettingsCategory.voice,
            title: (l) => l.barge_in_title,
            builder: (_) => const _BargeInToggle(),
          ),
          if (widget.mode == SettingsMode.classic)
            SettingsItem(
              id: 'voice.gateway',
              category: SettingsCategory.voice,
              title: (l) => l.wake_word_title,
              builder: (_) => _ClassicWakeSettings(
                key: ValueKey(
                  '${widget.connection.id}-${widget.connection.gatewayProfile}',
                ),
                connection: widget.connection,
                dashboardClient: widget.dashboardClient,
              ),
            ),
        ],
        if (!isParkedAutomotive &&
            (supportsLocalNotifications ||
                (widget.mode == SettingsMode.nextgen && isWindowsPlatform)))
          SettingsItem(
            id: 'notifications',
            category: SettingsCategory.notifications,
            title: (l) => l.enable_notifications,
            targets: [
              SettingsTarget(
                'notifications.sound',
                (l) => l.completion_sound,
                const ValueKey('completion-sound'),
              ),
              SettingsTarget(
                'notifications.activity',
                (l) => l.chat_activity_share,
                const ValueKey('share-chat-activity'),
              ),
              SettingsTarget(
                'notifications.mute',
                (l) => l.app_sounds_mute,
                const ValueKey('mute-app-sounds'),
              ),
              SettingsTarget(
                'notifications.test',
                (l) => l.send_test_notification,
                const ValueKey('notifications-test'),
              ),
              SettingsTarget(
                'notifications.recent',
                (l) => l.ng_recent_notifications,
                const ValueKey('classic-recent-notifications'),
              ),
              for (final kind in HermesNotificationKind.values)
                SettingsTarget(
                  'notifications.${kind.name}',
                  (l) => _NotificationSettingsState.kindLabel(l, kind),
                  ValueKey('notifications-${kind.name}'),
                ),
            ],
            terms: (l) =>
                '${l.completion_sound} ${l.app_sounds_mute} ${l.chat_activity_share} ${l.send_test_notification} ${l.ng_recent_notifications}',
            builder: (_) => const _NotificationSettings(),
          ),
        if (supportsAndroidBackgroundWork) ...[
          if (supportsEmbeddedMobilePush && !isParkedAutomotive)
            SettingsItem(
              id: 'notifications.push',
              category: SettingsCategory.notifications,
              title: (l) => l.rel_svc_push_background_notifications,
              builder: (_) => MobilePushSettings(
                connection: widget.connection,
                connectionManager: _manager,
              ),
            ),
          SettingsItem(
            id: 'background',
            category: SettingsCategory.device,
            title: (l) => l.background_work,
            builder: (_) => const BackgroundWorkSettings(),
          ),
        ],
        SettingsItem(
          id: 'device.keep-awake',
          category: SettingsCategory.device,
          title: (l) =>
              isDesktopOs ? l.keep_awake_title : l.keep_awake_title_mobile,
          builder: (_) => KeepAwakeSettingsCard(preferences: prefs),
        ),
        if (isDesktopOs)
          SettingsItem(
            id: 'desktop',
            category: SettingsCategory.device,
            title: (l) => l.desktop_integration_title,
            builder: (_) => DesktopIntegrationCard(preferences: prefs),
          ),
        if (desktopShortcutsAvailable())
          SettingsItem(
            id: 'shortcuts',
            category: SettingsCategory.device,
            title: (l) => l.keyboard_shortcuts_title,
            builder: (_) => KeyboardShortcutsSettingsCard(preferences: prefs),
          ),
        SettingsItem(
          id: 'connection.info',
          category: SettingsCategory.connections,
          title: (l) => l.connection_section,
          summary: (_) => widget.connection.label,
          builder: (context) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(context.l10n.label, widget.connection.label),
                  _infoRow(context.l10n.host, widget.connection.host),
                  _infoRow(context.l10n.port, '${widget.connection.port}'),
                  _infoRow(context.l10n.base_url, widget.connection.baseUrl),
                ],
              ),
            ),
          ),
        ),
        if (widget.mode == SettingsMode.classic)
          SettingsItem(
            id: 'models',
            category: SettingsCategory.connections,
            title: (l) => l.ng_model_management,
            builder: (context) => Card(
              child: ListTile(
                leading: const Icon(Icons.tune),
                title: Text(context.l10n.ng_model_management),
                subtitle: Text(
                  context.l10n.ng_default_fallback_and_auxiliary_models,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ModelManagementScreen(
                      connection: widget.connection,
                      dashboardClient: widget.dashboardClient,
                    ),
                  ),
                ),
              ),
            ),
          ),
        SettingsItem(
          id: 'provider.oauth',
          category: SettingsCategory.connections,
          title: (l) => l.provider_oauth_title,
          builder: (context) => Card(
            child: ListTile(
              leading: const Icon(Icons.login),
              title: Text(context.l10n.provider_oauth_title),
              subtitle: Text(context.l10n.provider_oauth_settings_subtitle),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) =>
                      ProviderOAuthScreen(connection: widget.connection),
                ),
              ),
            ),
          ),
        ),
        SettingsItem(
          id: 'about.privacy',
          category: SettingsCategory.security,
          title: (l) => l.privacy_policy,
          builder: (context) => Card(
            child: ListTile(
              key: const ValueKey('privacy-policy-link'),
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(context.l10n.privacy_policy),
              trailing: const Icon(Icons.open_in_new),
              onTap: openAresPrivacyPolicy,
            ),
          ),
        ),
        SettingsItem(
          id: 'backup',
          category: SettingsCategory.security,
          title: (l) => l.backup_restore,
          builder: (_) => ConfigBackupCard(
            onExport: _exportConfig,
            onDeliverExport: _deliverExport,
            onPickBackupFile: _pickBackupFile,
            onImport: _importConfig,
          ),
        ),
        SettingsItem(
          id: 'about',
          category: SettingsCategory.about,
          title: (l) => l.about,
          terms: (l) => l.ng_licences,
          builder: (_) => _AboutCard(),
        ),
        ...widget.extraItems.where(
          (item) => item.id == 'ng.connection.sign-out',
        ),
      ],
    );
  }

  ConfigBackupIo _backupIo() {
    return ConfigBackupIo(connectionManager: _manager);
  }

  Future<String> _exportConfig(String passphrase) {
    return _backupIo().exportEncrypted(passphrase);
  }

  Future<String?> _deliverExport(String contents) {
    return _backupIo().deliverExport(contents);
  }

  Future<String?> _pickBackupFile() {
    return _backupIo().pickBackupFile();
  }

  Future<ConfigImportResult> _importConfig(
    String contents,
    String passphrase,
    ConfigImportMode mode,
  ) async {
    final result = await _backupIo().importEncrypted(
      contents,
      passphrase,
      mode,
    );
    if (mounted) {
      // Re-read palette, brightness and text size without replacing any routes.
      context
          .findAncestorStateOfType<HermesAppState>()
          ?.refreshAppearancePreferences();
    }
    return result;
  }

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: Theme.of(context).textTheme.titleSmall),
  );

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: HermesTokens.of(context).muted,
            ),
          ),
        ),
        Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}

/// About card that reads the real version from package_info_plus.
class _AboutCard extends StatefulWidget {
  @override
  State<_AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<_AboutCard> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() => _version = '${info.version}+${info.buildNumber}');
    } catch (_) {
      if (!mounted) return;
      setState(() => _version = 'unknown');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.hermes_agent_for_android,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.version_label(_version.isNotEmpty ? _version : '…'),
            ),
            const SizedBox(height: 8),
            Text(
              context
                  .l10n
                  .browse_and_manage_your_hermes_agent_sessions_from_your_phone,
              style: TextStyle(color: HermesTokens.of(context).muted),
            ),
            const Divider(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(MaterialLocalizations.of(context).licensesPageTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                registerAppLicenses();
                showLicensePage(
                  context: context,
                  applicationName: context.l10n.hermes_agent_for_android,
                  applicationVersion: _version,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Toggle for verbose mode — shows tool calls, thinking, and message metadata in chat.
class _VerboseToggle extends StatefulWidget {
  @override
  State<_VerboseToggle> createState() => _VerboseToggleState();
}

class _VerboseToggleState extends State<_VerboseToggle> {
  bool _verbose = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _verbose = prefs.getBool('verbose_mode') ?? false);
  }

  Future<void> _set(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('verbose_mode', value);
    if (mounted) setState(() => _verbose = value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SwitchListTile(
        title: Text(context.l10n.verbose_mode),
        subtitle: Text(
          context.l10n.show_tool_calls_thinking_and_message_metadata,
        ),
        secondary: const Icon(Icons.terminal),
        value: _verbose,
        onChanged: _set,
      ),
    );
  }
}

class _HandsFreeToggle extends StatelessWidget {
  const _HandsFreeToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: handsFreeEnabled,
      builder: (context, enabled, _) => Card(
        child: SwitchListTile(
          secondary: const Icon(Icons.record_voice_over_outlined),
          title: Text(context.l10n.hands_free_settings_title),
          subtitle: Text(context.l10n.hands_free_settings_subtitle),
          value: enabled,
          onChanged: (on) => unawaited(HandsFreePreferenceStore.setEnabled(on)),
        ),
      ),
    );
  }
}

class _AutoSpeakToggle extends StatelessWidget {
  const _AutoSpeakToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: autoSpeakRepliesEnabled,
      builder: (context, enabled, _) => Card(
        child: SwitchListTile(
          secondary: const Icon(Icons.record_voice_over_outlined),
          title: Text(context.l10n.auto_speak_replies_title),
          subtitle: Text(context.l10n.auto_speak_replies_subtitle),
          value: enabled,
          onChanged: (on) => unawaited(AutoSpeakRepliesStore.setEnabled(on)),
        ),
      ),
    );
  }
}

class _BargeInToggle extends StatelessWidget {
  const _BargeInToggle();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: bargeInEnabled,
      builder: (context, enabled, _) => Card(
        child: SwitchListTile(
          secondary: const Icon(Icons.mic_outlined),
          title: Text(context.l10n.barge_in_title),
          subtitle: Text(context.l10n.barge_in_subtitle),
          value: enabled,
          onChanged: (on) => unawaited(BargeInPreferenceStore.setEnabled(on)),
        ),
      ),
    );
  }
}

/// Gateway-owned wake controls. Reuses the chat's controller when one exists
/// so Settings never becomes a second owner of the microphone; otherwise a
/// short-lived client connects on demand and is closed with the screen.
class _ClassicWakeSettings extends StatefulWidget {
  const _ClassicWakeSettings({
    required this.connection,
    this.dashboardClient,
    super.key,
  });

  final SavedConnection connection;
  final DashboardClient? dashboardClient;

  @override
  State<_ClassicWakeSettings> createState() => _ClassicWakeSettingsState();
}

class _ClassicWakeSettingsState extends State<_ClassicWakeSettings> {
  DesktopGatewayClient? _ownedGateway;
  GatewayWakeWordController? _controller;
  VoiceLiveModeController? _voiceMode;
  bool _ownsVoiceMode = false;

  @override
  void initState() {
    super.initState();
    final connection = widget.connection;
    final hasGateway =
        (connection.desktopGatewayUrl?.trim().isNotEmpty ?? false) ||
        connection.hasDashboardAuth;
    if (!hasGateway) return;
    _controller = GatewayWakeWordController.sharedForConnection(connection.id);
    if (_controller == null) {
      _ownedGateway = DesktopGatewayClient.fromConnection(connection);
      _controller = _ownedGateway!.wakeWord;
    }
    _voiceMode = VoiceLiveModeController.sharedForConnection(
      connection.id,
      profile: connection.gatewayProfile,
    );
    if (_voiceMode == null) {
      if (_ownedGateway != null && widget.dashboardClient == null) {
        _voiceMode = _ownedGateway!.voiceLiveMode;
      } else {
        _ownsVoiceMode = true;
        _voiceMode = VoiceLiveModeController(
          connectionId: connection.id,
          profile: connection.gatewayProfile,
          transport: widget.dashboardClient != null
              ? GptLiveGatewayTransport.fromDashboard(
                  widget.dashboardClient!,
                  profile: connection.gatewayProfile,
                )
              : GptLiveGatewayTransport(
                  connection,
                  profile: connection.gatewayProfile,
                ),
          rpc: _ownedGateway == null
              ? null
              : (method, params) => _ownedGateway!.call(method, params),
          registerShared: false,
        );
      }
    }
    unawaited(_controller!.refreshStatus());
    unawaited(_controller!.refreshClientInputDevices());
    unawaited(_voiceMode!.refresh());
  }

  @override
  void dispose() {
    if (_ownsVoiceMode) _voiceMode?.dispose();
    _ownedGateway?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final voiceMode = _voiceMode;
    if (controller == null && voiceMode == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (voiceMode != null)
              ListenableBuilder(
                listenable: voiceMode,
                builder: (context, _) => voiceMode.hasStatus
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: VoiceEngineSettingsPanel(controller: voiceMode),
                      )
                    : const SizedBox.shrink(),
              ),
            if (controller != null)
              GatewayWakeSettingsPanel(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _VoicePicker extends StatefulWidget {
  @override
  State<_VoicePicker> createState() => _VoicePickerState();
}

class _VoicePickerState extends State<_VoicePicker> {
  final FlutterTts _tts = FlutterTts();
  final List<Map<String, String>> _voices = [];
  String? _selectedVoiceName;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedVoiceName = prefs.getString('voice_name');

    try {
      final raw = await _tts.getVoices;
      if (raw is List && raw.isNotEmpty) {
        for (final item in raw) {
          if (item is Map) {
            final m = <String, String>{};
            m['name'] = (item['name'] ?? '').toString();
            m['locale'] = (item['locale'] ?? '').toString();
            if (m['name']!.isNotEmpty) _voices.add(m);
          }
        }
      }
    } catch (_) {}

    if (_voices.isEmpty) {
      try {
        final raw = await _tts.getLanguages;
        final seen = <String>{};
        if (raw is List) {
          for (final item in raw) {
            final lang = item.toString();
            if (lang.isNotEmpty && seen.add(lang)) {
              _voices.add({'name': lang, 'locale': lang});
            }
          }
        }
      } catch (_) {}
    }

    _voices.sort((a, b) => (a['locale'] ?? '').compareTo(b['locale'] ?? ''));

    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _set(Map<String, String>? voice) async {
    final prefs = await SharedPreferences.getInstance();
    if (voice == null) {
      await prefs.remove('voice_name');
      await prefs.remove('voice_locale');
      // Check immediately before setState: the awaits above can outlive the
      // widget, and a mounted check before them does not cover the gap.
      if (!mounted) return;
      setState(() => _selectedVoiceName = null);
    } else {
      final name = voice['name'] ?? '';
      final locale = voice['locale'] ?? '';
      await prefs.setString('voice_name', name);
      await prefs.setString('voice_locale', locale);
      if (!mounted) return;
      setState(() => _selectedVoiceName = name);
    }
  }

  String _voiceLabel(Map<String, String> voice) {
    final name = voice['name'] ?? '';
    final locale = voice['locale'] ?? '';
    if (name == locale) return locale;
    final gender = name.contains('male')
        ? '(male)'
        : name.contains('female')
        ? '(female)'
        : '';
    return '$locale $gender  [$name]';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_voices.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            context.l10n.no_tts_voices_found_ninstall_google_text_to_speech_and,
            style: TextStyle(color: HermesTokens.of(context).muted),
          ),
        ),
      );
    }

    final items = <DropdownMenuItem<Map<String, String>?>>[
      DropdownMenuItem(
        value: null,
        child: Text(context.l10n.auto_device_default),
      ),
      ..._voices.map(
        (v) => DropdownMenuItem(
          value: v,
          child: Text(
            _voiceLabel(v),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];

    final current = _selectedVoiceName != null
        ? _voices.where((v) => v['name'] == _selectedVoiceName).firstOrNull
        : null;

    return DropdownButtonFormField<Map<String, String>?>(
      initialValue: current,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: context.l10n.voice,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      items: items,
      onChanged: _set,
    );
  }
}

/// Checkbox list of session sources. Unchecked sources are filtered
/// client-side from the fetched session list by `Session.source`.
class _SessionSourcesFilter extends StatefulWidget {
  final String connectionId;
  const _SessionSourcesFilter({required this.connectionId});

  @override
  State<_SessionSourcesFilter> createState() => _SessionSourcesFilterState();
}

class _SessionSourcesFilterState extends State<_SessionSourcesFilter> {
  /// Known session source types. Hermes Gateway persists `session.source` for
  /// every session. Sources not in this list are always shown (whitelisted).
  Map<String, String> get _knownSources => {
    'acp': context.l10n.autonomous_agents,
    'api_server': context.l10n.external_api_clients,
    'cli': context.l10n.command_line_chats,
    'cron': context.l10n.scheduled_tasks,
    'desktop': context.l10n.desktop_app,
    'discord': context.l10n.discord_chats,
    'gateway': context.l10n.gateway_api_access,
    'mobile': context.l10n.phone_or_tablet,
    'signal': context.l10n.signal_messages,
    'slack': context.l10n.slack_chats,
    'telegram': context.l10n.telegram_messages,
    'tool': context.l10n.developer_tool_calls,
    'tui': context.l10n.terminal_sessions,
    'whatsapp': context.l10n.whatsapp_messages,
  };

  Set<String> _excluded = {};

  String get _prefsKey => 'excluded_session_sources_${widget.connectionId}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _excluded = prefs.getStringList(_prefsKey)?.toSet() ?? {};
    });
  }

  Future<void> _toggle(String source, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (enabled) {
        _excluded.remove(source);
      } else {
        _excluded.add(source);
      }
    });
    await prefs.setStringList(_prefsKey, _excluded.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: _knownSources.entries.map((entry) {
          final source = entry.key;
          final label = entry.value;
          final isVisible = !_excluded.contains(source);
          return CheckboxListTile(
            title: Text(label),
            subtitle: Text(
              source,
              style: TextStyle(
                fontSize: 12,
                color: HermesTokens.of(context).muted,
              ),
            ),
            value: isVisible,
            onChanged: (val) => _toggle(source, val ?? true),
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
          );
        }).toList(),
      ),
    );
  }
}

/// Desktop-parity notification settings: one master switch, a toggle per kind,
/// and the same "send test" affordance so a silent OS-level block is visible
/// instead of looking like a dead feature.
class _NotificationSettings extends StatefulWidget {
  const _NotificationSettings();

  @override
  State<_NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<_NotificationSettings>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshPermission(requestPermission: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshPermission();
  }

  void _refreshPermission({bool requestPermission = false}) {
    // Keep the visible hint in sync after returning from OS Settings without
    // asking again. Only the initial foreground visit may request permission.
    unawaited(
      TurnNotificationService.shared
          .ensureInitialized(requestPermission: requestPermission)
          .then((_) {
            if (mounted) setState(() {});
          }),
    );
  }

  static String kindLabel(AppLocalizations l10n, HermesNotificationKind kind) =>
      switch (kind) {
        HermesNotificationKind.approval => l10n.approval_needed,
        HermesNotificationKind.input => l10n.input_needed,
        HermesNotificationKind.turnDone => l10n.response_complete,
        HermesNotificationKind.turnError => l10n.turn_failed,
        HermesNotificationKind.backgroundDone => l10n.background_task_completed,
        HermesNotificationKind.credits => l10n.credit_notifications,
        HermesNotificationKind.plugin => l10n.plugin_notifications,
      };

  static String _kindDescription(
    BuildContext context,
    HermesNotificationKind kind,
  ) => switch (kind) {
    HermesNotificationKind.approval => context.l10n.approval_needed_description,
    HermesNotificationKind.input => context.l10n.input_needed_description,
    HermesNotificationKind.turnDone =>
      context.l10n.response_complete_description,
    HermesNotificationKind.turnError => context.l10n.turn_failed_description,
    HermesNotificationKind.backgroundDone =>
      context.l10n.background_task_completed_description,
    HermesNotificationKind.credits =>
      context.l10n.credit_notifications_description,
    HermesNotificationKind.plugin =>
      context.l10n.plugin_notifications_description,
  };

  Future<void> _sendTest() async {
    final ok = await TurnNotificationService.shared.sendTestNotification(
      title: context.l10n.test_notification_title,
      body: context.l10n.test_notification_body,
    );
    if (!mounted) return;
    setState(() {});
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? context.l10n.test_notification_sent
                : context.l10n.test_notification_unsupported,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NotificationPrefs>(
      valueListenable: notificationPrefs,
      builder: (context, prefs, _) => Card(
        child: Column(
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.notifications_outlined),
              title: Text(context.l10n.enable_notifications),
              subtitle: Text(context.l10n.enable_notifications_description),
              value: prefs.enabled,
              onChanged: (on) async {
                await NotificationPrefsStore.setEnabled(on);
                if (!on) {
                  await TurnNotificationService.shared.cancelAllOngoingChats();
                }
              },
            ),
            CompletionSoundSettings(prefs: prefs),
            for (final kind in HermesNotificationKind.values) ...[
              const Divider(height: 1),
              SwitchListTile(
                key: ValueKey('notifications-${kind.name}'),
                title: Text(kindLabel(context.l10n, kind)),
                subtitle: Text(_kindDescription(context, kind)),
                value: prefs.enabled && prefs.kinds[kind] == true,
                onChanged: prefs.enabled
                    ? (on) =>
                          unawaited(NotificationPrefsStore.setKind(kind, on))
                    : null,
              ),
            ],
            const Divider(height: 1),
            ListTile(
              key: const ValueKey('notifications-test'),
              leading: const Icon(Icons.send_outlined),
              title: Text(context.l10n.send_test_notification),
              onTap: () => unawaited(_sendTest()),
            ),
            const Divider(height: 1),
            ListTile(
              key: const ValueKey('classic-recent-notifications'),
              leading: const Icon(Icons.history),
              title: Text(context.l10n.ng_recent_notifications),
              subtitle: Text(
                isWindowsPlatform
                    ? context.l10n.windows_notification_diagnostics
                    : context.l10n.ng_recent_notifications_hint,
              ),
              onTap: () => unawaited(RecentNotificationsSheet.show(context)),
            ),
            if (!TurnNotificationService.shared.permissionGranted) ...[
              const Divider(height: 1),
              ListTile(
                leading: Icon(
                  Icons.warning_amber_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  isWindowsPlatform
                      ? context.l10n.windows_notifications_blocked
                      : context.l10n.notifications_permission_denied,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
