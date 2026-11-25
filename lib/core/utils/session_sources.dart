import '../models/session.dart';

const Set<String> kMachineSessionSources = {'cron', 'kanban', 'oneshot'};

/// Desktop's recents shape. The server may re-admit subagents when the
/// selected profile enables sessions.show_subagents; never exclude cron here
/// because the NextGen drawer also offers its independent Crons view.
const String kChatListingExcludedSources = 'oneshot,subagent,kanban,tool';

/// Compatibility for servers that ignore exclude_sources. Unknown preference
/// authority preserves returned subagents rather than overriding a user's
/// server-side Show subagents choice. Search does not use this policy.
bool isInternalListingSession(Session session, {bool? showSubagents}) =>
    const {'oneshot', 'kanban', 'tool'}.contains(session.source) ||
    (session.source == 'subagent' && showSubagents == false);

// Mirrors the scheduler's persisted IDs, including non-hex legacy job IDs.
final _cronSessionId = RegExp(r'^cron_[A-Za-z0-9][A-Za-z0-9._-]*_\d{8}_\d{6}$');

/// Persisted run identity from before the gateway switched cron to local-* IDs.
bool isLegacyCronSessionId(String id) => _cronSessionId.hasMatch(id);

bool isCronSession(Session session) =>
    session.source == 'cron' ||
    isLegacyCronSessionId(session.id) ||
    (session.lineageRootId != null &&
        isLegacyCronSessionId(session.lineageRootId!));

bool isMachineSession(Session session) =>
    kMachineSessionSources.contains(session.source) || isCronSession(session);
