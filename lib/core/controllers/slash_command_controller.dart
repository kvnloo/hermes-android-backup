import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/slash_command.dart';

/// Returns the command token when [text] is a single leading slash token.
///
/// This is the dropdown trigger: a trailing space, a newline, an argument or a
/// slash anywhere else is a normal message, so the dropdown never intercepts
/// prose or URLs and only shows while the first token is being typed.
String? slashCommandQuery(String text) {
  if (!text.startsWith('/')) return null;
  if (text.length > 1 && text.contains(RegExp(r'\s'))) return null;
  return text.substring(1);
}

/// Returns the command name at the start of [text], arguments included.
///
/// This is the send gate: the gateway parses the whole line itself
/// (`/title My chat`, `/yolo on`), so only the leading whitespace-delimited
/// token decides whether the line is a command. A lone `/` is not one.
String? slashCommandName(String text) {
  if (!text.startsWith('/')) return null;
  final token = text.split(RegExp(r'\s')).first;
  final name = token.substring(1);
  return name.isEmpty ? null : name;
}

/// Owns slash-command trigger detection, the per-connection catalogue cache
/// and the local per-keystroke filter.
///
/// It never submits a prompt and never edits the composer: execution stays on
/// the chat screen's existing send path so the busy-steer contract from #191
/// keeps exactly one owner.
class SlashCommandController extends ChangeNotifier {
  SlashCommandController({
    required this.loadCatalog,
    String cacheScope = '',
    this.limit = 8,
    SlashCommandRefusals? refusals,
    this.localCommands,
  }) : _scope = cacheScope {
    _refusals = refusals ?? SlashCommandRefusals();
    _memoryEpoch = _refusals.epoch;
    _refusals.addListener(_onMemoryChanged);
  }

  final Future<SlashCommandCatalog> Function() loadCatalog;
  final int limit;

  /// Commands the app runs itself (Classic's `/kanban` and `/bots` open a
  /// screen). Offered whatever the gateway's catalogue lists, after its own
  /// commands; a gateway entry of the same name wins.
  final List<SlashCommand> Function()? localCommands;

  List<SlashCommand> get _local => localCommands?.call() ?? const [];

  bool _isLocal(String name) {
    final bare = name.trim().replaceFirst(RegExp(r'^/+'), '').toLowerCase();
    return _local.any((command) => command.name.toLowerCase() == bare);
  }

  late SlashCommandRefusals _refusals;
  int _memoryEpoch = 0;
  void _onMemoryChanged() {
    if (_memoryEpoch != _refusals.epoch) {
      _memoryEpoch = _refusals.epoch;
      invalidate();
    } else {
      _notify();
    }
  }

  int get generation => _generation;
  void useRefusals(SlashCommandRefusals refusals) {
    if (identical(_refusals, refusals)) return;
    _refusals.removeListener(_onMemoryChanged);
    _refusals = refusals;
    _memoryEpoch = _refusals.epoch;
    _refusals.addListener(_onMemoryChanged);
    invalidate();
  }

  String _scope;
  SlashCommandCatalog? _catalog;
  Object? _catalogError;
  Future<bool>? _flight;
  int _generation = 0;
  bool _open = false;
  String _query = '';
  bool _disposed = false;

  /// Whether the dropdown should be visible for the current draft. Local
  /// commands keep it usable when the catalogue cannot load.
  bool get isOpen => _open && (_catalogError == null || _local.isNotEmpty);

  bool get catalogLoaded =>
      _catalog != null || (_catalogError != null && _local.isNotEmpty);

  /// The loaded catalogue (read-only), or null before it loads.
  SlashCommandCatalog? get catalog => _catalog;

  /// A failed catalogue fetch disables the feature without touching the
  /// composer; it never rethrows into the text field's listener.
  bool get catalogUnavailable => _catalogError != null;

  String get query => _query;

