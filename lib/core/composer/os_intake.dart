// Files the OS hands the composer: dropped from the desktop, or pasted from
// the clipboard as files or an image. Both layouts turn them into attachment
// drafts through their existing pipeline; nothing here sends anything.
import 'dart:async';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/l10n.dart';
import 'windows_clipboard_image.dart';

/// Desktop targets, where windows take OS drops and Cmd/Ctrl+V can carry
/// files or an image. Mobile pastes images through the keyboard instead
/// ([composerImageInsertion]).
bool get composerDesktopIntake =>
    !kIsWeb &&
    const {
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
    }.contains(defaultTargetPlatform);

/// Image types a keyboard (or the clipboard) may insert into the composer.
const kComposerImageMimeTypes = [
  'image/png',
  'image/jpeg',
  'image/webp',
  'image/gif',
];

/// A file or folder the OS dropped on the composer.
class OsIntakeFile {
  const OsIntakeFile(this.path, {this.directory = false, this.bookmark});

  final String path;
  final bool directory;

  /// macOS security-scoped bookmark for a file outside the sandbox.
  final Uint8List? bookmark;

  String get name =>
      path.split(RegExp(r'[\\/]')).where((part) => part.isNotEmpty).last;
}

/// Files or an image on the clipboard, besides text.
class ClipboardAttachment {
  const ClipboardAttachment({this.files = const [], this.image});

  final List<String> files;
  final Uint8List? image;
}

/// Test seam for the clipboard read (no platform channel in tests).
@visibleForTesting
Future<ClipboardAttachment?> Function()? debugClipboardAttachmentReader;

/// What the clipboard holds besides text, or null (text, nothing, or a
/// platform without the reader).
Future<ClipboardAttachment?> readClipboardAttachment() async {
  final debug = debugClipboardAttachmentReader;
  if (debug != null) return debug();
  if (!composerDesktopIntake) return null;
  try {
    final files = await Pasteboard.files();
    final usable = [
      for (final path in files)
        if (path.trim().isNotEmpty) path,
    ];
    if (usable.isNotEmpty) return ClipboardAttachment(files: usable);
  } catch (_) {}
  try {
    final image = await Pasteboard.image;
    if (image != null && image.isNotEmpty) {
      return ClipboardAttachment(
        image: defaultTargetPlatform == TargetPlatform.windows
            ? normalizeWindowsClipboardImage(image)
            : image,
      );
    }
  } catch (_) {}
  return null;
}

int _stagedImageSequence = 0;

/// Writes pasted image bytes into the app's cache for the draft pipeline to
/// read; the caller discards it ([discardStagedComposerImage]) afterwards.
Future<String> stageComposerImageBytes(
  Uint8List bytes, {
  String? mimeType,
}) async {
  final extension = switch (mimeType) {
    'image/jpeg' => 'jpg',
    'image/webp' => 'webp',
    'image/gif' => 'gif',
    _ => 'png',
  };
  final root = await getTemporaryDirectory();
  final dir = Directory('${root.path}/composer-paste');
  await dir.create(recursive: true);
  final file = File(
    '${dir.path}/pasted-${DateTime.now().microsecondsSinceEpoch}-${_stagedImageSequence++}.$extension',
  );
  try {
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  } catch (_) {
    await discardStagedComposerImage(file.path);
    rethrow;
  }
}

/// Removes a staged paste image once the draft pipeline has made its own
/// sanitised copy (or refused it).
Future<void> discardStagedComposerImage(String path) async {
  try {
    await File(path).delete();
  } catch (_) {}
}

/// Clipboard file paths as intake files, folders marked.
Future<List<OsIntakeFile>> osIntakeFilesFor(Iterable<String> paths) async => [
  for (final path in paths)
    OsIntakeFile(
      path,
      directory:
          await FileSystemEntity.type(path) == FileSystemEntityType.directory,
    ),
];

/// A pasted local path that names a file on this device (not a folder, not
/// a missing path), as an intake file; otherwise null.
Future<OsIntakeFile?> localFileForPastedPath(String path) async {
  try {
    return await FileSystemEntity.type(path) == FileSystemEntityType.file
        ? OsIntakeFile(path)
        : null;
  } catch (_) {
    return null;
  }
}

/// Runs [body] with read access to a dropped file that lives outside the
/// macOS sandbox (its security-scoped bookmark), then gives it back.
Future<T> withDroppedFileAccess<T>(
  OsIntakeFile file,
  Future<T> Function() body,
) async {
  final bookmark = file.bookmark;
  var started = false;
  if (bookmark != null &&
      bookmark.isNotEmpty &&
      defaultTargetPlatform == TargetPlatform.macOS) {
    try {
      started = await DesktopDrop.instance.startAccessingSecurityScopedResource(
        bookmark: bookmark,
      );
    } catch (_) {}
  }
  try {
    return await body();
  } finally {
    if (started) {
      try {
        await DesktopDrop.instance.stopAccessingSecurityScopedResource(
          bookmark: bookmark!,
        );
      } catch (_) {}
    }
  }
}

/// Takes files dropped from the OS on desktop, showing a hint while a drag
/// is over it. Elsewhere it is just [child].
class OsFileDropTarget extends StatefulWidget {
  const OsFileDropTarget({
    super.key,
    required this.child,
    required this.onFiles,
    this.enabled = true,
  });

