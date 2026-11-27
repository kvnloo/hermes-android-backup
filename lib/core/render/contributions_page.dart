import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'plugin_slots.dart';

/// Reviewed client contributions for one connection. Granting a slot does
/// not download code or run a page script. An id that is not in
/// [reviewedPlugins] cannot be granted.
class ContributionsPage extends StatelessWidget {
  const ContributionsPage({super.key, required this.scope});

  /// The render connection key the grants apply to.
  final String scope;

  @override
  Widget build(BuildContext context) {
    final l = context.sharedL10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.render_contributions)),
      body: ListenableBuilder(
        listenable: pluginGrants,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l.render_contributions_intro),
              const SizedBox(height: 12),
              for (final plugin in reviewedPlugins) ...[
                Text(
                  plugin.localizedTitle(l),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  plugin.grantedSlotsLabel(l),
                  key: Key('plugin-slots-${plugin.id}'),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    if (!pluginGrants.granted(scope, plugin.id))
                      FilledButton(
                        onPressed: () => pluginGrants.grant(scope, plugin.id),
                        child: Text(
                          l.render_grant_plugin(plugin.localizedTitle(l)),
                        ),
                      )
                    else
                      OutlinedButton(
                        onPressed: () => pluginGrants.revoke(scope, plugin.id),
                        child: Text(
                          l.render_revoke_plugin(plugin.localizedTitle(l)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        },
      ),
    );
  }
}

extension PluginDescriptorLabels on PluginDescriptor {
  String grantedSlotsLabel(AppLocalizations l) =>
      l.render_plugin_slots(directive);

  /// The reviewed contribution's name in the app language; [title] for one
  /// this build has no words for.
  String localizedTitle(AppLocalizations l) => switch (id) {
    'notes' => l.render_plugin_notes,
    _ => title,
  };
}
