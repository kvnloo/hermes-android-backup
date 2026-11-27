// Running a typed `/command` on the gateway from NextGen, the way Kyllene
// and Classic do: `slash.exec` first, then `command.dispatch` only after a
// definite refusal. Rules shared by the chat controller, the composer and
// the highlight.
import '../nextgen_l10n.dart';
import '../../core/services/ws_client.dart';
import '../../core/widgets/slash_command_highlight.dart';

/// Commands NextGen answers itself. They always run, whatever the catalogue
/// says: `/new` and `/reset` start a new chat, `/stop` stops the running turn
/// and a bare `/model` opens the model sheet.
const Set<String> kNgLocalSlashCommands = {'new', 'reset', 'stop', 'model'};

/// Commands that open an Ares screen when typed bare: `/kanban` the board,
/// `/bots` the bots screen. Always highlighted, listed by the gateway or not;
/// with an argument they go to the gateway like any other command.
Map<String, String> get kNgScreenSlashCommands => {
  'kanban': ngL.ng_slash_kanban,
  'bots': ngL.ng_slash_bots,
};

/// How long a send waits for a catalogue that is still loading before it
/// decides with Classic's fallback set instead.
const Duration kNgSlashCatalogWait = Duration(seconds: 2);

/// How long one `slash.exec` or `command.dispatch` may take (Kyllene's).
const Duration kNgSlashCommandTimeout = Duration(seconds: 60);

/// A typed `/name args` line, split the way the gateway splits it.
class NgSlashLine {
  const NgSlashLine(this.name, this.arg);

  /// Lower-cased, without the slash.
  final String name;

  /// The argument with outer whitespace trimmed; its interior (newlines
  /// included) kept as typed.
  final String arg;

  /// The line as `slash.exec` takes it: no leading slash.
  String get line => arg.isEmpty ? name : '$name $arg';

  /// The command as shown on its card.
  String get label => '/$line';

  bool get isLocal => kNgLocalSlashCommands.contains(name);

  /// The command at the start of [text], parsed with the highlight's token
  /// rule: leading whitespace skipped, a lone `/`, a slash mid-sentence or a
  /// path such as `/usr/bin` is prose (null).
  static NgSlashLine? parse(String text) {
    final token = SlashCommandToken.parse(text);
    if (token == null) return null;
    return NgSlashLine(
      token.name.toLowerCase(),
      text.substring(token.end).trim(),
    );
  }

  /// The command an alias reply names, with the typed argument appended the
  /// way the gateway resolves quick-command aliases.
  NgSlashLine? aliasedTo(String target) {
    final parsed = parse(target.trim().startsWith('/') ? target : '/$target');
    if (parsed == null) return null;
    final args = [parsed.arg, arg].where((a) => a.isNotEmpty).join(' ');
    return NgSlashLine(parsed.name, args);
  }
}

/// `slash.exec` does not exist on this connection (an older gateway). Said
/// once by `-32601`: nothing ran, so the line goes out as a prompt, and later
/// commands on the same socket skip the call. A reconnect forgets it, since
/// the gateway may have been upgraded meanwhile.
bool ngIsMethodNotFound(JsonRpcError error) => error.code == -32601;

/// The TUI gateway's explicit "use command.dispatch for /x" refusal (skills,
/// `/snapshot restore`). It answers before running anything.
bool ngIsDispatchRedirect(JsonRpcError error) =>
    error.reason == null &&
    error.code == 4018 &&
    error.message.contains('use command.dispatch');

/// `command.dispatch` had nothing for the name either.
bool ngIsNotDispatchable(JsonRpcError error) => RegExp(
  r'not a quick/plugin/(?:bundle/)?skill command',
  caseSensitive: false,
).hasMatch(error.message);

final Expando<bool> _execUnsupported = Expando('nextgen slash.exec missing');

/// Whether [connection] (the live socket, or the gateway when none is
/// exposed) answered `slash.exec` with method-not-found.
bool ngSlashExecUnsupported(Object? connection) =>
    connection != null && _execUnsupported[connection] == true;

void ngMarkSlashExecUnsupported(Object connection) =>
    _execUnsupported[connection] = true;

/// The colour codes a terminal slash worker prints mean nothing on a card.
final RegExp _ansi = RegExp(r'\x1B\[[0-?]*[ -/]*[@-~]');

String ngStripAnsi(String text) => text.replaceAll(_ansi, '');
