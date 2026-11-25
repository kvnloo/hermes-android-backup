// What the NextGen composer's `/` suggestions box lists: the gateway's
// ranked `complete.slash` matches when it has them (Hermes Desktop's and
// Kyllene's source, with project-local skills and argument choices), else
// the scoped `commands.catalog`, filtered here. NextGen's own `/new`,
// `/reset`, `/stop` and `/model` are always offered when they match. Only
// commands a send would run are listed (`NgSlashCatalog.resolve`), so the
// box, the highlight and the send path agree.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../core/models/slash_command.dart';
import '../../core/services/ws_client.dart';
import 'nextgen_gateway.dart';
import 'slash_catalog.dart';
import 'slash_exec.dart';

/// How long typing pauses before `complete.slash` is asked.
const Duration kNgSlashSuggestDebounce = Duration(milliseconds: 120);

/// A completion request never holds the box up for longer than this.
const Duration kNgSlashSuggestTimeout = Duration(seconds: 8);

enum NgSlashSuggestionKind { command, skill, option }

/// One row of the box.
@immutable
class NgSlashSuggestion {
  const NgSlashSuggestion({
    required this.label,
    required this.insert,
    this.description = '',
    this.kind = NgSlashSuggestionKind.command,
  });

  /// What the row shows: `/title`, `/bg`, or an argument such as `alice`.
  final String label;

  /// What replaces the query's [NgSlashQuery.replaceFrom].. range: `/title`
  /// for a command, `alice` for an argument. Never ends in whitespace.
  final String insert;

  final String description;
  final NgSlashSuggestionKind kind;

  bool get isSkill => kind == NgSlashSuggestionKind.skill;

  @override
  bool operator ==(Object other) =>
      other is NgSlashSuggestion &&
      other.label == label &&
      other.insert == insert &&
      other.description == description &&
      other.kind == kind;

  @override
  int get hashCode => Object.hash(label, insert, description, kind);
}

/// The part of a draft the box completes.
///
/// Command stage: the caret is inside the draft's leading `/token` (`/`,
/// `/ti`), with no newline before it. Argument stage: a single-line
/// `/command args` with the caret at the end, which only the gateway can
/// complete.
@immutable
class NgSlashQuery {
  const NgSlashQuery._({
    required this.start,
    required this.caret,
    required this.tokenEnd,
    required this.text,
    required this.isArgument,
  });

  /// Offset of the `/` in the draft.
  final int start;

  /// Collapsed caret offset.
  final int caret;

  /// Exclusive end of the leading token.
  final int tokenEnd;

  /// What `complete.slash` is asked about: the draft from the `/` to the
  /// caret.
  final String text;

  final bool isArgument;

  /// The typed name without the slash (command stage): `ti`, or `` for `/`.
  String get name =>
      isArgument ? text.substring(1, tokenEnd - start) : text.substring(1);

  static final RegExp _space = RegExp(r'\s');

  static NgSlashQuery? of(TextEditingValue value) {
    final text = value.text;
    final selection = value.selection;
    if (!selection.isValid || !selection.isCollapsed) return null;
    final caret = selection.baseOffset;
    if (caret < 0 || caret > text.length) return null;
    var start = 0;
    while (start < text.length && _space.hasMatch(text[start])) {
      start++;
    }
    if (start >= text.length || text.codeUnitAt(start) != 0x2F) return null;
    // The leading token must start on the first line.
    if (text.substring(0, start).contains('\n')) return null;
    final gap = _space.allMatches(text, start + 1).firstOrNull;
    final tokenEnd = gap?.start ?? text.length;
    if (caret > start && caret <= tokenEnd) {
      final typed = text.substring(start, caret);
      // `/usr/bin` and `//x` are paths, never commands.
      if (typed.indexOf('/', 1) != -1) return null;
      return NgSlashQuery._(
        start: start,
        caret: caret,
        tokenEnd: tokenEnd,
        text: typed,
        isArgument: false,
      );
    }
    final name = text.substring(start + 1, tokenEnd);
    if (caret == text.length &&
        caret > tokenEnd &&
        name.isNotEmpty &&
        !name.contains('/') &&
        !text.contains('\n', start)) {
      return NgSlashQuery._(
        start: start,
        caret: caret,
        tokenEnd: tokenEnd,
        text: text.substring(start),
        isArgument: true,
      );
    }
    return null;
  }