  final Widget child;
  final ValueChanged<List<OsIntakeFile>> onFiles;
  final bool enabled;

  @override
  State<OsFileDropTarget> createState() => _OsFileDropTargetState();
}

class _OsFileDropTargetState extends State<OsFileDropTarget> {
  bool _over = false;

  @override
  Widget build(BuildContext context) {
    if (!composerDesktopIntake) return widget.child;
    return DropTarget(
      enable: widget.enabled,
      onDragEntered: (_) => setState(() => _over = true),
      onDragExited: (_) => setState(() => _over = false),
      onDragDone: (details) {
        setState(() => _over = false);
        final files = <OsIntakeFile>[
          for (final item in details.files)
            if (item.path.isNotEmpty)
              OsIntakeFile(
                item.path,
                directory: item is DropItemDirectory,
                bookmark: item.extraAppleBookmark,
              ),
        ];
        if (files.isNotEmpty) widget.onFiles(files);
      },
      child: Stack(
        children: [
          widget.child,
          if (_over)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.08),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(context.sharedL10n.composer_drop_attach),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Paste (Cmd/Ctrl+V) that takes files or an image from the clipboard as
/// attachments; plain text pastes as it always did. The editor's paste
/// action is overridable, so this sits above the TextField.
class ClipboardAttachmentPaste extends StatefulWidget {
  const ClipboardAttachmentPaste({
    super.key,
    required this.child,
    required this.onAttachment,
    this.enabled = true,
    this.owner,
  });

  final Widget child;
  final Future<void> Function(ClipboardAttachment found) onAttachment;

  /// Changes invalidate reads started before a chat/connection handoff.
  final Object? owner;

  /// Flutter's toolbar calls EditableTextState.pasteText directly, bypassing
  /// Actions, and hides Paste when the clipboard has no text. Route both
  /// toolbar and keyboard paste through the same intake without reading the
  /// clipboard merely to display the menu. Labels remain Flutter-localized.
  static Widget contextMenuBuilder(
    BuildContext context,
    EditableTextState editor,
  ) {
    if (!composerDesktopIntake) {
      // Preserve iOS's system menu and the ordinary mobile/web toolbar.
      if (SystemContextMenu.isSupportedByField(editor)) {
        return SystemContextMenu.editableText(editableTextState: editor);
      }
      return AdaptiveTextSelectionToolbar.editableText(
        editableTextState: editor,
      );
    }
    final intake = editor.context
        .findAncestorStateOfType<_ClipboardAttachmentPasteState>();
    final items = editor.contextMenuButtonItems;
    if (intake != null && composerDesktopIntake && intake.widget.enabled) {
      final paste = ContextMenuButtonItem(
        type: ContextMenuButtonType.paste,
        onPressed: () {
          editor.hideToolbar();
          unawaited(
            intake._paste(
              () => editor.pasteText(SelectionChangedCause.toolbar),
            ),
          );
        },
      );
      final index = items.indexWhere(
        (item) => item.type == ContextMenuButtonType.paste,
      );
      if (index < 0) {
        items.add(paste);
      } else {
        items[index] = paste;
      }
    }
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: editor.contextMenuAnchors,
      buttonItems: items,
    );
  }

  /// When false (the composer takes no attachments right now), paste is
  /// the editor's plain text paste. The tree keeps its shape either way, so
  /// the editor below keeps its state (and the keyboard) when this flips.
  final bool enabled;

  @override
  State<ClipboardAttachmentPaste> createState() =>
      _ClipboardAttachmentPasteState();
}

class _ClipboardAttachmentPasteState extends State<ClipboardAttachmentPaste> {
  int _revision = 0;

  @override
  void didUpdateWidget(ClipboardAttachmentPaste oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.owner != widget.owner ||
        oldWidget.enabled != widget.enabled) {
      _revision++;
    }
  }

  Future<void> _paste(VoidCallback fallback) async {
    if (!widget.enabled) {
      fallback();
      return;
    }
    final revision = _revision;
    final attach = widget.onAttachment;
    ClipboardAttachment? found;
    try {
      found = await readClipboardAttachment();
    } catch (_) {
      // A denied/unavailable clipboard must not break ordinary text paste.
    }
    if (!mounted || revision != _revision) return;
    if (found != null) {
      await attach(found);
    } else {
      fallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!composerDesktopIntake && debugClipboardAttachmentReader == null) {
      return widget.child;
    }
    return Actions(
      actions: {PasteTextIntent: _AttachmentPasteAction(_paste)},
      child: widget.child,
    );
  }
}

class _AttachmentPasteAction extends Action<PasteTextIntent> {
  _AttachmentPasteAction(this.paste);

  final Future<void> Function(VoidCallback fallback) paste;

  @override
  Object? invoke(PasteTextIntent intent) {
    final fallback = callingAction;
    unawaited(paste(() => fallback?.invoke(intent)));
    return null;
  }
}

/// A keyboard's image insertion (Android GBoard stickers, pasted images):
/// the bytes become an attachment draft instead of being refused.
ContentInsertionConfiguration composerImageInsertion(
  Future<void> Function(Uint8List bytes, String mimeType) onImage,
) => ContentInsertionConfiguration(
  allowedMimeTypes: kComposerImageMimeTypes,
  onContentInserted: (content) {
    final data = content.data;
    if (data == null || data.isEmpty) return;
    unawaited(onImage(data, content.mimeType));
  },
);
