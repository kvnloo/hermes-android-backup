/// Quick entry: a small always-on-top window for typing a prompt into a
/// chosen chat or a new one.
///
/// It reuses the pop-out child-window machinery: the primary starts the same
/// executable with [quickEntryMarker] (a launch role on Windows), sends one
/// launch frame over stdin (`watchPopoutPipe`), and the child exits when the
/// pipe closes. The child has no connection, credentials or gateway. It can
/// only hand back text and one of the chat ids it was offered; the primary
/// turns that into a validated prefill-only `hermes://` link. Nothing is sent
/// until the user presses Send in the main window.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../services/hermes_deeplink.dart' show HermesLinkOwner;

/// The OS command line carries this marker only.
const quickEntryMarker = '--ares-quick-entry-v1';
const quickEntryReady = 'ARES_QUICK_ENTRY_READY_V1';
const quickEntryFailed = 'ARES_QUICK_ENTRY_FAILED_V1';

/// Largest prompt the window accepts (matches the deep-link prefill bound).
const quickEntryMaxText = 4000;

/// `watchPopoutPipe` accepts launch frames up to 2048 bytes.
const _maxFrameBytes = 2000;
const _maxChats = 12;
const _maxTitle = 60;

final _chatId = RegExp(r'^[A-Za-z0-9._-]{1,128}$');

/// A chat the window may target: the id and its display title.
@immutable
class QuickEntryChat {
  const QuickEntryChat({required this.id, required this.title});

  final String id;
  final String title;

  static bool validId(String id) => _chatId.hasMatch(id);

  Map<String, String> toJson() => {'id': id, 'title': title};

  @override
  bool operator ==(Object other) =>
      other is QuickEntryChat && other.id == id && other.title == title;

  @override
  int get hashCode => Object.hash(id, title);
}

/// The recent chats the active shell offers to quick entry. Classic and
/// NextGen each register a provider while their chat list is mounted,
/// together with the owner of those chats (connection and profile).
abstract final class QuickEntryTargets {
  static List<QuickEntryChat> Function()? _provider;
  static HermesLinkOwner? Function()? _owner;

  /// Registers [provider] and its [owner]; returns the remover, which only
  /// removes this one.
  static VoidCallback register(
    List<QuickEntryChat> Function() provider, {
    HermesLinkOwner? Function()? owner,
  }) {
    _provider = provider;
    _owner = owner;
    return () {
      if (identical(_provider, provider)) {
        _provider = null;
        _owner = null;
      }
    };
  }

  static List<QuickEntryChat> current() {
    try {
      return _provider?.call() ?? const [];
    } catch (_) {
      return const [];
    }
  }

  /// The connection and profile whose chats [current] lists.
  static HermesLinkOwner? currentOwner() {
    try {
      return _owner?.call();
    } catch (_) {
      return null;
    }
  }
}

String _clean(String text) => String.fromCharCodes(
  text.runes.where((r) => r == 10 || r == 9 || (r >= 32 && r != 127)),
);

/// The launch frame: the chats offered and the app language.
@immutable
class QuickEntryLaunch {
  const QuickEntryLaunch({required this.chats, required this.locale});

  final List<QuickEntryChat> chats;
  final String locale;

  /// Builds a frame that fits the pipe's bound: titles are shortened and
  /// later chats dropped rather than failing the launch.
  factory QuickEntryLaunch.bounded(
    Iterable<QuickEntryChat> chats, {
    required String locale,
  }) {
    final kept = <QuickEntryChat>[];
    final seen = <String>{};
    for (final chat in chats) {
      if (kept.length >= _maxChats) break;
      if (!QuickEntryChat.validId(chat.id) || !seen.add(chat.id)) continue;
      var title = _clean(chat.title).replaceAll(RegExp(r'\s+'), ' ').trim();
      if (title.runes.length > _maxTitle) {
        title = '${String.fromCharCodes(title.runes.take(_maxTitle - 1))}…';
      }
      final next = [...kept, QuickEntryChat(id: chat.id, title: title)];
      final frame = QuickEntryLaunch(chats: next, locale: locale);
      if (utf8.encode(frame.encode()).length > _maxFrameBytes) break;
      kept.add(next.last);
    }
    return QuickEntryLaunch(chats: List.unmodifiable(kept), locale: locale);
  }

  String encode() => jsonEncode({
    'chats': [for (final chat in chats) chat.toJson()],
    'locale': locale,
  });

  static QuickEntryLaunch decode(Map<String, dynamic> frame) {
    final chats = frame['chats'];
    final locale = frame['locale'];
    if (frame.length != 2 ||
        chats is! List ||
        chats.length > _maxChats ||
        locale is! String ||
        !RegExp(r'^[a-zA-Z]{2,3}([_-][a-zA-Z]{2,4})?$').hasMatch(locale)) {
      throw const FormatException('Invalid quick entry frame.');
    }
    final parsed = <QuickEntryChat>[];
    for (final entry in chats) {
      if (entry case {
        'id': final String id,
        'title': final String title,
      } when entry.length == 2 && QuickEntryChat.validId(id)) {
        parsed.add(QuickEntryChat(id: id, title: _clean(title)));
      } else {
        throw const FormatException('Invalid quick entry chat.');
      }
    }
    return QuickEntryLaunch(chats: List.unmodifiable(parsed), locale: locale);
  }
}

/// What the window hands back: text for the composer and, optionally, one
/// of the offered chats. Never a command and never a send.
@immutable
class QuickEntryPrefill {
  const QuickEntryPrefill({required this.text, this.sessionId, this.owner});

