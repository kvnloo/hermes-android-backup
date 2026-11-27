import '../models/session.dart';
import '../models/session_search_hit.dart';

/// A full-text hit adds a reason to show a row; it never replaces a richer
/// list row's title, routing ID, source, archive state or pin authority.
List<SessionSearchHit> projectSessionSearch(
  Iterable<Session> local,
  Iterable<SessionSearchHit> hits,
  String query,
) {
  final term = query.trim().toLowerCase();
  final byId = <String, Session>{};
  final matched = <String, SessionSearchHit>{};
  for (final row in local) {
    byId[row.id] = row;
    if (row.lineageRootId case final root?) byId[root] = row;
    if ([
      row.title,
      row.id,
      row.preview,
      row.model,
    ].any((s) => s.toLowerCase().contains(term))) {
      matched[row.id] = SessionSearchHit(session: row);
    }
  }
  for (final hit in hits) {
    final row =
        byId[hit.session.id] ?? byId[hit.session.lineageRootId] ?? hit.session;
    matched[row.id] = SessionSearchHit(
      session: row,
      snippet: hit.snippet,
      role: hit.role,
    );
  }
  return matched.values.toList();
}
