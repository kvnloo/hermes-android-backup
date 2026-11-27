import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';
import '../services/locale_preference.dart';
import 'companion_draft.dart';
import 'petdex.dart';

/// Command-line marker for the companion process. It carries no account data.
const petWindowMarker = '--ares-pet-companion-v1';
const petWindowReady = 'ARES_PET_COMPANION_READY_V1';
const petWindowFailed = 'ARES_PET_COMPANION_FAILED_V1';

bool get supportsPetWindow =>
    !kIsWeb &&
    switch (defaultTargetPlatform) {
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows => true,
      _ => false,
    };

/// Desktop builds open a separate process. Tests and phones use the in-app
/// overlay, which has the same composer and portrait.
Future<void> openPetCompanion(
  BuildContext context,
  PetdexController controller,
) async {
  if (!controller.enabled) return;
  final overlay = !supportsPetWindow || _runningTests;
  if (overlay) {
    if (!context.mounted) return;
    await showCompanionOverlay(context, controller);
    return;
  }
  try {
    await _petWindow.open();
  } catch (_) {
    if (!context.mounted) return;
    await showCompanionOverlay(context, controller);
  }
}

bool get _runningTests => Platform.environment.containsKey('FLUTTER_TEST');

/// At most one companion window. Pop out while one is open, or still
/// starting, reuses it instead of starting another process.
class PetWindowSlot {
  PetWindowSlot(this._launch);

  /// Starts a window. Completes once it is ready; `exited` completes when
  /// the window's process ends.
  final Future<({Future<void> exited})> Function() _launch;
  Future<void>? _starting;
  var _open = false;

  bool get isOpen => _open;

  Future<void> open() {
    if (_open) return Future<void>.value();
    return _starting ??= _start();
  }

  Future<void> _start() async {
    try {
      final (:exited) = await _launch();
      _open = true;
      unawaited(
        exited.then<void>((_) {}, onError: (Object _) {}).whenComplete(() {
          _open = false;
        }),
      );
    } finally {
      _starting = null;
    }
  }
}

final _petWindow = PetWindowSlot(_spawnPetWindow);

Future<({Future<void> exited})> _spawnPetWindow() async {
  Directory? directory;
  Process? started;
  try {
    final cache = await getTemporaryDirectory();
    await cache.create(recursive: true);
    directory = await cache.createTemp('ares-pet-');
    final process = started = await Process.start(
      Platform.resolvedExecutable,
      const [petWindowMarker],
      workingDirectory: directory.path,
    );
    final ready = Completer<void>();
    process.stdout
        .transform(const Utf8Decoder(allowMalformed: true))
        .transform(const LineSplitter())
        .listen((line) {
          if (line == petWindowReady && !ready.isCompleted) {
            ready.complete();
            return;
          }
          if (line == petWindowFailed && !ready.isCompleted) {
            ready.completeError(StateError('Companion window failed.'));
            return;
          }
          _takeCompose(line);
        });
    unawaited(process.stderr.drain<void>());
    unawaited(
      process.exitCode.then((_) async {
        if (!ready.isCompleted) {
          ready.completeError(StateError('Companion window closed.'));
        }
        try {
          await directory?.delete(recursive: true);
        } on FileSystemException {
          // A crashed child can leave the directory for the OS to collect.
        }
      }),
    );
    await ready.future.timeout(const Duration(seconds: 45));
    return (exited: process.exitCode.then<void>((_) {}));
  } catch (_) {
    // A window that never became ready must not linger behind the overlay.
    started?.kill();
    try {
      await directory?.delete(recursive: true);
    } on FileSystemException {
      // A failed launch can leave the directory for the OS to collect.
    }
    rethrow;
  }
}

void _takeCompose(String line) {
  try {
    final decoded = jsonDecode(line);
    if (decoded is Map && decoded['compose'] is String) {
      CompanionDraft.offer(decoded['compose'] as String);
    }
  } on FormatException {
    // Ready and failure markers are not JSON.
  }
}

Future<void> showCompanionOverlay(
  BuildContext context,
  PetdexController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => _CompanionComposer(controller: controller),
  );
}

/// Entry point for the desktop companion process.
Future<void> runPetCompanionChild() async {
  try {
    final preferences = await SharedPreferences.getInstance();
    final controller = PetdexController(preferences);
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: preferredSupportedLocales(),
        locale: LocalePreference.read(preferences),
        localeListResolutionCallback: resolvePreferredLocale,
        home: _PetWindow(controller: controller),
      ),
    );
  } catch (_) {
    stdout.writeln(petWindowFailed);
  }
}

class _PetWindow extends StatefulWidget {
  const _PetWindow({required this.controller});

  final PetdexController controller;

  @override
  State<_PetWindow> createState() => _PetWindowState();
}

class _PetWindowState extends State<_PetWindow> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stdout.writeln(petWindowReady);
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: _CompanionComposer(
        controller: widget.controller,
        onSubmit: (text) => stdout.writeln(jsonEncode({'compose': text})),
      ),
    ),
  );
}

class _CompanionComposer extends StatefulWidget {
  const _CompanionComposer({required this.controller, this.onSubmit});

  final PetdexController controller;
  final ValueChanged<String>? onSubmit;

  @override
  State<_CompanionComposer> createState() => _CompanionComposerState();
}

class _CompanionComposerState extends State<_CompanionComposer> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _send() {
    final text = _text.text.trim();
    if (text.isEmpty) return;
    final submit = widget.onSubmit;
    if (submit != null) {
      submit(text);
    } else {
      CompanionDraft.offer(text);
    }
    _text.clear();
  }

  @override
  Widget build(BuildContext context) {
    final hint = context.sharedL10n.appearance_message_from_your_companion;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PetCompanion.full(controller: widget.controller),
          TextField(
            controller: _text,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _send(),
            decoration: InputDecoration(labelText: hint),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: FilledButton(
              onPressed: _send,
              child: Text(context.sharedL10n.appearance_send_to_the_open_chat),
            ),
          ),
        ],
      ),
    );
  }
}
