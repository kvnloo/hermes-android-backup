/// Shared "Desktop integration" settings card for Classic and NextGen.
///
/// Shown on Windows, macOS and Linux only. Every switch is device-local and
/// off by default; the card edits [DesktopOsPrefs] and the running
/// [DesktopIntegration] applies the change natively.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide ShortcutRegistry;
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../services/shortcuts_store.dart';
import '../widgets/keyboard_shortcuts_settings_card.dart'
    show shortcutActionLabel, showShortcutChordEditor;
import 'desktop_integration.dart';
import 'desktop_os.dart';
import 'global_hotkey.dart';
import 'tray_controller.dart';

/// The settings text for a rejected hotkey chord.
String hotkeyProblemText(AppLocalizations l, HotkeyCheck check) =>
    switch (check.problem) {
      HotkeyProblem.noModifier || null => l.desktop_hotkey_no_modifier,
      HotkeyProblem.superKey => l.desktop_hotkey_super_key,
      HotkeyProblem.reserved => l.desktop_hotkey_reserved,
      HotkeyProblem.inAppShortcut => l.desktop_hotkey_in_app(
        shortcutActionLabel(l, check.action ?? ShortcutAction.commandPalette),
      ),
    };

class DesktopIntegrationCard extends StatelessWidget {
  const DesktopIntegrationCard({
    required this.preferences,
    this.integration,
    super.key,
  });

  final SharedPreferences preferences;

  /// Defaults to [DesktopIntegration.current].
  final DesktopIntegration? integration;

  Future<void> _changeHotkey(
    BuildContext context,
    DesktopOsPrefs prefs,
    GlobalHotkeyController? hotkey,
    KeyChord current,
    TargetPlatform platform,
  ) async {
    final l = context.sharedL10n;
    final next = await showShortcutChordEditor(
      context,
      title: l.desktop_hotkey_setting,
      initial: current,
    );
    if (next == null || !context.mounted) return;
    final check =
        hotkey?.check(next) ??
        checkGlobalHotkey(
          next,
          platform: platform,
          inApp: ShortcutsStore(preferences).allBindings(),
        );
    if (!check.isOk) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          key: const Key('desktop-hotkey-rejected'),
          content: Text(hotkeyProblemText(l, check)),
        ),
      );
      return;
    }
    await prefs.setHotkeyChord(next.serialize());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.sharedL10n;
    final prefs = DesktopOsPrefs(preferences);
    final running = integration ?? DesktopIntegration.current;
    final hotkey = running?.hotkey;
    final platform = hotkey?.platform ?? defaultTargetPlatform;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Card(
      key: const Key('desktop-integration-card'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ValueListenableBuilder<int>(
          valueListenable: desktopOsPrefsChanges,
          builder: (context, _, _) {
            final chord =
                KeyChord.parse(prefs.hotkeyChord) ??
                defaultQuickEntryChord(platform);
            final chordLabel = formatKeyChord(
              chord,
              appleSymbols: platform == TargetPlatform.macOS,
            );
            String hotkeyText(HotkeyStatus status) => switch (status) {
              HotkeyStatus.off => chordLabel,
              HotkeyStatus.registered => l.desktop_hotkey_help(chordLabel),
              HotkeyStatus.conflict => l.desktop_hotkey_conflict(chordLabel),
              HotkeyStatus.unsupported => l.desktop_hotkey_unsupported,
              HotkeyStatus.invalid => hotkeyProblemText(
                l,
                hotkey?.lastCheck ?? HotkeyCheck.ok,
              ),
            };
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.desktop_windows_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l.desktop_integration_title,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                _supportGate(
                  running?.tray.supported,
                  supported: () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        key: const Key('desktop-tray-switch'),
                        title: Text(l.desktop_tray_setting),
                        subtitle: Text(l.desktop_tray_setting_help),
                        value: prefs.trayEnabled,
                        onChanged: (value) => prefs.setTrayEnabled(value),
                      ),
                      SwitchListTile(
                        key: const Key('desktop-close-to-tray-switch'),
                        title: Text(l.desktop_close_to_tray_setting),
                        value: prefs.closeToTray,
                        onChanged: prefs.trayEnabled
                            ? (value) => prefs.setCloseToTray(value)
                            : null,
                      ),
                      if (running != null)
                        ValueListenableBuilder<TrayStatus>(
                          valueListenable: running.tray.status,
                          builder: (context, status, _) =>
                              status == TrayStatus.unsupported
                              ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    8,
                                  ),
                                  child: Text(
                                    l.desktop_tray_unsupported,
                                    key: const Key('desktop-tray-unsupported'),
                                    style: muted,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                    ],
                  ),
                  // One honest, disabled row instead of switches that could
                  // only fail after being turned on.
                  unsupported: () => ListTile(
                    key: const Key('desktop-tray-unavailable'),
                    enabled: false,
                    leading: const Icon(Icons.block_outlined),
                    title: Text(l.desktop_tray_setting),
                    subtitle: Text(
                      l.desktop_tray_unsupported,
                      key: const Key('desktop-tray-unsupported'),
                    ),
                  ),
                ),
                const Divider(height: 16),
                _supportGate(
                  hotkey?.supported,
                  supported: () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        key: const Key('desktop-hotkey-switch'),
                        title: Text(l.desktop_hotkey_setting),
                        subtitle: ValueListenableBuilder<HotkeyStatus>(
                          valueListenable: hotkey!.status,
                          builder: (context, status, _) => Text(
                            hotkeyText(status),
                            key: Key('desktop-hotkey-status-${status.name}'),
                          ),
                        ),
                        value: prefs.hotkeyEnabled,
                        onChanged: (value) => prefs.setHotkeyEnabled(value),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Wrap(
                          spacing: 8,
                          children: [
                            TextButton(
                              key: const Key('desktop-hotkey-change'),
                              onPressed: () => _changeHotkey(
                                context,
                                prefs,
                                hotkey,
                                chord,
                                platform,
                              ),
                              child: Text(l.desktop_hotkey_change),
                            ),
                            if (prefs.hotkeyChord != null)
                              TextButton(
                                key: const Key('desktop-hotkey-reset'),
                                onPressed: () => prefs.setHotkeyChord(null),
                                child: Text(l.desktop_hotkey_reset),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  unsupported: () => ListTile(
                    key: const Key('desktop-hotkey-unavailable'),
                    enabled: false,
                    leading: const Icon(Icons.block_outlined),
                    title: Text(l.desktop_hotkey_setting),
                    subtitle: Text(
                      l.desktop_hotkey_unsupported,
                      key: const Key('desktop-hotkey-status-unsupported'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Shows [supported] only once the runner has said it can do it, and one
  /// disabled row with the reason when it cannot. Nothing while it has not
  /// answered (or no integration runs in this window).
  static Widget _supportGate(
    ValueListenable<bool?>? support, {
    required Widget Function() supported,
    required Widget Function() unsupported,
  }) {
    if (support == null) return const SizedBox.shrink();
    return ValueListenableBuilder<bool?>(
      valueListenable: support,
      builder: (context, value, _) => switch (value) {
        true => supported(),
        false => unsupported(),
        null => const SizedBox.shrink(),
      },
    );
  }
}
