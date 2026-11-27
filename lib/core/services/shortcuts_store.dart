/// Remappable keyboard shortcuts, device-local.
///
/// The registry holds the actions the shell can bind and the defaults the
/// shell used before this layer existed. Bindings are stored as stable
/// serialized chords so a future store can share one preferences file.
/// Duplicate chords are never repaired — they are reported so the UI can show
/// the conflict; the binding keeps the default for that action.
library;

import 'dart:convert';

import 'package:flutter/foundation.dart'
    show TargetPlatform, ValueNotifier, defaultTargetPlatform;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Broadcasts whenever [ShortcutsStore] persists or resets a key chord.
final ValueNotifier<int> shortcutsStoreChanges = ValueNotifier<int>(0);

/// Whether [platform] also answers each uncustomized Cmd (meta) default with
/// its Ctrl twin (Ctrl+K for Cmd+K). Windows and Linux keyboards use Ctrl as
/// the shortcut modifier (meta is the Windows/Super key); Android and Fuchsia
/// hardware keyboards follow the same convention. macOS and iOS never get the
/// twins: there Ctrl+letter is a text-editing command (Ctrl+K deletes to the
/// end of the line, Ctrl+A moves to the line start) that the app must not
/// steal from a focused text field.
bool shortcutsAddCtrlTwins(TargetPlatform platform) =>
    platform != TargetPlatform.macOS && platform != TargetPlatform.iOS;

/// A stable identifier for a bindable action.
enum ShortcutAction {
  commandPalette,
  newChat,
  search,
  settings,
  tab1,
  tab2,
  tab3,
  tab4,
}

extension ShortcutActionIds on ShortcutAction {
  /// Stable string id persisted in preferences.
  String get id => name;
}

/// A single chord, optionally with modifier flags. Serializes stably.
class KeyChord {
  const KeyChord({
    required this.key,
    this.meta = false,
    this.ctrl = false,
    this.shift = false,
    this.alt = false,
  });

  final LogicalKeyboardKey key;
  final bool meta;
  final bool ctrl;
  final bool shift;
  final bool alt;

  /// Canonical name for the chord, derived from the explicit registry.
  String get keyName => _normalizedKeyName(key) ?? 'key:${key.keyId}';

  /// e.g. `meta+alt+shift+keyK`
  String serialize() {
    final parts = <String>[];
    if (meta) parts.add('meta');
    if (ctrl) parts.add('ctrl');
    if (shift) parts.add('shift');
    if (alt) parts.add('alt');
    parts.add(keyName);
    return parts.join('+');
  }

