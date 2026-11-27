import 'dart:convert';

/// References contain exact storage IDs, never URLs, tokens or transcripts.
/// Pages are keyed by contribution and chat so two sessions cannot share a PTY.
typedef PaneRef = ({String sessionId, String page});
PaneRef chatPane(String sessionId) => (sessionId: sessionId, page: '');

// Reserved local-only, unbound slots. Registry IDs cannot start with a colon.
const firstWorkspaceSlot = (sessionId: '', page: ':choose-first');
const secondWorkspaceSlot = (sessionId: '', page: ':choose-second');
bool isWorkspaceSlot(PaneRef ref) =>
    ref == firstWorkspaceSlot || ref == secondWorkspaceSlot;

class WorkspaceLayout {
  static const maxTabs = 16;
  static const maxLayouts = 12;
  final List<PaneRef> tabs = [];
  final List<PaneRef> closed = [];
  final Map<String, Map<String, Object?>> saved = {};
  PaneRef? primary;
  PaneRef? secondary;
  bool stacked = false;
  int percent = 50;

  factory WorkspaceLayout.unbound({
    required bool paired,
    required bool stacked,
    required int percent,
  }) {
    final layout = WorkspaceLayout()
      ..stacked = stacked
      ..percent = percent
      ..open(firstWorkspaceSlot);
    if (paired) layout.open(secondWorkspaceSlot, split: true);
    return layout;
  }

  void fillSlot(PaneRef slot, String selectedId) {
    final index = tabs.indexOf(slot), chat = chatPane(selectedId);
    if (!isWorkspaceSlot(slot) ||
        index < 0 ||
        selectedId.isEmpty ||
        tabs.contains(chat)) {
      return;
    }
    tabs[index] = chat;
    if (primary == slot) primary = chat;
    if (secondary == slot) secondary = chat;
    closed.remove(chat);
  }

  bool open(PaneRef pane, {bool split = false}) {
    if (!tabs.contains(pane)) {
      if (tabs.length >= maxTabs) return false;
      tabs.add(pane);
    }
    closed.remove(pane);
    if (split && primary != null && primary != pane) {
      secondary = pane;
    } else if (primary != pane) {
      if (secondary == pane) secondary = primary;
      primary = pane;
    }
    return true;
  }

  void hide(PaneRef pane) {
    if (secondary == pane) secondary = null;
    if (primary == pane) {
      primary = secondary;
      secondary = null;
    }
  }

  void close(PaneRef pane) {
    final index = tabs.indexOf(pane);
    if (index < 0) return;
    final replacePrimary = primary == pane;
    hide(pane);
    tabs.removeAt(index);
    if (replacePrimary && primary == null && tabs.isNotEmpty) {
      primary = tabs[index.clamp(0, tabs.length - 1)];
    }
    closed.remove(pane);
    closed.add(pane);
    if (closed.length > maxTabs) closed.removeAt(0);
  }

  bool reopen() => closed.isNotEmpty && open(closed.last);

  void cycle(int delta) {
    if (tabs.isEmpty) return;
    final i = primary == null ? -1 : tabs.indexOf(primary!);
    open(tabs[(i + delta) % tabs.length]);
  }

  void move(PaneRef pane, int delta) {
    final i = tabs.indexOf(pane);
    if (i < 0 || i + delta < 0 || i + delta >= tabs.length) return;
    tabs.removeAt(i);
    tabs.insert(i + delta, pane);
  }

  bool save(String name) {
    if (name.trim().isEmpty ||
        name.length > 64 ||
        (!saved.containsKey(name) && saved.length >= maxLayouts)) {
      return false;
    }
    saved[name] = _snapshot();
    return true;
  }

  void restore(String name) {
    final value = saved[name];
    if (value == null) return;
    // Tabs omitted by the loaded arrangement can still be reopened.
    final previous = [...tabs];
    _apply(value);
    for (final pane in previous.reversed.where((p) => !tabs.contains(p))) {
      closed.remove(pane);
      closed.add(pane);
    }
    closed.removeWhere(tabs.contains);
    if (closed.length > maxTabs) closed.removeRange(0, closed.length - maxTabs);
  }

  static List<String>? _ref(PaneRef? p) =>
      p == null ? null : [p.sessionId, p.page];
  static PaneRef? _read(Object? raw) => switch (raw) {
    [final String id, final String page]
        when (id.isNotEmpty || page.isNotEmpty) &&
            id.length <= 512 &&
            page.length <= 96 =>
      (sessionId: id, page: page),
    _ => null,
  };
  static List<PaneRef> _list(Object? raw) =>
      raw is List ? raw.take(maxTabs).map(_read).nonNulls.toSet().toList() : [];

  Map<String, Object?> _snapshot() => {
    'tabs': tabs.map(_ref).toList(),
    'primary': _ref(primary),
    'secondary': _ref(secondary),
    'stacked': stacked,
    'percent': percent,
  };
  void _apply(Map value) {
    tabs
      ..clear()
      ..addAll(_list(value['tabs']));
    primary = _read(value['primary']);
    secondary = _read(value['secondary']);
    if (!tabs.contains(primary)) primary = null;
    if (primary == null || secondary == primary || !tabs.contains(secondary)) {
      secondary = null;
    }
    stacked = value['stacked'] == true;
    percent = switch (value['percent']) {
      40 => 40,
      60 => 60,
      _ => 50,
    };
  }

  String encode() => jsonEncode({
    'version': 1,
    ..._snapshot(),
    'closed': closed.map(_ref).toList(),
    'saved': saved,
  });
  factory WorkspaceLayout.decode(String? raw) {
    final state = WorkspaceLayout();
    if (raw == null || raw.length > 1024 * 1024) return state;
    try {
      final value = jsonDecode(raw);
      if (value is! Map || value['version'] != 1) return state;
      state._apply(value);
      state.closed.addAll(
        _list(value['closed']).where((p) => !state.tabs.contains(p)),
      );
      final saved = value['saved'];
      if (saved is Map) {
        for (final e in saved.entries.take(maxLayouts)) {
          if (e.key is! String || e.value is! Map) continue;
          final clean = WorkspaceLayout().._apply(e.value as Map);
          final name = e.key as String;
          if (name.trim().isNotEmpty && name.length <= 64) {
            state.saved[name] = clean._snapshot();
          }
        }
      }
    } on FormatException {
      /* Start empty, without guessing session identity. */
    }
    return state;
  }
  WorkspaceLayout();
}
