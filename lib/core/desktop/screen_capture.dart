/// Screen capture into the composer as an attachment draft (desktop).
///
/// The runner owns the platform consent: macOS Screen Recording permission
/// (frontmost window of another app), the Windows Graphics Capture picker,
/// and the xdg-desktop-portal screenshot dialog on Linux. The capture is a
/// PNG in a private temporary folder; the composer turns it into a draft
/// with the existing attachment path and the folder is removed. Nothing is
/// sent: the user reviews the draft and presses Send.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/l10n.dart';
import 'desktop_os.dart';

enum CapturePermission { granted, denied, prompt, notRequired }

@immutable
class CaptureStatus {
  const CaptureStatus({required this.supported, required this.permission});

  static const unsupported = CaptureStatus(
    supported: false,
    permission: CapturePermission.notRequired,
  );

  final bool supported;
  final CapturePermission permission;

  bool get ready =>
      supported &&
      (permission == CapturePermission.granted ||
          permission == CapturePermission.notRequired);

  static CaptureStatus fromWire(Object? value) {
    if (value is! Map) return unsupported;
    final permission = switch (value['permission']) {
      'granted' => CapturePermission.granted,
      'denied' => CapturePermission.denied,
      'prompt' => CapturePermission.prompt,
      _ => CapturePermission.notRequired,
    };
    return CaptureStatus(
      supported: value['supported'] == true,
      permission: permission,
    );
  }
}

enum CaptureFailure { permissionDenied, cancelled, unsupported, failed }

@immutable
class CaptureResult {
  const CaptureResult.file(File this.file) : failure = null;
  const CaptureResult.failed(CaptureFailure this.failure) : file = null;

  final File? file;
  final CaptureFailure? failure;
}

/// The largest capture accepted from a runner.
const maxCaptureBytes = 25 * 1024 * 1024;

class ScreenCaptureController {
  ScreenCaptureController({
    this._channel = DesktopOsChannels.capture,
    Future<Directory> Function()? temporaryDirectory,
  }) : _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;

  static ScreenCaptureController shared = ScreenCaptureController();

  final MethodChannel _channel;
  final Future<Directory> Function() _temporaryDirectory;
  bool _busy = false;

  Future<CaptureStatus> status() => _status('status');

  /// Asks the OS for permission where it has a prompt (macOS).
  Future<CaptureStatus> requestPermission() => _status('requestPermission');