  /// Parses a serialized chord. Returns null for an unparseable or empty
  /// value. The modifier order is normalized (meta, ctrl, shift, alt).
  static KeyChord? parse(String? raw) {
    if (raw == null) return null;
    final parts = raw.split('+').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return null;
    final modifiers = <String>{};
    String? keyName;
    for (final part in parts) {
      switch (part) {
        case 'meta':
        case 'control':
        case 'ctrl':
        case 'shift':
        case 'alt':
          modifiers.add(part == 'control' ? 'ctrl' : part);
          break;
        default:
          if (keyName != null) return null;
          keyName = part;
      }
    }
    if (keyName == null) return null;
    final key = _keyByName(keyName);
    if (key == null) return null;
    return KeyChord(
      key: key,
      meta: modifiers.contains('meta'),
      ctrl: modifiers.contains('ctrl'),
      shift: modifiers.contains('shift'),
      alt: modifiers.contains('alt'),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is KeyChord &&
      other.key == key &&
      other.meta == meta &&
      other.ctrl == ctrl &&
      other.shift == shift &&
      other.alt == alt;

  @override
  int get hashCode => Object.hash(key, meta, ctrl, shift, alt);
}

/// Explicit name → key table. Anything not listed here cannot be serialized
/// to a stable name, so it is rejected by [parse] and by [serialize].
const _supportedKeys = <String, LogicalKeyboardKey>{
  'keyA': LogicalKeyboardKey.keyA,
  'keyB': LogicalKeyboardKey.keyB,
  'keyC': LogicalKeyboardKey.keyC,
  'keyD': LogicalKeyboardKey.keyD,
  'keyE': LogicalKeyboardKey.keyE,
  'keyF': LogicalKeyboardKey.keyF,
  'keyG': LogicalKeyboardKey.keyG,
  'keyH': LogicalKeyboardKey.keyH,
  'keyI': LogicalKeyboardKey.keyI,
  'keyJ': LogicalKeyboardKey.keyJ,
  'keyK': LogicalKeyboardKey.keyK,
  'keyL': LogicalKeyboardKey.keyL,
  'keyM': LogicalKeyboardKey.keyM,
  'keyN': LogicalKeyboardKey.keyN,
  'keyO': LogicalKeyboardKey.keyO,
  'keyP': LogicalKeyboardKey.keyP,
  'keyQ': LogicalKeyboardKey.keyQ,
  'keyR': LogicalKeyboardKey.keyR,
  'keyS': LogicalKeyboardKey.keyS,
  'keyT': LogicalKeyboardKey.keyT,
  'keyU': LogicalKeyboardKey.keyU,
  'keyV': LogicalKeyboardKey.keyV,
  'keyW': LogicalKeyboardKey.keyW,
  'keyX': LogicalKeyboardKey.keyX,
  'keyY': LogicalKeyboardKey.keyY,
  'keyZ': LogicalKeyboardKey.keyZ,
  'digit0': LogicalKeyboardKey.digit0,
  'digit1': LogicalKeyboardKey.digit1,
  'digit2': LogicalKeyboardKey.digit2,
  'digit3': LogicalKeyboardKey.digit3,
  'digit4': LogicalKeyboardKey.digit4,
  'digit5': LogicalKeyboardKey.digit5,
  'digit6': LogicalKeyboardKey.digit6,
  'digit7': LogicalKeyboardKey.digit7,
  'digit8': LogicalKeyboardKey.digit8,
  'digit9': LogicalKeyboardKey.digit9,
  'comma': LogicalKeyboardKey.comma,
  'period': LogicalKeyboardKey.period,
  'slash': LogicalKeyboardKey.slash,
  'semicolon': LogicalKeyboardKey.semicolon,
  'quoteSingle': LogicalKeyboardKey.quoteSingle,
  'backslash': LogicalKeyboardKey.backslash,
  'minus': LogicalKeyboardKey.minus,
  'equal': LogicalKeyboardKey.equal,
  'bracketLeft': LogicalKeyboardKey.bracketLeft,
  'bracketRight': LogicalKeyboardKey.bracketRight,
  'backquote': LogicalKeyboardKey.backquote,
  'enter': LogicalKeyboardKey.enter,
  'space': LogicalKeyboardKey.space,
  'escape': LogicalKeyboardKey.escape,
  'tab': LogicalKeyboardKey.tab,
  'arrowLeft': LogicalKeyboardKey.arrowLeft,
  'arrowRight': LogicalKeyboardKey.arrowRight,
  'arrowUp': LogicalKeyboardKey.arrowUp,
  'arrowDown': LogicalKeyboardKey.arrowDown,
  'home': LogicalKeyboardKey.home,
  'end': LogicalKeyboardKey.end,
  'pageUp': LogicalKeyboardKey.pageUp,
  'pageDown': LogicalKeyboardKey.pageDown,
  'insert': LogicalKeyboardKey.insert,
  'delete': LogicalKeyboardKey.delete,
};

/// Reverse of the forward table — canonical name for a key.
/// Keys not in the table serialize as `key:<keyId>` and cannot re-parse.
String? _normalizedKeyName(LogicalKeyboardKey key) {
  for (final entry in _supportedKeys.entries) {
    if (entry.value.keyId == key.keyId) return entry.key;
  }
  return null;
}

/// Human-readable key names → LogicalKeyboardKey. Kept small and explicit.
LogicalKeyboardKey? _keyByName(String name) {
  return _supportedKeys[name];
}

/// Read-only view of supported keys for UI chord pickers on touch/narrow devices.
Map<String, LogicalKeyboardKey> get supportedShortcutKeys =>
    Map<String, LogicalKeyboardKey>.unmodifiable(_supportedKeys);

/// Formats a [KeyChord] for human-readable badges (e.g. `⌘ K` or `Ctrl + K`).
String formatKeyChord(KeyChord chord, {bool appleSymbols = false}) {
  final parts = <String>[];
  if (chord.meta) parts.add(appleSymbols ? '⌘' : 'Cmd/Ctrl');
  if (chord.ctrl) parts.add(appleSymbols ? '⌃' : 'Ctrl');
  if (chord.alt) parts.add(appleSymbols ? '⌥' : 'Alt');
  if (chord.shift) parts.add(appleSymbols ? '⇧' : 'Shift');
  parts.add(formatShortcutKeyName(chord.keyName));
  return appleSymbols ? parts.join(' ') : parts.join(' + ');
}

/// Human-friendly label for a canonical key name from [supportedShortcutKeys].
String formatShortcutKeyName(String keyName) {
  if (keyName.startsWith('key') && keyName.length == 4) {
    return keyName.substring(3).toUpperCase();
  }
  if (keyName.startsWith('digit') && keyName.length == 6) {
    return keyName.substring(5);
  }
  return switch (keyName) {
    'comma' => ',',
    'period' => '.',
    'slash' => '/',
    'semicolon' => ';',
    'quoteSingle' => "'",
    'backslash' => r'\',
    'minus' => '-',
    'equal' => '=',
    'bracketLeft' => '[',
    'bracketRight' => ']',
    'backquote' => '`',
    'enter' => 'Enter',
    'space' => 'Space',
    'escape' => 'Esc',
    'tab' => 'Tab',
    'arrowLeft' => '←',
    'arrowRight' => '→',
    'arrowUp' => '↑',
    'arrowDown' => '↓',
    'pageUp' => 'PgUp',
    'pageDown' => 'PgDn',
    'home' => 'Home',
    'end' => 'End',
    'insert' => 'Ins',
    'delete' => 'Del',
    _ => keyName,
  };
}

/// Registry: the stable actions, their defaults, and their labels.
class ShortcutRegistry {
  const ShortcutRegistry._();

  /// Default bindings — mirror the pre-registry shell bindings, which used
  /// the platform-appropriate modifier. The platform layer decides whether
  /// the default is meta (macOS/iOS) or ctrl (Windows/Linux).
  static const defaults = <ShortcutAction, String>{
    ShortcutAction.commandPalette: 'meta+keyK',
    ShortcutAction.newChat: 'meta+keyN',
    ShortcutAction.search: 'meta+keyF',
    ShortcutAction.settings: 'meta+comma',
    ShortcutAction.tab1: 'meta+digit1',
    ShortcutAction.tab2: 'meta+digit2',
    ShortcutAction.tab3: 'meta+digit3',
    ShortcutAction.tab4: 'meta+digit4',
  };

  static const labels = <ShortcutAction, String>{
    ShortcutAction.commandPalette: 'Command palette',
    ShortcutAction.newChat: 'New chat',
    ShortcutAction.search: 'Search',
    ShortcutAction.settings: 'Settings',
    ShortcutAction.tab1: 'Go to tab 1',
    ShortcutAction.tab2: 'Go to tab 2',
    ShortcutAction.tab3: 'Go to tab 3',
    ShortcutAction.tab4: 'Go to tab 4',
  };

  /// The actions in display order.
  static const actions = [
    ShortcutAction.commandPalette,
    ShortcutAction.newChat,
    ShortcutAction.search,
    ShortcutAction.settings,
    ShortcutAction.tab1,
    ShortcutAction.tab2,
    ShortcutAction.tab3,
    ShortcutAction.tab4,
  ];

  static String label(ShortcutAction action) => labels[action] ?? action.name;

  static KeyChord defaultChord(ShortcutAction action) {
    final raw = defaults[action];
    final parsed = raw == null ? null : KeyChord.parse(raw);
    if (parsed == null) {
      throw ArgumentError('Unknown default chord for $action');
    }
    return parsed;
  }
}

/// Device-local shortcut store. The read is non-destructive: an unknown or
/// unparseable persisted value falls back to the default for that action.
class ShortcutsStore {
  ShortcutsStore(this._prefs);

  static const preferenceKey = 'shortcut_bindings_v1';

  final SharedPreferences _prefs;

  Map<String, String> readMap() {
    final raw = _prefs.getString(preferenceKey);
    if (raw == null || raw.isEmpty) return <String, String>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return <String, String>{};
      final out = <String, String>{};
      for (final entry in decoded.entries) {
        final key = entry.key;
        final value = entry.value;
        if (key is! String || value is! String) continue;
        if (KeyChord.parse(value) == null) continue;
        out[key] = value;
      }
      return Map<String, String>.unmodifiable(out);
    } catch (_) {
      return <String, String>{};
    }
  }

  KeyChord chordFor(ShortcutAction action) {
    final raw = readMap()[action.id];
    if (raw != null) {
      final parsed = KeyChord.parse(raw);
      if (parsed != null) return parsed;
    }
    return ShortcutRegistry.defaultChord(action);
  }

  /// All bindings for the current action set, in display order.
  Map<ShortcutAction, KeyChord> allBindings() {
    return {
      for (final action in ShortcutRegistry.actions) action: chordFor(action),
    };
  }

  Future<void> setChord(ShortcutAction action, KeyChord chord) async {
    final map = Map<String, String>.from(readMap());
    map[action.id] = chord.serialize();
    await _prefs.setString(preferenceKey, jsonEncode(map));
    shortcutsStoreChanges.value++;
  }

  Future<void> resetToDefaults() async {
    await _prefs.remove(preferenceKey);
    shortcutsStoreChanges.value++;
  }

  Future<void> resetAction(ShortcutAction action) async {
    final map = Map<String, String>.from(readMap());
    map.remove(action.id);
    if (map.isEmpty) {
      await _prefs.remove(preferenceKey);
    } else {
      await _prefs.setString(preferenceKey, jsonEncode(map));
    }
    shortcutsStoreChanges.value++;
  }

  /// What fires on [platform] (default: the current one) and which custom
  /// bindings collide with something that would fire. See [ShortcutPlan].
  ShortcutPlan plan({TargetPlatform? platform}) =>
      ShortcutPlan.resolve(readMap(), platform ?? defaultTargetPlatform);

  /// Chords claimed by two actions among the bindings that actually fire on
  /// [platform] (default: the current one), including the automatic Ctrl
  /// twins on Windows and Linux. Empty when every binding is distinct. Each
  /// entry is `[actionA, actionB, sharedChord]` (serialized chord).
  List<List<dynamic>> conflicts({TargetPlatform? platform}) => [
    for (final conflict in plan(platform: platform).conflicts)
      [conflict.first, conflict.second, conflict.chord.serialize()],
  ];
}

/// How a chord reaches its action.
enum ShortcutBindingKind {
  /// The action's own chord (default or custom), shown in Settings.
  primary,

