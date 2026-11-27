/// Shared "Keep computer awake" settings card for Classic and NextGen.
///
/// The card exists only where the runner actually keeps the device awake:
/// it asks `com.hermesagent.ares/power` `isSupported` on mount and renders
/// nothing (not even its section [header]) until the runner says yes. A
/// platform without a working mechanism therefore never offers a setting
/// that would do nothing.
library;

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../services/keep_awake.dart';

class KeepAwakeSettingsCard extends StatefulWidget {
  const KeepAwakeSettingsCard({
    required this.preferences,
    this.powerChannel = MethodChannelKeepAwakeAdapter.channel,
    this.header,
    super.key,
  });

  final SharedPreferences preferences;
  final MethodChannel powerChannel;

  /// Optional section header shown above the card, and hidden with it.
  final Widget? header;

  @override
  State<KeepAwakeSettingsCard> createState() => _KeepAwakeSettingsCardState();
}

class _KeepAwakeSettingsCardState extends State<KeepAwakeSettingsCard> {
  bool _runnerSupported = false;

  @override
  void initState() {
    super.initState();
    _probeRunner();
  }

  Future<void> _probeRunner() async {
    final supported = await isKeepAwakeChannelSupported(widget.powerChannel);
    if (mounted && supported != _runnerSupported) {
      setState(() => _runnerSupported = supported);
    }
  }

  /// Phones and tablets keep the screen on; desktops keep the system awake.
  static bool get _screenOnly =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  static String _modeLabel(AppLocalizations l10n, KeepAwakeMode mode) =>
      switch (mode) {
        KeepAwakeMode.off => l10n.keep_awake_mode_off,
        KeepAwakeMode.whileWorking => l10n.keep_awake_mode_while_working,
        KeepAwakeMode.always => l10n.keep_awake_mode_always,
      };

  static String _modeDescription(AppLocalizations l10n, KeepAwakeMode mode) =>
      _screenOnly
      ? switch (mode) {
          KeepAwakeMode.off => l10n.keep_awake_off_help_mobile,
          KeepAwakeMode.whileWorking =>
            l10n.keep_awake_while_working_help_mobile,
          KeepAwakeMode.always => l10n.keep_awake_always_help_mobile,
        }
      : switch (mode) {
          KeepAwakeMode.off => l10n.keep_awake_off_help,
          KeepAwakeMode.whileWorking => l10n.keep_awake_while_working_help,
          KeepAwakeMode.always => l10n.keep_awake_always_help,
        };

  @override
  Widget build(BuildContext context) {
    if (!_runnerSupported) return const SizedBox.shrink();
    final l10n = context.sharedL10n;
    final theme = Theme.of(context);
    final store = KeepAwakePolicyStore(widget.preferences);
    final card = Card(
      key: const Key('keep-awake-settings-card'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<int>(
          valueListenable: keepAwakePolicyChanges,
          builder: (context, _, _) {
            final selected = store.read();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt_outlined, color: theme.colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _screenOnly
                            ? l10n.keep_awake_title_mobile
                            : l10n.keep_awake_title,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _modeDescription(l10n, selected),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final mode in KeepAwakeMode.values)
                      ChoiceChip(
                        key: Key('keep-awake-mode-${mode.name}'),
                        label: Text(_modeLabel(l10n, mode)),
                        selected: selected == mode,
                        onSelected: (_) => store.write(mode),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
    final header = widget.header;
    if (header == null) return card;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [header, card],
    );
  }
}