  final String text;

  /// Null for a new chat.
  final String? sessionId;

  /// Whose chats were offered (the shell's connection and profile when the
  /// window opened). Set by the primary, never by the child.
  final HermesLinkOwner? owner;

  QuickEntryPrefill withOwner(HermesLinkOwner? owner) =>
      QuickEntryPrefill(text: text, sessionId: sessionId, owner: owner);

  String encode() => jsonEncode({'prefill': text, 'session': sessionId});

  /// Parses one line from the child. Only a chat id the primary offered is
  /// accepted; anything else (or any other shape) is dropped.
  static QuickEntryPrefill? parse(
    String line,
    Iterable<QuickEntryChat> offered,
  ) {
    final Object? decoded;
    try {
      decoded = jsonDecode(line);
    } on FormatException {
      return null;
    }
    if (decoded case {
      'prefill': final String raw,
      'session': final Object? session,
    } when decoded.length == 2) {
      final text = _clean(raw).trim();
      if (text.isEmpty || text.length > quickEntryMaxText) return null;
      if (session == null) return QuickEntryPrefill(text: text);
      if (session is! String || !offered.any((c) => c.id == session)) {
        return null;
      }
      return QuickEntryPrefill(text: text, sessionId: session);
    }
    return null;
  }

  /// The prefill-only `hermes://` link for the deep-link router, which
  /// validates it again before any UI changes.
  String toDeepLink() {
    final id = sessionId;
    return id == null
        ? Uri(
            scheme: 'hermes',
            host: 'open',
            path: '/chat',
            queryParameters: {'prefill': text},
          ).toString()
        : Uri(
            scheme: 'hermes',
            host: 'session',
            path: '/$id',
            queryParameters: {'prefill': text},
          ).toString();
  }
}

typedef QuickEntrySpawn = Future<Process> Function();

Future<Process> _spawnQuickEntry() =>
    Process.start(Platform.resolvedExecutable, const [quickEntryMarker]);

/// The primary's side: at most one quick-entry window. Showing it while it
/// is open closes it (the hotkey toggles).
class QuickEntryLauncher {
  QuickEntryLauncher({
    required this._chats,
    required this._locale,
    required this._onPrefill,
    this._owner,
    this._onSpawned,
    QuickEntrySpawn? spawn,
    this.readyTimeout = const Duration(seconds: 45),
  }) : _spawn = spawn ?? _spawnQuickEntry;

  final List<QuickEntryChat> Function() _chats;
  final HermesLinkOwner? Function()? _owner;

  /// Called with the child's process id as soon as it starts, so the
  /// primary can let exactly that process take the foreground.
  final void Function(int pid)? _onSpawned;
  final String Function() _locale;
  final void Function(QuickEntryPrefill prefill) _onPrefill;
  final QuickEntrySpawn _spawn;
  final Duration readyTimeout;

  /// True while a window is starting or open.
  final ValueNotifier<bool> active = ValueNotifier(false);

  Process? _process;
  Future<bool>? _starting;
  bool _disposed = false;

  /// Opens the window, or closes it when one is already open.
  Future<bool> toggle() {
    if (_process != null && _starting == null) {
      close();
      return Future.value(false);
    }
    return show();
  }

  /// Opens the window; completes with whether it became ready.
  Future<bool> show() {
    if (_disposed) return Future.value(false);
    if (_process != null && _starting == null) return Future.value(true);
    return _starting ??= _start().whenComplete(() => _starting = null);
  }

  void close() {
    final process = _process;
    if (process == null) return;
    _process = null;
    active.value = false;
    process.kill();
  }

  Future<bool> _start() async {
    // The chats and their owner are captured together: the hand-back goes
    // to this connection and profile, whatever is showing when it returns.
    final owner = _owner?.call();
    final launch = QuickEntryLaunch.bounded(_chats(), locale: _locale());
    final Process process;
    try {
      process = await _spawn();
    } catch (_) {
      return false;
    }
    if (_disposed) {
      process.kill();
      return false;
    }
    // Only this child may take the foreground (Windows); never any process.
    _onSpawned?.call(process.pid);
    _process = process;
    active.value = true;
    final ready = Completer<bool>();
    var handedBack = false;
    process.stdout
        .transform(const Utf8Decoder(allowMalformed: true))
        .transform(const LineSplitter())
        .listen(
          (line) {
            if (!ready.isCompleted) {
              if (line == quickEntryReady) ready.complete(true);
              if (line == quickEntryFailed) ready.complete(false);
              return;
            }
            // One prefill per window, only from the window still open.
            if (handedBack || !identical(_process, process)) return;
            final prefill = QuickEntryPrefill.parse(line, launch.chats);
            if (prefill == null) return;
            handedBack = true;
            _onPrefill(prefill.withOwner(owner));
          },
          onError: (Object _) {
            if (!ready.isCompleted) ready.complete(false);
          },
        );
    unawaited(process.stderr.drain<void>().catchError((Object _) {}));
    unawaited(
      process.exitCode.then((_) {
        if (!ready.isCompleted) ready.complete(false);
        if (identical(_process, process)) {
          _process = null;
          active.value = false;
        }
      }),
    );
    process.stdin.done.ignore();
    try {
      process.stdin.writeln(launch.encode());
      await process.stdin.flush(); // The pipe stays open until exit.
    } catch (_) {
      if (!ready.isCompleted) ready.complete(false);
    }
    final ok = await ready.future.timeout(readyTimeout, onTimeout: () => false);
    if (!ok && identical(_process, process)) close();
    return ok;
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    close();
  }
}