  /// The automatic Ctrl twin of an uncustomized Cmd default (Windows, Linux).
  /// Settings shows it as part of the default (`Cmd/Ctrl + K`).
  ctrlTwin,

  /// A hidden convenience (Shift+Cmd/Ctrl+F for search). It never conflicts:
  /// it simply stops firing when any other binding claims the chord.
  alias,
}

/// One chord that fires one action.
class ShortcutBinding {
  const ShortcutBinding(
    this.action,
    this.chord, {
    this.kind = ShortcutBindingKind.primary,
  });

  final ShortcutAction action;
  final KeyChord chord;
  final ShortcutBindingKind kind;
}

/// Two actions claiming the same chord.
class ShortcutConflict {
  const ShortcutConflict(this.first, this.second, this.chord);

  final ShortcutAction first;
  final ShortcutAction second;
  final KeyChord chord;
}

/// The single answer to "what does this chord do here", shared by the key
/// handler ([bindings]) and Settings ([conflicts]) so they cannot disagree.
///
/// Every visible binding takes part: each action's chord and, where the
/// platform adds them, the Ctrl twins of uncustomized Cmd defaults. A custom
/// chord that collides with any of them is reported and reverted to the
/// action's default (with its twin), repeatedly until nothing collides, so a
/// conflict never silently takes another action's shortcut away.
class ShortcutPlan {
  const ShortcutPlan._({
    required this.bindings,
    required this.conflicts,
    required this.reverted,
  });

