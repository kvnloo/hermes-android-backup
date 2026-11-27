import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import 'remote_workspace.dart';

// Roster sections after Hermes Desktop b7ee21c14e
// (apps/desktop/src/plugins/hermes-bots/user-sections.ts):
//
// * Membership lives on the BOT: `sectionId` and `sectionName` in its
//   `ui_meta['hermes-bots']` record, written through profiles.configure like
//   every other look field, so it follows the profile to other machines.
// * The section RECORDS (id, name, order) are this device's own list, kept
//   locally (Desktop: plugin storage `bot-sections-v1`; here per connection
//   and gateway profile). Sections another device made are rebuilt from the
//   ids and names their members carry.
// * "Unassigned" is not a section: it is whatever is left, drawn last.
// * Collapsing a section lasts for the visit only (Desktop keeps it in
//   component state), and nothing is collapsed while the roster is searched.

class BotSection {
  const BotSection(this.id, this.name);
  final String id;
  final String name;

  Map<String, String> toJson() => {'id': id, 'name': name};

  @override
  bool operator ==(Object other) =>
      other is BotSection && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}

/// One block of the roster: a section's bots, or Unassigned ([id] null).
class BotSectionBlock {
  const BotSectionBlock(this.id, this.name, this.rows);
  final String? id;
  final String name;
  final List<BotRosterProfile> rows;
  String get key => id == null ? 'section:unassigned' : 'user-section:$id';
}

/// Desktop's `normalizeBotSections`: id and name trimmed, both required,
/// first of a repeated id wins.
List<BotSection> normalizeBotSections(Object? value) {
  if (value is! List) return const [];
  final seen = <String>{};
  return [
    for (final entry in value)
      if (entry is Map)
        if ((entry['id']?.toString() ?? '').trim() case final id
            when id.isNotEmpty && seen.add(id))
          if ((entry['name']?.toString() ?? '').trim() case final name
              when name.isNotEmpty)
            BotSection(id, name),
  ];
}

/// Desktop's `newSectionId`: `sec-<time base36>-<5 random base36>`.
String newBotSectionId([Random? random]) {
  final r = random ?? Random.secure();
  const digits = '0123456789abcdefghijklmnopqrstuvwxyz';
  final tail = List.generate(5, (_) => digits[r.nextInt(36)]).join();
  return 'sec-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-$tail';
}

/// Desktop's `sortRosterBots`: pinned bots first, then the newest activity
/// (creation or last message). Stable for ties.
List<BotRosterProfile> sortBotRoster(List<BotRosterProfile> roster) {
  final indexed = roster.indexed.toList()
    ..sort((a, b) {
      final pinned = (b.$2.pinned ? 1 : 0) - (a.$2.pinned ? 1 : 0);
      if (pinned != 0) return pinned;
      final activity = b.$2.activity.compareTo(a.$2.activity);
      return activity != 0 ? activity : a.$1.compareTo(b.$1);
    });
  return [for (final (_, bot) in indexed) bot];
}

/// Desktop's `groupRowsBySection`: every row exactly once, sections in their
/// order, Unassigned last; a row filed under a section that no longer
/// exists is Unassigned.
List<BotSectionBlock> groupBotsBySection(
  List<BotRosterProfile> rows,
  List<BotSection> sections,
) {
  final byId = {for (final s in sections) s.id: <BotRosterProfile>[]};
  final loose = <BotRosterProfile>[];
  for (final row in rows) {
    final id = row.sectionId;
    (id != null && byId.containsKey(id) ? byId[id]! : loose).add(row);
  }
  return [
    for (final s in sections) BotSectionBlock(s.id, s.name, byId[s.id]!),
    BotSectionBlock(null, '', loose),
  ];
}

/// Desktop's `adoptBotSectionsFromMeta`: sections another device made are
/// rebuilt from the ids and names their members carry (appended, in roster
/// order); a known section takes its members' name once they all agree.
/// [pendingDeletes] are sections whose delete is still clearing members.
List<BotSection> adoptBotSections(
  List<BotSection> local,
  List<BotRosterProfile> roster,
  Set<String> pendingDeletes,
) {
  final names = <String, Set<String>>{};
  for (final bot in roster) {
    final id = bot.sectionId;
    final name = bot.sectionName;
    if (id != null && name != null) {
      names.putIfAbsent(id, () => <String>{}).add(name);
    }
  }
  String? agreed(String id) =>
      names[id]?.length == 1 ? names[id]!.single : null;
  final known = {for (final s in local) s.id};
  return [
    for (final s in local) BotSection(s.id, agreed(s.id) ?? s.name),
    for (final MapEntry(:key, :value) in names.entries)
      if (!known.contains(key) && !pendingDeletes.contains(key))
        BotSection(key, value.first),
  ];
}

/// This device's section list for one connection and gateway profile. Only
/// ids and names are stored.
class BotSectionStore {
  const BotSectionStore._();

  static String key(String connectionId, String? profile) =>
      'bot-sections-v1:$connectionId:${profile ?? ''}';

  static Future<List<BotSection>> load(String scope) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(scope);
      return raw == null ? const [] : normalizeBotSections(jsonDecode(raw));
    } catch (_) {
      return const [];
    }
  }

  static Future<void> save(String scope, List<BotSection> sections) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        scope,
        jsonEncode([for (final s in sections) s.toJson()]),
      );
    } catch (_) {
      // No storage: the sections last for this visit, as on Desktop.
    }
  }
}