  /// Opens the OS privacy settings for screen recording (macOS).
  Future<bool> openSettings() async {
    try {
      return await _channel.invokeMethod<bool>('openSettings') == true;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<CaptureStatus> _status(String method) async {
    if (!isDesktopOs) return CaptureStatus.unsupported;
    try {
      return CaptureStatus.fromWire(
        await _channel.invokeMethod<Object>(method),
      );
    } on MissingPluginException {
      return CaptureStatus.unsupported;
    } on PlatformException {
      return CaptureStatus.unsupported;
    }
  }

  /// Captures into a new private folder. The runner must return a PNG
  /// inside that folder; anything else is rejected and removed.
  Future<CaptureResult> capture() async {
    if (_busy) return const CaptureResult.failed(CaptureFailure.failed);
    _busy = true;
    Directory? directory;
    try {
      final root = await _temporaryDirectory();
      await root.create(recursive: true);
      directory = await root.createTemp('ares-capture-');
      final Object? raw;
      try {
        raw = await _channel.invokeMethod<Object>('capture', {
          'directory': directory.path,
        });
      } on MissingPluginException {
        await _remove(directory);
        return const CaptureResult.failed(CaptureFailure.unsupported);
      } on PlatformException catch (e) {
        await _remove(directory);
        return CaptureResult.failed(switch (e.code) {
          'permission-denied' => CaptureFailure.permissionDenied,
          'cancelled' => CaptureFailure.cancelled,
          'unsupported' => CaptureFailure.unsupported,
          _ => CaptureFailure.failed,
        });
      }
      final file = await _validate(raw, directory);
      if (file == null) {
        await _remove(directory);
        return const CaptureResult.failed(CaptureFailure.failed);
      }
      return CaptureResult.file(file);
    } catch (_) {
      if (directory != null) await _remove(directory);
      return const CaptureResult.failed(CaptureFailure.failed);
    } finally {
      _busy = false;
    }
  }

  static Future<File?> _validate(Object? raw, Directory directory) async {
    if (raw is! String || !raw.toLowerCase().endsWith('.png')) return null;
    final file = File(raw);
    final parent = await file.parent.resolveSymbolicLinks();
    final expected = await directory.resolveSymbolicLinks();
    if (parent != expected) return null;
    if (await FileSystemEntity.type(raw, followLinks: false) !=
        FileSystemEntityType.file) {
      return null;
    }
    final length = await file.length();
    if (length == 0 || length > maxCaptureBytes) return null;
    // PNG signature.
    final head = await file.openRead(0, 8).expand((b) => b).toList();
    const signature = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
    for (var i = 0; i < signature.length; i++) {
      if (i >= head.length || head[i] != signature[i]) return null;
    }
    return file;
  }

  /// Removes a capture's private folder once the draft has its own copy.
  static Future<void> discard(File file) => _remove(file.parent);

  static Future<void> _remove(Directory directory) async {
    try {
      await directory.delete(recursive: true);
    } on FileSystemException {
      // The OS cleans the temporary folder later.
    }
  }
}

/// Whether to offer **Capture screen** in an attach sheet: only where the
/// runner reports capture as supported (`status().supported`), not merely
/// on a desktop OS. A macOS permission that is still to be granted counts as
/// supported; the action asks for it.
Future<bool> screenCaptureOffered([ScreenCaptureController? controller]) async {
  if (!isDesktopOs) return false;
  final status = await (controller ?? ScreenCaptureController.shared).status();
  return status.supported;
}

/// Runs the capture flow for a composer: permission explanation, capture,
/// then [attach] with the PNG (which must copy it into a draft). Returns
/// whether a draft was attached. Never sends.
Future<bool> captureScreenIntoDraft(
  BuildContext context, {
  required Future<void> Function(File png, String displayName) attach,
  ScreenCaptureController? controller,
}) async {
  final capture = controller ?? ScreenCaptureController.shared;
  final l = context.sharedL10n;
  void say(String text) => ScaffoldMessenger.maybeOf(
    context,
  )?.showSnackBar(SnackBar(content: Text(text)));

  var status = await capture.status();
  if (!context.mounted) return false;
  if (!status.supported) {
    say(l.capture_screen_unavailable);
    return false;
  }
  if (status.permission == CapturePermission.prompt) {
    status = await capture.requestPermission();
    if (!context.mounted) return false;
  }
  if (!status.ready) {
    await showCapturePermissionDialog(context, capture);
    return false;
  }
  final result = await capture.capture();
  if (!context.mounted) {
    final file = result.file;
    if (file != null) await ScreenCaptureController.discard(file);
    return false;
  }
  final file = result.file;
  if (file == null) {
    switch (result.failure) {
      case CaptureFailure.cancelled:
        break;
      case CaptureFailure.permissionDenied:
        await showCapturePermissionDialog(context, capture);
      case CaptureFailure.unsupported:
        say(l.capture_screen_unavailable);
      case CaptureFailure.failed || null:
        say(l.capture_screen_failed);
    }
    return false;
  }
  try {
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(RegExp(r'[:.]'), '-')
        .split('T')
        .join(' ');
    await attach(file, 'Screenshot $stamp.png');
    return true;
  } finally {
    await ScreenCaptureController.discard(file);
  }
}

/// Explains the macOS Screen Recording permission with a way to the
/// setting. The OS owns the grant; Ares never changes it.
Future<void> showCapturePermissionDialog(
  BuildContext context,
  ScreenCaptureController capture,
) {
  final l = context.sharedL10n;
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      key: const Key('capture-permission-dialog'),
      title: Text(l.capture_permission_title),
      content: Text(l.capture_permission_body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const Key('capture-open-settings'),
          onPressed: () {
            Navigator.of(dialogContext).pop();
            unawaited(capture.openSettings());
          },
          child: Text(l.capture_open_settings),
        ),
      ],
    ),
  );
}
