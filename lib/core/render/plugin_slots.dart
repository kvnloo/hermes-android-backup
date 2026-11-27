import 'package:flutter/foundation.dart';

import 'artifact_library.dart';
import 'rich_blocks.dart';
import 'rich_transcript.dart';

/// A contribution compiled into the client. Chat text and downloaded packages
/// cannot add one of these. The only slot Ares draws is a reply card for a
/// `::name{…}` directive; the Desktop's pane, page, composer, command and
/// tool-player slots have no Ares surface, so they are not modelled here.
class PluginDescriptor {
  const PluginDescriptor({
    required this.id,
    required this.title,
    required this.directive,
  });

  final String id;
  final String title;
  final String directive;
}

/// The reviewed contributions. Notes draws `::notes{text="…"}` directives
/// from a reply as a card once it is granted for that connection.
const reviewedPlugins = <PluginDescriptor>[
  PluginDescriptor(id: 'notes', title: 'Notes', directive: 'notes'),
];

PluginDescriptor? reviewedPlugin(String id) {
  for (final plugin in reviewedPlugins) {
    if (plugin.id == id) return plugin;
  }
  return null;
}

/// Grants per connection ([scope] is a render connection key). A grant on
/// one gateway or profile does nothing on another.
class PluginGrants extends ChangeNotifier {
  final _granted = <String, Set<String>>{};

  bool granted(String scope, String id) =>
      _granted[scope]?.contains(id) ?? false;

  /// Only a reviewed descriptor can receive a grant. Revocation is immediate.
  bool grant(String scope, String id) {
    if (reviewedPlugin(id) == null) return false;
    if ((_granted[scope] ??= <String>{}).add(id)) notifyListeners();
    return true;
  }

  void revoke(String scope, String id) {
    if (_granted[scope]?.remove(id) ?? false) notifyListeners();
  }

  bool showsDirective(String scope, String name) {
    for (final plugin in reviewedPlugins) {
      if (plugin.directive == name && granted(scope, plugin.id)) {
        return true;
      }
    }
    return false;
  }

  void reset() {
    _granted.clear();
    notifyListeners();
  }
}

final pluginGrants = PluginGrants();

/// Clears every renderer store and parse cache. Tests call it between cases.
void resetSandboxedRenderer() {
  pluginGrants.reset();
  resetArtifactCaches();
  resetRichBlockCaches();
  resetInspectedImagePaths();
  resetSandboxedPages();
}
