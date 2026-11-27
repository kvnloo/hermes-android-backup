import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/attachment_draft.dart';
import '../models/connection.dart';
import 'attachment_draft_service.dart';
import 'hermes_sign_in.dart';
import 'mobile_push_service.dart';

/// Local journal, not an outbox. Nothing here can send to a gateway. Only the
/// exact occurrences installed by Restore may adopt a frozen request.
enum PreparedImageTransport { classicRefs, nextgenCanonical, nextgenPending }

final class PreparedImageTarget {
  PreparedImageTarget(
    SavedConnection connection,
    String session,
    this.transport,
  ) : key = sha256
          .convert(
            utf8.encode(
              jsonEncode([
                MobilePushService.binding(connection),
                _principal(connection),
                session,
                transport.name,
              ]),
            ),
          )
          .toString();
  final String key;
  final PreparedImageTransport transport;

  static String? _principal(SavedConnection connection) {
    final url = connection.singleLoginUrl;
    if (url == null) return null;
    final session = HermesSignInVault.instance.sessionFor(url);
    // A rotating unidentifiable login misses an old draft rather than lending
    // it to another principal. Only the outer digest is persisted.
    return jsonEncode([
      session?.provider,
      session?.userId,
      if (session?.userId?.isNotEmpty != true) session?.accessToken,
    ]);
  }
}

class PreparedImageException implements Exception {
  const PreparedImageException();
  @override
  String toString() => 'Could not verify the prepared image draft.';
}

class PreparedImageEntry {
  PreparedImageEntry._(
    this._dir,
    this.target,
    this.id,
    this.text,
    this.prompt,
    this.wireImages,
    this._images,
    this.created,
    this.copyOnly,
  );
  final Directory _dir;
  final PreparedImageTarget target;
  final String id, text, prompt;
  final List<Map<String, String>> wireImages;
  final List<Map<String, dynamic>> _images;
  final DateTime created;
  final bool copyOnly;
  int get imageCount => _images.length;
}

/// Transport hooks sit at the real RPC boundary. A pending-images gateway
/// holds images as mutable session state; its ID is never reusable. A legacy
/// fallback is marked *before* the identityless call, including on ACK loss.
class PreparedImageAttempt {
  PreparedImageAttempt(this.entry, {this.adopted = false});
  final PreparedImageEntry entry;
  final bool adopted;
  String get id => entry.id;
  bool _legacy = false;

  Future<void> beforeLegacy() async {
    if (adopted || _legacy) throw const PreparedImageException();
    await File('${entry._dir.path}/legacy').writeAsString('1', flush: true);
    _legacy = true;
  }

  Future<void> receipt(Object? result, String sessionId) async {
    // The RPC id correlates this reply to this submission. Canonical Hermes
    // mints a separate admission_id; it does not echo the submission UUID.
    final ref = result is Map ? result['ref'] : null;
    final canonical =
        ref is Map &&
        ref['session_id'] == sessionId &&
        ref['profile_id'] is String &&
        (ref['profile_id'] as String).isNotEmpty &&
        result is Map &&
        result['admission_id'] is String &&
        (result['admission_id'] as String).isNotEmpty &&
        result['sequence'] is int &&
        result['authority_epoch'] is int;
    if (result is! Map ||
        (ref != null && !canonical) ||
        (result['session_id'] != null && result['session_id'] != sessionId) ||
        (!canonical &&
            !_legacy &&
            (result['submission_id'] ?? result['admission_id']) != id) ||
        !const {
          'queued',
          'started',
          'terminal',
          'unknown',
          'streaming',
          'steered',
          'redirected',
          'interrupted',
        }.contains(result['status'])) {
      throw const PreparedImageException();
    }
    await PreparedImageStore.retire(entry);
  }
}

class PreparedImageCapture {
  PreparedImageCapture._(
    this._staging,
    this.drafts,
    this._metadata,
    this._publishedId,
  );
  final Directory _staging;
  final String? _publishedId;
  final List<AttachmentDraft> drafts;
  final List<Map<String, dynamic>> _metadata;
  Future<void> close() async {
    if (_publishedId != null) {
      PreparedImageStore._preparing.remove(_staging.path);
      PreparedImageStore.changes.value++;
      return; // Recovery owns it until receipt/discard.
    }
    if (await _staging.exists()) await _staging.delete(recursive: true);
  }
}

