/// Fork lineage for a session list.
///
/// A `/new` reset keeps `parentSessionId` and sets `resetFrom`. That is a new
/// conversation, not a nested fork. A real branch sets `branchedFrom`.
/// Compression siblings share `lineageRootId` and are one conversation.
class ForkMark {
  const ForkMark({
    required this.id,
    required this.title,
    this.parentSessionId,
    this.branchedFrom,
    this.resetFrom,
    this.lineageRootId,
    this.profile,
    this.lastActive = 0,
    this.startedAt = 0,
  });

  final String id;
  final String title;
  final String? parentSessionId;
  final String? branchedFrom;
  final String? resetFrom;
  final String? lineageRootId;
  final String? profile;
  final double lastActive;
  final double startedAt;
}

class ForkEntry {
  const ForkEntry(this.session, {this.depth = 0, this.parentId});

  final ForkMark session;
  final int depth;
  final String? parentId;
}

class ShownLineage {
  const ShownLineage({
    this.parent,
    this.siblings = const [],
    this.children = const [],
  });

  final ForkMark? parent;
  final List<ForkMark> siblings;
  final List<ForkMark> children;
}

String? _trimmed(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

/// Parent id to nest under, or null when this row is its own conversation.
String? forkParentId(ForkMark session) {
  if (_trimmed(session.resetFrom) != null) return null;
  return _trimmed(session.branchedFrom) ?? _trimmed(session.parentSessionId);
}

String lineageKey(ForkMark session) {
  final profile = _trimmed(session.profile) ?? 'default';
  final root = _trimmed(session.lineageRootId) ?? session.id;
  return '$profile::$root';
}

double _recency(ForkMark session) {
  if (session.lastActive != 0) return session.lastActive;
  return session.startedAt;
}

List<ForkMark> collapseCompressionLineages(List<ForkMark> sessions) {
  final groups = <String, List<ForkMark>>{};
  for (final session in sessions) {
    groups.putIfAbsent(lineageKey(session), () => []).add(session);
  }
  if (groups.length == sessions.length) return sessions;
  final winners = <ForkMark>{};
  for (final group in groups.values) {
    final continued = group.map((row) => _trimmed(row.parentSessionId)).toSet();
    double score(ForkMark session) => continued.contains(session.id)
        ? double.negativeInfinity
        : _recency(session);
    var best = group.first;
    for (final session in group.skip(1)) {
      if (score(session) > score(best)) best = session;
    }
    winners.add(best);
  }
  return [
    for (final session in sessions)
      if (winners.contains(session)) session,
  ];
}

/// Flat list with real forks nested under their parent. Compression rows and
/// `/new` resets stay at the top level.
List<ForkEntry> flattenForks(List<ForkMark> input) {
  final sessions = collapseCompressionLineages(input);
  if (sessions.length < 2) {
    return [for (final session in sessions) ForkEntry(session)];
  }
  final byVisibleId = <String, ForkMark>{};
  for (final session in sessions) {
    byVisibleId[session.id] = session;
    final root = _trimmed(session.lineageRootId);
    if (root != null) byVisibleId[root] = session;
  }
  final survivorByLineage = {
    for (final session in sessions) lineageKey(session): session,
  };
  for (final session in input) {
    final survivor = survivorByLineage[lineageKey(session)];
    if (survivor != null && !byVisibleId.containsKey(session.id)) {
      byVisibleId[session.id] = survivor;
    }
  }
  final childrenByParent = <String, List<ForkMark>>{};
  final parentOf = <String, String>{};
  for (final session in sessions) {
    final parentId = forkParentId(session);
    if (parentId == null) continue;
    final parent = byVisibleId[parentId];
    if (parent == null || lineageKey(parent) == lineageKey(session)) continue;
    parentOf[session.id] = parent.id;
    childrenByParent.putIfAbsent(parent.id, () => []).add(session);
  }
  for (final siblings in childrenByParent.values) {
    siblings.sort((a, b) => _recency(b).compareTo(_recency(a)));
  }
  final out = <ForkEntry>[];
  final seen = <String>{};
  void emit(ForkMark session, int depth) {
    if (!seen.add(session.id)) return;
    out.add(ForkEntry(session, depth: depth, parentId: parentOf[session.id]));
    for (final child in childrenByParent[session.id] ?? const <ForkMark>[]) {
      emit(child, depth + 1);
    }
  }

  final roots = [
    for (final session in sessions)
      if (!parentOf.containsKey(session.id)) session,
  ];
  roots.sort((a, b) {
    double group(ForkMark session) {
      var max = _recency(session);
      for (final child in childrenByParent[session.id] ?? const <ForkMark>[]) {
        final childScore = _recency(child);
        if (childScore > max) max = childScore;
      }
      return max;
    }

    return group(b).compareTo(group(a));
  });
  for (final root in roots) {
    emit(root, 0);
  }
  for (final session in sessions) {
    emit(session, 0);
  }
  return out;
}

ShownLineage lineageAround(String id, List<ForkMark> rows) {
  final flat = flattenForks(rows);
  ForkEntry? self;
  for (final entry in flat) {
    if (entry.session.id == id) self = entry;
  }
  if (self == null) {
    for (final row in rows) {
      if (row.id != id) continue;
      for (final entry in flat) {
        if (lineageKey(entry.session) == lineageKey(row)) self = entry;
      }
    }
  }
  if (self == null) return const ShownLineage();
  final parentId = self.parentId;
  ForkMark? parent;
  if (parentId != null) {
    for (final entry in flat) {
      if (entry.session.id == parentId) parent = entry.session;
    }
  }
  final siblings = [
    for (final entry in flat)
      if (entry.parentId != null &&
          entry.parentId == parentId &&
          entry.session.id != self.session.id)
        entry.session,
  ];
  final children = [
    for (final entry in flat)
      if (entry.parentId == self.session.id) entry.session,
  ];
  return ShownLineage(parent: parent, siblings: siblings, children: children);
}