  /// Every chord that fires, each at most once, in priority order.
  final List<ShortcutBinding> bindings;

  /// Collisions found among the configured bindings.
  final List<ShortcutConflict> conflicts;

  /// Actions whose custom chord was reverted to the default.
  final Set<ShortcutAction> reverted;

  /// The chord → action table the key handler installs.
  Map<KeyChord, ShortcutAction> get firing => {
    for (final binding in bindings) binding.chord: binding.action,
  };

  static ShortcutPlan resolve(
    Map<String, String> customMap,
    TargetPlatform platform,
  ) {
    final twins = shortcutsAddCtrlTwins(platform);
    final custom = <ShortcutAction, KeyChord>{};
    for (final action in ShortcutRegistry.actions) {
      final parsed = KeyChord.parse(customMap[action.id]);
      // Re-saving the default is not a customization: keep its Ctrl twin.
      if (parsed != null && parsed != ShortcutRegistry.defaultChord(action)) {
        custom[action] = parsed;
      }
    }
    final reverted = <ShortcutAction>{};
    final conflicts = <ShortcutConflict>[];
    final seen = <String>{};

    List<ShortcutBinding> visible() {
      final primary = <ShortcutBinding>[];
      final twinBindings = <ShortcutBinding>[];
      for (final action in ShortcutRegistry.actions) {
        final customized =
            custom.containsKey(action) && !reverted.contains(action);
        final chord = customized
            ? custom[action]!
            : ShortcutRegistry.defaultChord(action);
        primary.add(ShortcutBinding(action, chord));
        if (!customized && twins && chord.meta && !chord.ctrl) {
          twinBindings.add(
            ShortcutBinding(
              action,
              KeyChord(
                key: chord.key,
                ctrl: true,
                shift: chord.shift,
                alt: chord.alt,
              ),
              kind: ShortcutBindingKind.ctrlTwin,
            ),
          );
        }
      }
      return [...primary, ...twinBindings];
    }

    var candidates = visible();
    for (var round = 0; round <= ShortcutRegistry.actions.length; round++) {
      final byChord = <String, List<ShortcutBinding>>{};
      for (final binding in candidates) {
        byChord.putIfAbsent(binding.chord.serialize(), () => []).add(binding);
      }
      var changed = false;
      for (final entry in byChord.entries) {
        final actions = <ShortcutAction>{
          for (final binding in entry.value) binding.action,
        }.toList();
        if (actions.length < 2) continue;
        for (var i = 1; i < actions.length; i++) {
          final key = '${actions[0].id}|${actions[i].id}|${entry.key}';
          if (seen.add(key)) {
            conflicts.add(
              ShortcutConflict(actions[0], actions[i], entry.value.first.chord),
            );
          }
        }
        for (final action in actions) {
          if (custom.containsKey(action) && reverted.add(action)) {
            changed = true;
          }
        }
      }
      if (!changed) break;
      candidates = visible();
    }

    final used = <String>{};
    final bindings = <ShortcutBinding>[
      for (final binding in candidates)
        if (used.add(binding.chord.serialize())) binding,
    ];
    final searchCustomized =
        custom.containsKey(ShortcutAction.search) &&
        !reverted.contains(ShortcutAction.search);
    if (!searchCustomized) {
      for (final alias in [
        const KeyChord(key: LogicalKeyboardKey.keyF, meta: true, shift: true),
        if (twins)
          const KeyChord(key: LogicalKeyboardKey.keyF, ctrl: true, shift: true),
      ]) {
        if (used.add(alias.serialize())) {
          bindings.add(
            ShortcutBinding(
              ShortcutAction.search,
              alias,
              kind: ShortcutBindingKind.alias,
            ),
          );
        }
      }
    }
    return ShortcutPlan._(
      bindings: List.unmodifiable(bindings),
      conflicts: List.unmodifiable(conflicts),
      reverted: Set.unmodifiable(reverted),
    );
  }
}

/// True for Cmd/Ctrl + C, V, X, Z, A or Y (with or without Shift): the
/// clipboard, undo/redo and select-all commands of every text field. Binding
/// an app shortcut there takes the command away from the composer, so
/// Settings warns about it.
bool isTextEditingChord(KeyChord chord) {
  if (!(chord.meta || chord.ctrl) || chord.alt) return false;
  return const {
    'keyC',
    'keyV',
    'keyX',
    'keyZ',
    'keyA',
    'keyY',
  }.contains(chord.keyName);
}