class PreparedImageStore {
  static bool isRestored(AttachmentDraft draft) => _origin[draft] != null;
  PreparedImageStore({
    this.support = getApplicationSupportDirectory,
    this.cache = getTemporaryDirectory,
  });
  final Future<Directory> Function() support, cache;
  static final shared = PreparedImageStore();
  static final changes = ValueNotifier<int>(0);
  // Fallback fence if storage will neither mark nor unpublish an admitted ID.
  static final _spent = <String>{};
  static final _preparing = <String>{};
  static Future<bool> _available(Directory dir) async =>
      !_spent.contains(dir.path) &&
      !_preparing.contains(dir.path) &&
      await dir.exists() &&
      !await File('${dir.path}/spent').exists();
  static final _origin = Expando<({PreparedImageEntry entry, int index})>();
  static final _uuid = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  );
  static const _maxText = 1024 * 1024;

  static bool supports(String text, List<AttachmentDraft> images) =>
      images.isNotEmpty &&
      images.length <= maxRemoteAttachmentDrafts &&
      !text.trimLeft().startsWith('/') &&
      images.every((d) => d.isImage);

  Future<Directory> _scope(PreparedImageTarget t) async =>
      Directory('${(await support()).path}/prepared-images-v1/${t.key}');

  /// Upload these private snapshots, never re-read a picker file after upload
  /// and assume its *current* bytes describe the frozen wire payload.
  Future<PreparedImageCapture> capture(
    List<AttachmentDraft> drafts, {
    ({PreparedImageTarget target, String text})? beforeUpload,
  }) async {
    if (!supports('', drafts) ||
        (beforeUpload?.text.length ?? 0) > _maxText ||
        drafts.any(
          (d) => d.byteLength <= 0 || d.byteLength > maxNextGenAttachmentBytes,
        )) {
      throw const PreparedImageException();
    }
    final root = beforeUpload == null
        ? Directory('${(await support()).path}/prepared-images-v1')
        : await _scope(beforeUpload.target);
    await root.create(recursive: true);
    final staging = await root.createTemp('.capture-');
    final id = beforeUpload == null ? null : const Uuid().v4();
    final published = id == null ? staging : Directory('${root.path}/$id');
    try {
      final images = <Map<String, dynamic>>[];
      final copies = <AttachmentDraft>[];
      for (final draft in drafts) {
        final source = File(draft.cachedPath);
        if (await source.length() != draft.byteLength) {
          throw const PreparedImageException();
        }
        final saved = await source.copy('${staging.path}/${images.length}');
        if (await saved.length() != draft.byteLength) {
          throw const PreparedImageException();
        }
        copies.add(
          AttachmentDraft(
            id: draft.id,
            cachedPath: '${published.path}/${images.length}',
            name: draft.name,
            byteLength: draft.byteLength,
            mediaType: draft.mediaType,
            kind: draft.kind,
            sourceImageFormat: draft.sourceImageFormat,
            sanitized: draft.sanitized,
          ),
        );
        images.add({
          'name': draft.name,
          'mime': draft.mediaType,
          'size': draft.byteLength,
          'sha': (await sha256.bind(saved.openRead()).single).toString(),
          'sanitized': draft.sanitized,
          'format': draft.sourceImageFormat?.name,
        });
      }
      if (beforeUpload != null) {
        // Uploads do not yet give us frozen wire references. A process exit
        // here must leave the original bytes and caption, but no retry identity.
        await File('${staging.path}/before-upload.json').writeAsString(
          jsonEncode({
            'text': beforeUpload.text,
            'prompt': '',
            'wireImages': [],
            'images': images,
            'created': DateTime.now().millisecondsSinceEpoch,
            'copyOnly': true,
          }),
          flush: true,
        );
        await staging.rename(published.path);
        _preparing.add(published.path);
      }
      return PreparedImageCapture._(published, copies, images, id);
    } catch (_) {
      await staging.delete(recursive: true);
      throw const PreparedImageException();
    }
  }

  /// Publish by renaming a complete private directory. Per-intent files avoid
  /// cross-chat read/modify/write races; IDs never come from stored paths.
  Future<PreparedImageAttempt> prepare(
    PreparedImageTarget target,
    String text,
    PreparedImageCapture capture, {
    required String prompt,
    List<Map<String, String>> wireImages = const [],
    bool copyOnly = false,
  }) async {
    if (text.length > _maxText || prompt.length > _maxText) {
      throw const PreparedImageException();
    }
    final id = capture._publishedId ?? const Uuid().v4();
    final root = await _scope(target);
    await root.create(recursive: true);
    final staging = capture._staging;
    if (capture._publishedId != null && staging.path != '${root.path}/$id') {
      throw const PreparedImageException();
    }
    final metadata = {
      'text': text,
      'prompt': prompt,
      'wireImages': wireImages,
      'images': capture._metadata,
      'created': DateTime.now().millisecondsSinceEpoch,
      'copyOnly': copyOnly,
    };
    final tmp = File('${staging.path}/entry.pending');
    await tmp.writeAsString(jsonEncode(metadata), flush: true);
    await tmp.rename('${staging.path}/entry.json');
    _preparing.remove(staging.path);
    final dir = capture._publishedId != null
        ? staging
        : await staging.rename('${root.path}/$id');
    final attempt = PreparedImageAttempt(await _read(target, dir, id));
    changes.value++;
    return attempt;
  }

  Future<PreparedImageEntry> _read(
    PreparedImageTarget target,
    Directory dir,
    String id,
  ) async {
    final prepared = File('${dir.path}/entry.json');
    final manifest = await prepared.exists()
        ? prepared
        : File('${dir.path}/before-upload.json');
    final data = jsonDecode(await manifest.readAsString()) as Map;
    final images = (data['images'] as List).cast<Map<String, dynamic>>();
    if (images.isEmpty || images.length > maxRemoteAttachmentDrafts) {
      throw const PreparedImageException();
    }
    return PreparedImageEntry._(
      dir,
      target,
      id,
      data['text'] as String,
      data['prompt'] as String,
      List.unmodifiable([
        for (final image in data['wireImages'] as List)
          Map<String, String>.unmodifiable(image as Map),
      ]),
      images,
      DateTime.fromMillisecondsSinceEpoch(data['created'] as int),
      data['copyOnly'] == true || await File('${dir.path}/legacy').exists(),
    );
  }

  Future<List<PreparedImageEntry>> list(PreparedImageTarget target) async {
    final root = await _scope(target);
    if (!await root.exists()) return [];
    final entries = <PreparedImageEntry>[];
    await for (final dir in root.list(followLinks: false)) {
      final id = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
      if (dir is! Directory || !_uuid.hasMatch(id)) continue;
      try {
        if (!await _available(dir)) continue;
        entries.add(await _read(target, dir, id));
      } on FileSystemException {
        if (await dir.exists()) rethrow; // retired during enumeration
      }
    }
    return entries..sort((a, b) => b.created.compareTo(a.created));
  }

  /// A failed journal read would also fail on tap, so do not offer recovery.
  Future<bool> hasRecoverable(PreparedImageTarget target) async {
    try {
      return (await list(target)).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Restore copies, not the journal's files. An edit, navigation, or receipt
  /// during I/O cancels the install and cleans up its temporary copies.
  Future<List<AttachmentDraft>?> restore(
    PreparedImageEntry entry,
    bool Function() stillEmpty,
  ) async {
    if (!stillEmpty()) return null;
    final root = await cache();
    final out = <AttachmentDraft>[];
    final files = <File>[];
    try {
      for (final (index, image) in entry._images.indexed) {
        if (!stillEmpty()) return null;
        final id = const Uuid().v4();
        final file = File('${root.path}/recovered-$id');
        files.add(file);
        await File('${entry._dir.path}/$index').copy(file.path);
        if (!await _matches(file, image)) throw const PreparedImageException();
        final draft = AttachmentDraft(
          id: id,
          cachedPath: file.path,
          name: image['name'] as String,
          byteLength: image['size'] as int,
          mediaType: image['mime'] as String,
          kind: AttachmentDraftKind.image,
          sanitized: image['sanitized'] == true,
          sourceImageFormat: AttachmentImageFormat.values
              .where((v) => v.name == image['format'])
              .firstOrNull,
        );
        _origin[draft] = (entry: entry, index: index);
        out.add(draft);
      }
      if (!await _available(entry._dir) || !stillEmpty()) return null;
      files.clear();
      return out;
    } finally {
      for (final file in files) {
        if (await file.exists()) await file.delete();
      }
    }
  }

  static Future<bool> _matches(File file, Map<String, dynamic> image) async =>
      await file.length() == image['size'] &&
      (await sha256.bind(file.openRead()).single).toString() == image['sha'];

  Future<PreparedImageAttempt?> adopt(
    PreparedImageTarget target,
    String text,
    List<AttachmentDraft> drafts,
  ) async {
    if (drafts.isEmpty) return null;
    for (final draft in drafts) {
      final bound = _origin[draft]?.entry.target.key;
      if (bound != null && bound != target.key) {
        throw const PreparedImageException();
      }
    }
    final prior = _origin[drafts.first]?.entry;
    if (prior == null ||
        prior.target.key != target.key ||
        text != prior.text ||
        prior.copyOnly ||
        drafts.length != prior.imageCount) {
      return null;
    }
    for (final (i, draft) in drafts.indexed) {
      final origin = _origin[draft];
      if (!identical(prior, origin?.entry) ||
          origin?.index != i ||
          !await _matches(File(draft.cachedPath), prior._images[i])) {
        return null;
      }
    }
    // An unchanged but already spent retry is never turned into a fresh send.
    if (!await _available(prior._dir) ||
        await File('${prior._dir.path}/legacy').exists()) {
      throw const PreparedImageException();
    }
    return PreparedImageAttempt(prior, adopted: true);
  }

  static Future<void> retire(PreparedImageEntry entry) async {
    final dir = entry._dir;
    if (!await dir.exists()) return;
    try {
      _spent.add(dir.path);
      // Either marker or rename suffices: a deletion/rename failure must not
      // turn an acknowledged item into another adoptable admission on restart.
      try {
        await File('${dir.path}/spent').writeAsString('1', flush: true);
      } on FileSystemException {
        /* still try to unpublish */
      }
      final Directory gone;
      try {
        gone = await dir.rename('${dir.path}.retired');
      } on FileSystemException {
        if (!await dir.exists() || await File('${dir.path}/spent').exists()) {
          _spent.remove(dir.path);
          return;
        }
        rethrow;
      }
      _spent.remove(dir.path);
      try {
        await gone.delete(recursive: true);
      } on FileSystemException {
        /* already unpublished */
      }
    } finally {
      changes.value++;
    }
  }
}