  /// Puts [suggestion] in the draft: a command replaces the whole leading
  /// token, an argument replaces the draft from [replaceFrom] (an offset
  /// into [text]) to the caret. A single space follows, and the caret goes
  /// after it, ready for what comes next. Nothing is sent.
  TextEditingValue apply(
    String draft,
    NgSlashSuggestion suggestion, {
    int replaceFrom = 1,
  }) {
    final int from;
    final int to;
    if (isArgument || suggestion.kind == NgSlashSuggestionKind.option) {
      from = start + replaceFrom.clamp(0, text.length);
      to = caret;
    } else {
      from = start;
      to = tokenEnd;
    }
    final insert = suggestion.insert.trimRight();
    final rest = draft.substring(to);
    final spaced = rest.isNotEmpty && _space.hasMatch(rest[0]);
    final head = '${draft.substring(0, from)}$insert';
    final next = spaced ? '$head$rest' : '$head $rest';
    return TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: head.length + 1),
    );
  }

  bool sameAs(NgSlashQuery? other) =>
      other != null &&
      other.start == start &&
      other.caret == caret &&
      other.tokenEnd == tokenEnd &&
      other.text == text &&
      other.isArgument == isArgument;
}

/// A parsed `complete.slash` answer for one [text].
@immutable
class NgSlashCompletion {
  const NgSlashCompletion(this.text, this.items, this.replaceFrom);

  final String text;
  final List<NgSlashSuggestion> items;

  /// Offset into [text] where an argument item's text goes; 1 (after the
  /// slash) for command items.
  final int replaceFrom;

  bool get isArgument => replaceFrom > 1;

  /// Reads `{items: [{text, display, meta, kind}], replace_from}`
  /// (tui_gateway/command_discovery.py `slash_completions`), as Kyllene's
  /// `parseCompletions` does. A command item's `text` is the bare name
  /// (sometimes with a trailing space, or a slash for the TUI extras); an
  /// argument item's `text` is just the argument. Null when the answer has
  /// no `items` list.
  static NgSlashCompletion? parse(String text, Object? result) {
    if (result is! Map) return null;
    final raw = result['items'];
    if (raw is! List) return null;
    final from = result['replace_from'];
    final replaceFrom = from is int ? from : 1;
    final argument = replaceFrom > 1;
    final items = <NgSlashSuggestion>[];
    final seen = <String>{};
    for (final entry in raw) {
      if (entry is! Map) continue;
      final value = entry['text'];
      if (value is! String || value.trim().isEmpty) continue;
      final display = entry['display'] is String
          ? (entry['display'] as String).trim()
          : '';
      final meta = entry['meta'] is String ? entry['meta'] as String : '';
      if (argument) {
        final insert = value.trimRight();
        if (!seen.add(insert)) continue;
        items.add(
          NgSlashSuggestion(
            label: display.isNotEmpty ? display : insert.trim(),
            insert: insert,
            description: meta.trim(),
            kind: NgSlashSuggestionKind.option,
          ),
        );
        continue;
      }
      final name = value.trim().replaceFirst(RegExp(r'^/+'), '');
      if (name.isEmpty || name.contains(RegExp(r'[\s/]'))) continue;
      final insert = '/$name';
      if (!seen.add(insert.toLowerCase())) continue;
      final skill = entry['kind'] == 'skill';
      items.add(
        NgSlashSuggestion(
          label: display.isEmpty
              ? insert
              : display.startsWith('/')
              ? display
              : '/$display',
          insert: insert,
          description: _plainMeta(meta),
          kind: skill
              ? NgSlashSuggestionKind.skill
              : NgSlashSuggestionKind.command,
        ),
      );
    }
    return NgSlashCompletion(text, List.unmodifiable(items), replaceFrom);
  }

  /// The completer prefixes skill, bundle and plugin descriptions with a
  /// glyph; the box marks skills itself.
  static String _plainMeta(String meta) =>
      meta.trim().replaceFirst(RegExp(r'^(?:⚡|▣|🔌)\s*'), '');
}

final Expando<bool> _completeUnsupported = Expando(
  'nextgen complete.slash missing',
);

/// Whether [connection] (the live socket, or the gateway when none is
/// exposed) answered `complete.slash` with method-not-found. A reconnect is
/// a new socket and asks again.
bool ngCompleteSlashUnsupported(Object? connection) =>
    connection != null && _completeUnsupported[connection] == true;

