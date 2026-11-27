import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../nextgen/nextgen_preferences.dart';
import '../screens/parallel_workspace_entry.dart';
import '../services/completion_cue_player.dart';
import '../services/connection_mutation_barrier.dart';
import '../services/hermes_sign_in.dart';
import '../services/notification_prefs.dart';
import '../widgets/chat_presence.dart';
import 'popout_owner.dart';
import 'popout_protocol.dart';

bool get supportsWorkspacePopout =>
    !kIsWeb &&
    switch (defaultTargetPlatform) {
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows => true,
      _ => false,
    };

final _openTargets = <String>{};

/// Tells a launched pop-out whenever sharing chat activity is off, so an
/// opt-out reaches open windows at once. Returns the remover. The child copied
/// the preference at launch; this line can only take authority away.
@visibleForTesting
VoidCallback forwardActivityOptOut(IOSink stdin) {
  var told = false;
  void sync() {
    if (notificationPrefs.value.shareWindowActivity) {
      told = false;
      return;
    }
    if (told) return;
    told = true;
    try {
      stdin.writeln(workspacePopoutStopActivity);
    } on Object {
      // The child has exited; its reports ended with it.
    }
  }

  notificationPrefs.addListener(sync);
  sync();
  return () => notificationPrefs.removeListener(sync);
}

/// The main window's half of the cue hand-off for one open pop-out.
///
/// A chat open in both windows must play its completion cue once. Desktop
/// gives each cue to one window (`ownsAmbientCue`); here the main window
/// decides, from what both windows show, and tells the pop-out
/// ([workspacePopoutCueMain] / [workspacePopoutCuePopout]):
///
/// * the pop-out plays while it holds presence for the chat (it reports
///   [workspacePopoutPresenceHeld]) and the main window does not;
/// * otherwise the main window plays when it shows the chat;
/// * otherwise the pop-out plays: it is the only window with the chat.
///
/// The main window plays the chat's cue only while its last line gave it the
/// cue, and the pop-out only while that line gave the cue to the pop-out, so
/// the two windows never both play it.
class PopoutCueLink {
  PopoutCueLink._(this.cueKey, this._send);

  final String cueKey;
  final void Function(String line) _send;
  bool _held = false;
  bool? _popoutPlays;

  /// What the pop-out was last told; null before the first line.
  bool? get popoutPlays => _popoutPlays;

  /// The pop-out's latest [workspacePopoutPresenceHeld] or
  /// [workspacePopoutPresenceFree] line.
  void childPresence(bool held) {
    _held = held;
    _sync();
  }

  void _sync() {
    final presence = ChatPresenceCoordinator.instance;
    final plays = (_held && !presence.holds(cueKey)) || !presence.shows(cueKey);
    if (plays == _popoutPlays) return;
    _popoutPlays = plays;
    try {
      _send(plays ? workspacePopoutCuePopout : workspacePopoutCueMain);
    } on Object {
      // The child has exited; its cue ended with it.
    }
  }

  /// The pop-out closed: the main window plays every cue for this chat.
  void close() {
    if (!identical(_cueLinks[cueKey], this)) return;
    _cueLinks.remove(cueKey);
    if (_cueLinks.isNotEmpty) return;
    ChatPresenceCoordinator.instance.changes.removeListener(_syncCueLinks);
    final player = CompletionCuePlayer.instance;
    if (player.ownership == _mainPlaysCue) player.ownership = null;
  }
}

final _cueLinks = <String, PopoutCueLink>{};

void _syncCueLinks() {
  for (final link in List.of(_cueLinks.values)) {
    link._sync();
  }
}

bool _mainPlaysCue(String key) => _cueLinks[key]?.popoutPlays != true;

/// Starts the cue hand-off for a launched pop-out of [target]; [send] writes
/// one line to its stdin. The first line goes out at once.
@visibleForTesting
PopoutCueLink linkPopoutCue(
  PopoutTarget target,
  void Function(String line) send,
) {
  if (_cueLinks.isEmpty) {
    ChatPresenceCoordinator.instance.changes.addListener(_syncCueLinks);
    CompletionCuePlayer.instance.ownership = _mainPlaysCue;
  }
  final link = PopoutCueLink._(target.cueKey, send);
  _cueLinks[link.cueKey] = link;
  link._sync();
  return link;
}