  List<SlashCommand> get matches {
    final catalog = _catalog;
    if (catalog == null && !catalogLoaded) return const [];
    final query = _query.toLowerCase();
    final visible = [
      if (catalog != null)
        ...catalog.commands.where(
          (command) =>
              catalog.canExecute(command.name) &&
              !_refusals.contains(catalog.canonicalName(command.name)),
        ),
      for (final command in _local)
        if (catalog == null || !catalog.containsName(command.name)) command,
    ];
    if (query.isEmpty) {
      return List<SlashCommand>.unmodifiable(visible.take(limit));
    }
    final prefix = <SlashCommand>[];
    final contains = <SlashCommand>[];
    for (final command in visible) {
      final name = command.name.toLowerCase();
      if (name.startsWith(query)) {
        prefix.add(command);
      } else if (name.contains(query)) {
        contains.add(command);
      }
    }
    return List<SlashCommand>.unmodifiable(
      [...prefix, ...contains].take(limit),
    );
  }

  /// Feeds composer text changes into the dropdown. Returns whether [text]
  /// keeps the dropdown open.
  bool updateText(String text) {
    final query = slashCommandQuery(text);
    if (query == null) {
      close();
      return false;
    }
    final opening = !_open || _query != query;
    _open = true;
    _query = query;
    if (opening || _catalog == null) {
      unawaited(ensureCatalog());
    }
    _notify();
    return isOpen;
  }

  /// Loads the immutable catalogue once per scope. A
  /// successful response is cached until [invalidate]; a failure is sticky
  /// until the next explicit invalidation (connection change) and never
  /// retried per keystroke.
  Future<bool> ensureCatalog() {
    if (_disposed) return Future<bool>.value(false);
    if (_catalog != null) return Future<bool>.value(true);
    if (_catalogError != null) return Future<bool>.value(false);
    final flight = _flight;
    if (flight != null) return flight;
    final generation = _generation;
    final started = _load(generation);
    _flight = started;
    return started;
  }

  Future<bool> _load(int generation) async {
    try {
      final catalog = await loadCatalog();
      if (_disposed || generation != _generation) return false;
      _catalog = catalog;
      _catalogError = null;
      _notify();
      return true;
    } catch (error) {
      if (_disposed || generation != _generation) return false;
      _catalogError = error;
      if (_local.isEmpty) _open = false;
      _notify();
      return false;
    } finally {
      if (!_disposed && generation == _generation) _flight = null;
    }
  }

  /// Whether the gateway dispatches [name] through `slash.exec`.
  ///
  /// A loaded catalogue is authoritative. Without one, the reviewed
  /// [kSlashExecutableCommands] set is only a last-resort hint: the dispatch
  /// path still attempts a `/`-line and the server's `unsupported_command`
  /// reply is never permission to resend the command as prose.
  bool isExecutable(String name) {
    if (_isLocal(name)) return true;
    final catalog = _catalog;
    if (catalog != null) return catalog.canExecute(name);
    final bare = name.trim().replaceFirst(RegExp(r'^/+'), '').toLowerCase();
    return bare.isNotEmpty && kSlashExecutableCommands.contains(bare);
  }

  /// Records that the gateway refused [name] with `unsupported_command`; the
  /// dropdown stops offering it until the connection memory is reset.
  void markRefused(String name) {
    final catalog = _catalog;
    if (_disposed) return;
    _refusals.mark(
      catalog?.canonicalName(name) ??
          name.replaceFirst(RegExp(r'^/+'), '').toLowerCase(),
    );
  }

  bool knowsCommand(String name) =>
      _isLocal(name) || (_catalog?.containsName(name) ?? false);

  /// Drops the cache. Called on connection changes and scope switches.
  void invalidate() {
    _generation++;
    _catalog = null;
    _catalogError = null;
    _flight = null;
    _open = false;
    _query = '';
    _notify();
  }

  /// Invalidates only when the cache scope (connection/session) changed.
  void updateScope(String scope) {
    if (scope == _scope) return;
    _scope = scope;
    invalidate();
  }

  void close() {
    if (!_open && _query.isEmpty) return;
    _open = false;
    _query = '';
    _notify();
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _refusals.removeListener(_onMemoryChanged);
    super.dispose();
  }
}