/// Asks the gateway for ranked matches for [text]. The socket adds the
/// connection's profile, as it does for every NextGen call; a live
/// [sessionId] binds the chat's workspace (project-local skills). Throws
/// what the call throws; marks the socket on method-not-found.
Future<NgSlashCompletion?> ngCompleteSlash(
  NextGenGateway gateway,
  String text, {
  String? sessionId,
}) async {
  try {
    final result = await gateway.call('complete.slash', {
      'text': text,
      'session_id': ?sessionId,
    }, timeout: kNgSlashSuggestTimeout);
    return NgSlashCompletion.parse(text, result);
  } on JsonRpcError catch (error) {
    if (ngIsMethodNotFound(error)) {
      _completeUnsupported[gateway.socket ?? gateway] = true;
    }
    rethrow;
  }
}

/// Descriptions for NextGen's own commands when the catalogue has none.
typedef NgLocalCommandDescriptions = String Function(String name);

/// The command-stage rows for [name] without the gateway's ranking: the
/// loaded catalogue, aliases and NextGen's own commands, prefix matches
/// first, then substring. With no catalogue, NextGen's own commands come
/// first and Classic's fallback set (what a send would still run) follows
/// when [fallback] says the catalogue is not merely on its way.
List<NgSlashSuggestion> ngLocalSlashSuggestions(
  String name,
  NgSlashCatalog catalog, {
  NgLocalCommandDescriptions? localDescription,
  bool fallback = true,
  int limit = 60,
}) {
  final query = name.toLowerCase();
  final rows = <({String name, String description, bool skill})>[];
  final known = <String>{};
  void add(String raw, String description, {bool skill = false}) {
    final key = raw.toLowerCase();
    if (!known.add(key)) return;
    // Only what a send would run.
    if (catalog.resolve(raw) == null) return;
    rows.add((name: raw, description: description, skill: skill));
  }

  final commands = catalog.commands;
  if (commands != null) {
    for (final command in commands) {
      add(
        command.name,
        command.description,
        skill: command.category == 'Skills',
      );
    }
  }
  for (final local in kNgLocalSlashCommands) {
    add(local, localDescription?.call(local) ?? '');
  }
  if (commands == null && fallback) {
    for (final command in kSlashExecutableCommands) {
      add(command, '');
    }
  }

  final prefix = <NgSlashSuggestion>[];
  final contains = <NgSlashSuggestion>[];
  for (final row in rows) {
    final lower = row.name.toLowerCase();
    final match = lower.startsWith(query)
        ? prefix
        : lower.contains(query)
        ? contains
        : null;
    match?.add(
      NgSlashSuggestion(
        label: '/${row.name}',
        insert: '/${row.name}',
        description: row.description,
        kind: row.skill
            ? NgSlashSuggestionKind.skill
            : NgSlashSuggestionKind.command,
      ),
    );
  }
  // An alias the user is typing (`/b` → `/bg`) shows as typed, described by
  // its command. Not while browsing a bare `/`.
  final aliases = <NgSlashSuggestion>[];
  if (query.isNotEmpty) {
    for (final MapEntry(key: alias, value: target) in catalog.aliases.entries) {
      if (!alias.startsWith(query) || known.contains(alias)) continue;
      final info = catalog.resolve(alias);
      if (info == null) continue;
      aliases.add(
        NgSlashSuggestion(
          label: '/$alias',
          insert: '/$alias',
          description: info.description.isNotEmpty
              ? info.description
              : '/$target',
        ),
      );
    }
  }
  return List.unmodifiable([...prefix, ...aliases, ...contains].take(limit));
}

/// The gateway's command rows narrowed to what a send would run, with
/// NextGen's own commands added when they match and the gateway left them
/// out.
List<NgSlashSuggestion> ngRunnableSlashSuggestions(
  NgSlashCompletion completion,
  String name,
  NgSlashCatalog catalog, {
  NgLocalCommandDescriptions? localDescription,
}) {
  final rows = <NgSlashSuggestion>[];
  final seen = <String>{};
  for (final item in completion.items) {
    final bare = item.insert.substring(1);
    if (catalog.resolve(bare) == null) continue;
    if (!seen.add(bare.toLowerCase())) continue;
    rows.add(item);
  }
  final query = name.toLowerCase();
  for (final local in kNgLocalSlashCommands) {
    if (seen.contains(local) || !local.contains(query)) continue;
    final info = catalog.resolve(local);
    rows.add(
      NgSlashSuggestion(
        label: '/$local',
        insert: '/$local',
        description: (info?.description.isNotEmpty ?? false)
            ? info!.description
            : localDescription?.call(local) ?? '',
      ),
    );
  }
  return List.unmodifiable(rows);
}