/// Opens only from the keyed workspace entry. A launched child has no root
/// navigator, connection chooser or durable app-state writer. No shell, URI
/// handler, or separate installed executable participates in the hand-off.
Future<void> openWorkspacePopout(
  BuildContext context, {
  required String sessionId,
  required String connectionId,
  required String profile,
  required bool nextGen,
}) async {
  final l10n = context.sharedL10n;
  try {
    if (!supportsWorkspacePopout) throw UnsupportedError('Desktop only');
    final target = PopoutTarget(
      sessionId: sessionId,
      connectionId: connectionId,
      profile: profile,
      nextGen: nextGen,
    );
    final owner = ParallelWorkspaceEntryHost.popoutOwner(context);
    if (owner == null) throw StateError('No workspace owner');
    final connection = owner.connection;
    final nonce = const Uuid().v4();
    final proof = popoutOwnerProof(nonce, connection);
    bool current() =>
        owner.current() &&
        nextGenEnabled.value == nextGen &&
        matchesPopoutOwner(target, connection);
    if (!current()) throw StateError('Owner changed');
    if (!_openTargets.add(target.key)) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            l10n.release_core_workspace_popout_this_chat_already_has_a_pop_out_window,
          ),
        ),
      );
      return;
    }
    await _openNative(
      target,
      nonce,
      proof,
      current,
      () => popoutOwnerProof(nonce, connection) == proof,
    );
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            l10n.release_core_workspace_popout_could_not_open_this_saved_chat_check_the,
          ),
        ),
      );
    }
  }
}

Future<void> _openNative(
  PopoutTarget target,
  String nonce,
  String proof,
  bool Function() current,
  bool Function() credentialsCurrent,
) async {
  Directory? directory;
  Process? child;
  var retired = false;
  var listening = true;
  VoidCallback? stopForwarding;
  PopoutCueLink? cue;
  final ready = Completer<bool>();
  void retire() {
    retired = true;
    child?.kill(
      Platform.isWindows ? ProcessSignal.sigterm : ProcessSignal.sigkill,
    );
    if (!ready.isCompleted) ready.complete(false);
  }

  void check() {
    try {
      if (!current()) retire();
    } catch (_) {
      retire();
    }
  }

  void afterFrame(Duration _) {
    if (!listening || retired) return;
    // Route/gateway replacement and app-root disposal are visible after the
    // current frame. This callback watches frames; it never schedules one.
    check();
    if (!retired) WidgetsBinding.instance.addPostFrameCallback(afterFrame);
  }

  void checkCredentials() {
    try {
      if (!credentialsCurrent()) retire();
    } catch (_) {
      retire();
    }
  }

  void detach() {
    listening = false;
    stopForwarding?.call();
    stopForwarding = null;
    cue?.close();
    cue = null;
    _openTargets.remove(target.key);
    ConnectionMutationBarrier.removeListener(check);
    HermesSignInVault.instance.removeListener(checkCredentials);
    nextGenEnabled.removeListener(check);
  }

  Future<void> clean() async {
    try {
      await directory?.delete(recursive: true);
    } on FileSystemException {
      // OS cache collection remains possible, e.g. after a machine crash.
    }
  }

  ConnectionMutationBarrier.addListener(check);
  HermesSignInVault.instance.addListener(checkCredentials);
  nextGenEnabled.addListener(check);
  WidgetsBinding.instance.addPostFrameCallback(afterFrame);
  try {
    final cache = await getTemporaryDirectory();
    await cache.create(recursive: true);
    directory = await cache.createTemp('ares-chat-');
    check();
    if (retired) throw StateError('Revoked');
    final process = child = await Process.start(
      Platform.resolvedExecutable,
      const [workspacePopoutMarker],
      workingDirectory: directory.path,
    );
    // Register exit cleanup before any other operation which might fail.
    process.stdin.done.ignore();
    unawaited(
      process.exitCode.then((_) async {
        if (!ready.isCompleted) ready.complete(false);
        detach();
        try {
          await process.stdin.close();
        } on IOException {
          // The reader has already exited.
        }
        await clean();
      }),
    );
    unawaited(process.stderr.drain<void>());
    process.stdout
        .transform(const Utf8Decoder(allowMalformed: true))
        .transform(const LineSplitter())
        .listen((line) {
          if (!ready.isCompleted) {
            if (line == workspacePopoutReady) ready.complete(true);
            if (line == workspacePopoutFailed) ready.complete(false);
            return;
          }
          // After ready, only the pop-out's presence for its chat is read.
          if (line == workspacePopoutPresenceHeld) cue?.childPresence(true);
          if (line == workspacePopoutPresenceFree) cue?.childPresence(false);
        }, onError: (Object _) => retire());
    check();
    if (retired) {
      retire();
      throw StateError('Revoked');
    }
    process.stdin.writeln(
      jsonEncode({'target': target.toJson(), 'nonce': nonce, 'proof': proof}),
    );
    await process.stdin.flush(); // Keep the pipe open until exit.
    if (listening) {
      stopForwarding = forwardActivityOptOut(process.stdin);
      cue = linkPopoutCue(target, process.stdin.writeln);
    }
    final ok = await ready.future.timeout(
      const Duration(seconds: 45),
      onTimeout: () => false,
    );
    check();
    if (!ok || retired) throw StateError('Unavailable');
  } catch (_) {
    retire();
    if (child == null) {
      detach();
      await clean();
    }
    rethrow;
  }
}
