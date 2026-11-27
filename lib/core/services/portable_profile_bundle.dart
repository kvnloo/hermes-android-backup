import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Portable sharing never forwards an opaque host archive to another operator.
/// Rebuild a new tar from explicitly reviewed, bounded regular text files.
/// In particular .env, auth, databases, logs, links, scripts and uploads do not
/// hitch a ride. Configuration and prose can still contain private information.
class PortableProfileBundle {
  const PortableProfileBundle._(this.profile, this.files, this.omitted);
  final String profile;
  final Map<String, String> files;
  final int omitted;

  /// Replace rather than append: review exactly one overlay, not an old
  /// desktop.json alongside the newly generated one.
  PortableProfileBundle withDesktop(String? desktop) {
    final next = Map.of(files)..remove('desktop.json');
    if (desktop != null) next['desktop.json'] = desktop;
    return PortableProfileBundle._(
      profile,
      Map.unmodifiable(next),
      omitted + (desktop == null && files.containsKey('desktop.json') ? 1 : 0),
    );
  }

  static const compressedLimit = 16 * 1024 * 1024,
      expandedLimit = 32 * 1024 * 1024;
  static Future<Uint8List> bounded(Stream<List<int>> input, int limit) async {
    final out = BytesBuilder(copy: false);
    await for (final chunk in input) {
      if (out.length + chunk.length > limit) {
        throw const FormatException('Archive exceeds limit');
      }
      out.add(chunk);
    }
    return out.takeBytes();
  }

  static bool _shareable(String rel) =>
      const {
        'SOUL.md',
        'config.yaml',
        'profile.yaml',
        'desktop.json',
        'cron/jobs.json',
      }.contains(rel) ||
      rel.startsWith('skills/') && rel.endsWith('.md');
  static Future<PortableProfileBundle> inspect(Uint8List bytes) async {
    if (bytes.isEmpty || bytes.length > compressedLimit) {
      throw const FormatException('Archive exceeds limit');
    }
    Stream<List<int>> chunks() async* {
      for (var offset = 0; offset < bytes.length; offset += 4096) {
        yield Uint8List.sublistView(
          bytes,
          offset,
          (offset + 4096).clamp(0, bytes.length),
        );
      }
    }

    final tar = await bounded(gzip.decoder.bind(chunks()), expandedLimit);
    var pos = 0, headers = 0, omitted = 0, skipNext = false, ended = false;
    String? root;
    final files = <String, String>{};
    while (pos + 512 <= tar.length) {
      final start = pos;
      final header = Uint8List.sublistView(tar, start, start + 512);
      pos += 512;
      if (header.every((b) => b == 0)) {
        ended = true;
        break;
      }
      if (++headers > 4096) {
        throw const FormatException('Too many archive members');
      }
      String field(int at, int length) => latin1.decode(
        header.sublist(at, at + length).takeWhile((b) => b != 0).toList(),
      );
      final expected = int.tryParse(field(148, 8).trim(), radix: 8);
      final sum = header.indexed.fold<int>(
        0,
        (s, p) => s + (p.$1 >= 148 && p.$1 < 156 ? 32 : p.$2),
      );
      if (sum != expected) {
        throw const FormatException('Invalid archive header');
      }
      final size = int.tryParse(field(124, 12).trim(), radix: 8);
      if (size == null || size < 0 || pos + size > tar.length) {
        throw const FormatException('Invalid member length');
      }
      final content = Uint8List.sublistView(tar, pos, pos + size);
      pos += ((size + 511) ~/ 512) * 512;
      final kind = field(156, 1);
      if (kind == 'x') {
        // Python tarfile emits a per-member PAX timestamp. Refuse attributes
        // that could change path/size/type interpretation instead of passing on
        // the header to another tar implementation.
        if (size > 4096 ||
            !RegExp(
              r'^(?:[0-9]+ (?:mtime|atime|ctime)=-?[0-9]+(?:\.[0-9]+)?\n)+$',
            ).hasMatch(latin1.decode(content))) {
          throw const FormatException('Unsupported archive metadata');
        }
        continue;
      }
      if (kind == 'g') {
        throw const FormatException('Unsupported global metadata');
      }
      if (kind == 'L' || kind == 'K') {
        skipNext = true;
        continue;
      }
      if (skipNext) {
        omitted++;
        skipNext = false;
        continue;
      }
      if (kind == '5') continue;
      final prefix = field(345, 155);
      final name = '${prefix.isEmpty ? '' : '$prefix/'}${field(0, 100)}';
      final parts = name.split('/');
      if (parts.length < 2 ||
          !RegExp(r'^[a-z0-9][a-z0-9_-]{0,63}$').hasMatch(parts.first) ||
          parts
              .skip(1)
              .any(
                (p) => !RegExp(r'^[A-Za-z0-9_-][A-Za-z0-9_.-]*$').hasMatch(p),
              )) {
        omitted++;
        continue;
      }
      root ??= parts.first;
      if (parts.first != root) {
        throw const FormatException('Mixed profile roots');
      }
      final relative = parts.skip(1).join('/');
      if (!{'', '0'}.contains(kind) ||
          !_shareable(relative) ||
          name.length >= 100 ||
          size > 1024 * 1024) {
        omitted++;
        continue;
      }
      if (files.containsKey(relative)) {
        throw const FormatException('Duplicate member');
      }
      final value = utf8.decode(content);
      if (value.contains('\x00')) {
        omitted++;
        continue;
      }
      files[relative] = value;
    }
    if (!ended || root == null || files.isEmpty) {
      throw const FormatException('No portable profile files');
    }
    return PortableProfileBundle._(root, Map.unmodifiable(files), omitted);
  }

  Uint8List encode(Set<String> reviewed) {
    if (reviewed.isEmpty || !files.keys.toSet().containsAll(reviewed)) {
      throw const FormatException('Select reviewed files');
    }
    final archive = Archive();
    for (final rel in reviewed) {
      archive.addFile(ArchiveFile.string('$profile/$rel', files[rel]!));
    }
    final bytes = Uint8List.fromList(
      gzip.encode(TarEncoder().encodeBytes(archive)),
    );
    if (bytes.length > compressedLimit) {
      throw const FormatException('Archive exceeds limit');
    }
    return bytes;
  }
}
