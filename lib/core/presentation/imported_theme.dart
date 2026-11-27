/// Offline import of VS Code workbench colours. No filesystem, extension host,
/// network, or path resolver is involved. Persist the projection, not the file.
library;

import 'dart:convert';
import 'dart:io' show ZLibDecoder;
import 'dart:typed_data';
import 'dart:ui';

import 'package:archive/archive.dart' show getCrc32;
import 'package:crypto/crypto.dart' show sha256;
import 'package:flutter/foundation.dart' show compute, immutable;
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/hermes_theme.dart' show ImportedThemeSeeds, foregroundFor;

/// Opaque, flattened sRGB colours. The role names are also storage keys.
enum ImportedThemeColor {
  background,
  foreground,
  accent,
  raised,
  card,
  sidebar,
  border,
  input,
  mutedForeground,
  error,
}

/// A single immutable, single-brightness variant. IDs aren't display names.
@immutable
final class ImportedTheme {
  ImportedTheme._(
    this.id,
    this.label,
    this.source,
    this.brightness,
    Map<ImportedThemeColor, Color> colors,
  ) : colors = Map.unmodifiable(colors);

  final String id;
  final String label;

  /// Publisher.extension for Marketplace packages; a generic label for JSON.
  final String source;
  final Brightness brightness;
  final Map<ImportedThemeColor, Color> colors;
  Color operator [](ImportedThemeColor role) => colors[role]!;

  Map<String, Object> _record() => {
    'id': id,
    'label': label,
    'source': source,
    'brightness': brightness.name,
    'colors': {
      for (final r in ImportedThemeColor.values) r.name: this[r].toARGB32(),
    },
  };
}

/// In a picker use `withData: false, withReadStream: true`, then [parseStream].
/// A successful call returns all contributed variants in manifest order; show a
/// choice before saving. Failure is atomic and malformed input throws
/// [FormatException]. Picker I/O errors are propagated separately.
abstract final class ImportedThemeParser {
  static const maxVsixBytes = 16 * 1024 * 1024;
  static const maxJsonBytes = 1024 * 1024;
  static const maxManifestBytes = 256 * 1024;
  static const maxEntries = 1024;
  static const maxVariants = 32;
  static const maxDeclaredBytes = 64 * 1024 * 1024;
  static const maxSelectedBytes = 8 * 1024 * 1024;

  /// Returns the cap for this picker *basename*, or throws for unsupported input.
  static int byteLimit(String fileName) {
    if (fileName.isEmpty ||
        fileName.length > 255 ||
        fileName.contains(RegExp(r'[/\\:\x00-\x1f\x7f]'))) {
      throw const FormatException('Expected a local theme filename.');
    }
    final name = fileName.toLowerCase();
    if (name.endsWith('.vsix')) return maxVsixBytes;
    if (_jsonName(name)) return maxJsonBytes;
    throw const FormatException('Choose a .vsix, .json or .jsonc theme.');
  }

  /// Checks advertised size before subscribing and every actual chunk before
  /// copying. On native platforms decoding/inflation runs off the UI isolate.
  static Future<List<ImportedTheme>> parseStream(
    String fileName,
    Stream<List<int>> stream, {
    int? declaredSize,
  }) async {
    final limit = byteLimit(fileName);
    if (declaredSize != null && (declaredSize <= 0 || declaredSize > limit)) {
      throw const FormatException('Theme file is empty or too large.');
    }
    final bytes = BytesBuilder();
    await for (final chunk in stream) {
      if (chunk.length > (declaredSize ?? limit) - bytes.length) {
        throw const FormatException('Theme file exceeds its size limit.');
      }
      bytes.add(chunk);
    }
    if (declaredSize != null && bytes.length != declaredSize) {
      throw const FormatException('Incomplete theme file.');
    }
    return compute(_parsePicked, (
      fileName,
      bytes.takeBytes(),
    ), debugLabel: 'theme-import');
  }

  /// Synchronous API for bytes already in bounded memory or a worker isolate.
  static List<ImportedTheme> parse(String fileName, Uint8List bytes) {
    final limit = byteLimit(fileName);
    if (bytes.isEmpty || bytes.length > limit) {
      throw const FormatException('Theme file is empty or too large.');
    }
    if (fileName.toLowerCase().endsWith('.vsix')) {
      return List.unmodifiable(_variants(_Vsix(bytes), fileName));
    }
    final raw = _jsonObject(bytes);
    return List.unmodifiable([
      _convert(raw, fallback: _stem(fileName), source: 'Local JSON'),
    ]);
  }
}

List<ImportedTheme> _parsePicked((String, Uint8List) request) =>
    ImportedThemeParser.parse(request.$1, request.$2);

bool _jsonName(String name) =>
    name.toLowerCase().endsWith('.json') ||
    name.toLowerCase().endsWith('.jsonc');
String _stem(String name) => name.substring(0, name.lastIndexOf('.'));

String? _text(Object? value) {
  if (value is! String ||
      value.isEmpty ||
      value.length > 128 ||
      value.contains(
        RegExp(r'[\x00-\x1f\x7f-\x9f\u2028-\u202e\u2066-\u2069]'),
      )) {
    return null;
  }
  final label = value.trim();
  return label.isEmpty ? null : label;
}

List<ImportedTheme> _variants(_Vsix zip, String fileName) {
  final manifest = _jsonObject(
    zip.read('extension/package.json', ImportedThemeParser.maxManifestBytes),
  );
  final contributes = manifest['contributes'];
  final themes = contributes is Map ? contributes['themes'] : null;
  if (themes is! List ||
      themes.isEmpty ||
      themes.length > ImportedThemeParser.maxVariants) {
    throw const FormatException(
      'Expected a bounded list of contributed colour themes.',
    );
  }
  final publisher = _text(manifest['publisher']);
  final extension = _text(manifest['name']);
  final source =
      _text([?publisher, ?extension].join('.')) ??
      _text(_stem(fileName)) ??
      'Local VSIX';
  final paths = <String>{};
  final variants = <({String path, String? label, String? type})>[];
  var selectedBytes = 0;
  for (final item in themes) {
    if (item is! Map || item['path'] is! String) {
      throw const FormatException('Invalid contributed theme.');
    }
    var path = item['path'] as String;
    if (path.startsWith('./')) path = path.substring(2);
    if (!_safePath(path) ||
        !_jsonName(path) ||
        path == 'package.json' ||
        !paths.add(path)) {
      throw const FormatException(
        'Invalid or duplicate contributed theme path.',
      );
    }
    final part = zip.part('extension/$path', ImportedThemeParser.maxJsonBytes);
    selectedBytes += part.size;
    if (selectedBytes > ImportedThemeParser.maxSelectedBytes) {
      throw const FormatException(
        'Contributed themes exceed the import budget.',
      );
    }
    variants.add((
      path: path,
      label: _text(item['label']),
      type: _text(item['uiTheme']),
    ));
  }
  return [
    for (final v in variants)
      _convert(
        _jsonObject(
          zip.read('extension/${v.path}', ImportedThemeParser.maxJsonBytes),
        ),
        fallback: _stem(v.path.split('/').last),
        label: v.label,
        type: v.type,
        source: source,
        identity: [
          'vsix',
          publisher,
          extension,
          if (extension == null) fileName,
          v.path,
        ],
      ),
  ];
}

// JSONC comments and trailing commas are recognised only outside strings.
// Bound structure before jsonDecode creates nested lists/maps, including for
// ignored tokenColors, contributes, and restored preference payloads.
Map<String, dynamic> _jsonObject(Uint8List bytes) {
  try {
    return _decodeObject(utf8.decode(bytes));
  } on FormatException {
    throw const FormatException('Invalid or overly complex theme JSON.');
  }
}

Map<String, dynamic> _decodeObject(String text) {
  final units = Uint16List.fromList(text.codeUnits);
  var depth = 0, tokens = 0, previous = -1, beforePrevious = -1;
  var inString = false;
  for (var i = 0; i < units.length; i++) {
    final c = units[i];
    if (inString) {
      if (c == 92) {
        i++;
      } else if (c == 34) {
        inString = false;
      }
      continue;
    }
    if (c == 32 || c == 10 || c == 13 || c == 9) continue;
    if (c == 47 && i + 1 < units.length) {
      final next = units[i + 1];
      if (next == 47) {
        while (i < units.length && units[i] != 10 && units[i] != 13) {
          units[i++] = 32;
        }
        i--;
        continue;
      }
      if (next == 42) {
        units[i++] = 32;
        units[i++] = 32;
        while (i + 1 < units.length &&
            !(units[i] == 42 && units[i + 1] == 47)) {
          units[i++] = 32;
        }
        if (i + 1 >= units.length) {
          throw const FormatException('Unterminated comment.');
        }
        units[i++] = 32;
        units[i] = 32;
        continue;
      }
    }
    if (c == 34) {
      inString = true;
    }
    if (c == 123 || c == 91) {
      depth++;
      tokens++;
    }
    if (c == 44 || c == 58) tokens++;
    if (c == 125 || c == 93) {
      if (previous >= 0 &&
          units[previous] == 44 &&
          beforePrevious >= 0 &&
          !const {44, 58, 91, 123}.contains(units[beforePrevious])) {
        units[previous] = 32;
      }
      depth--;
    }
    if (depth < 0 || depth > 64 || tokens > 65536) {
      throw const FormatException('JSON too complex.');
    }
    beforePrevious = previous;
    previous = i;
  }
  final decoded = jsonDecode(String.fromCharCodes(units));
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('Expected a JSON object.');
  }
  return decoded;
}

const _keys = <ImportedThemeColor, List<String>>{
  ImportedThemeColor.background: [
    'editor.background',
    'editorPane.background',
    'editorGroup.background',
  ],
  ImportedThemeColor.foreground: ['editor.foreground', 'foreground'],
  ImportedThemeColor.accent: [
    'button.background',
    'textLink.activeForeground',
    'textLink.foreground',
    'activityBarBadge.background',
    'badge.background',
    'progressBar.background',
    'pickerGroup.foreground',
    'list.highlightForeground',
    'editorLink.activeForeground',
    'focusBorder',
    'tab.activeBorder',
    'statusBarItem.remoteBackground',
  ],
  ImportedThemeColor.raised: [
    'editorWidget.background',
    'dropdown.background',
    'menu.background',
    'quickInput.background',
    'editorSuggestWidget.background',
  ],
  ImportedThemeColor.card: [
    'sideBarSectionHeader.background',
    'tab.inactiveBackground',
    'editorGroupHeader.tabsBackground',
  ],
  ImportedThemeColor.sidebar: ['sideBar.background', 'activityBar.background'],
  ImportedThemeColor.border: [
    'panel.border',
    'editorGroup.border',
    'sideBar.border',
    'contrastBorder',
    'widget.border',
    'input.border',
  ],
  ImportedThemeColor.input: [
    'input.background',
    'dropdown.background',
    'quickInput.background',
  ],
  ImportedThemeColor.mutedForeground: [
    'descriptionForeground',
    'editorLineNumber.foreground',
    'tab.inactiveForeground',
    'disabledForeground',
  ],
  ImportedThemeColor.error: [
    'editorError.foreground',
    'errorForeground',
    'editorOverviewRuler.errorForeground',
    'notificationsErrorIcon.foreground',
  ],
};

Color? _hex(Object? raw) {
  if (raw is! String || raw.length > 16) return null;
  final s = raw.trim();
  if (!RegExp(
    r'^#(?:[a-fA-F0-9]{3,4}|[a-fA-F0-9]{6}|[a-fA-F0-9]{8})$',
  ).hasMatch(s)) {
    return null;
  }
  var rgb = s.substring(1);
  if (rgb.length <= 4) rgb = rgb.split('').map((c) => '$c$c').join();
  if (rgb.length == 6) rgb += 'ff';
  return _imported(
    int.parse(rgb.substring(6) + rgb.substring(0, 6), radix: 16),
  );
}

/// The one constructor for imported colours. Every value it builds is user
/// data: a hex code from the theme file, a blend of two of its colours, or a
/// colour read back from the saved import.
Color _imported(int argb) => Color(argb);

Color _mix(Color a, Color b, double amount) =>
    _imported(Color.lerp(a, b, amount)!.toARGB32());
Color _readableAccent(Color accent, Color sidebar) {
  final bg = sidebar.computeLuminance() + 0.05;
  bool passes(Color c) {
    final fg = c.computeLuminance() + 0.05;
    return (fg > bg ? fg / bg : bg / fg) >= 4.5;
  }

  if (passes(accent)) return accent;
  final target = foregroundFor(sidebar);
  for (var i = 1; i < 32; i++) {
    final c = _mix(accent, target, i / 32);
    if (passes(c)) return c;
  }
  return target;
}

ImportedTheme _convert(
  Map<String, dynamic> raw, {
  required String fallback,
  required String source,
  String? label,
  String? type,
  List<Object?>? identity,
}) {
  final colors = raw['colors'];
  if (colors is! Map) {
    throw const FormatException('Theme has no workbench colours.');
  }
  final hits = <ImportedThemeColor, Color>{};
  for (final role in _keys.entries) {
    for (final key in role.value) {
      final color = _hex(colors[key]);
      if (color != null) {
        hits[role.key] = color;
        break;
      }
    }
  }
  if (hits.isEmpty) {
    throw const FormatException('Theme has no supported workbench colours.');
  }
  final backgroundHit = hits[ImportedThemeColor.background];
  final opaqueBg = backgroundHit == null
      ? null
      : Color.alphaBlend(backgroundHit, ImportedThemeSeeds.backdrop);
  final mode = type ?? _text(raw['type']);
  final dark = switch (mode?.toLowerCase()) {
    'vs' || 'light' || 'hc-light' => false,
    'vs-dark' || 'dark' || 'hc' || 'hc-black' => true,
    _ => (opaqueBg?.computeLuminance() ?? 0) < 0.4,
  };
  final bg = opaqueBg ?? ImportedThemeSeeds.background(dark: dark);
  Color take(ImportedThemeColor role, Color fallback) {
    final picked = hits[role];
    return picked == null
        ? fallback
        : _imported(Color.alphaBlend(picked, bg).toARGB32());
  }

  final fg = take(
    ImportedThemeColor.foreground,
    ImportedThemeSeeds.foreground(dark: dark),
  );
  final sidebar = take(
    ImportedThemeColor.sidebar,
    _mix(bg, fg, dark ? .02 : .012),
  );
  final palette = {
    ImportedThemeColor.background: bg,
    ImportedThemeColor.foreground: fg,
    ImportedThemeColor.sidebar: sidebar,
    ImportedThemeColor.accent: _readableAccent(
      take(ImportedThemeColor.accent, _mix(fg, bg, .55)),
      sidebar,
    ),
    ImportedThemeColor.card: take(
      ImportedThemeColor.card,
      _mix(bg, fg, dark ? .04 : .025),
    ),
    ImportedThemeColor.raised: take(
      ImportedThemeColor.raised,
      _mix(bg, fg, dark ? .08 : .05),
    ),
    ImportedThemeColor.border: take(
      ImportedThemeColor.border,
      _mix(bg, fg, dark ? .16 : .14),
    ),
    ImportedThemeColor.input: take(
      ImportedThemeColor.input,
      _mix(bg, fg, dark ? .1 : .06),
    ),
    ImportedThemeColor.mutedForeground: take(
      ImportedThemeColor.mutedForeground,
      _mix(fg, bg, .45),
    ),
    ImportedThemeColor.error: take(
      ImportedThemeColor.error,
      ImportedThemeSeeds.error,
    ),
  };
  final name =
      label ?? _text(raw['name']) ?? _text(fallback) ?? 'VS Code Theme';
  final key =
      identity ??
      [
        'json',
        name,
        dark,
        for (final r in ImportedThemeColor.values) palette[r]!.toARGB32(),
      ];
  final id = 'vsc-${sha256.convert(utf8.encode(jsonEncode(key)))}';
  return ImportedTheme._(
    id,
    name,
    source,
    dark ? Brightness.dark : Brightness.light,
    palette,
  );
}

bool _safePath(String name) =>
    name.isNotEmpty &&
    name.length <= 1024 &&
    !name.contains(RegExp(r'[\\:%?#\x00-\x1f\x7f]')) &&
    !name.split('/').any((part) => part.isEmpty || part == '.' || part == '..');

typedef _ZipPart = ({
  int offset,
  int compressed,
  int size,
  int method,
  int crc,
});

/// Mirrors the local Office reader's central/local preflight. ZipDecoder can
/// eagerly inflate symlinks: never construct an Archive from selected bytes.
final class _Vsix {
  _Vsix(this.bytes) : data = ByteData.sublistView(bytes) {
    _index();
  }
  final Uint8List bytes;
  final ByteData data;
  final parts = <String, _ZipPart>{};
  int u16(int p) => data.getUint16(p, Endian.little);
  int u32(int p) => data.getUint32(p, Endian.little);
  void range(int p, int size, int end) {
    if (p < 0 || size < 0 || p + size > end) {
      throw const FormatException('Invalid ZIP range.');
    }
  }

  void _index() {
    var end = bytes.length - 22;
    final earliest = bytes.length - 65557;
    for (; end >= 0 && end >= earliest; end--) {
      if (u32(end) == 0x06054b50 && end + 22 + u16(end + 20) == bytes.length) {
        break;
      }
    }
    if (end < 0 || end < earliest) {
      throw const FormatException('Missing ZIP directory.');
    }
    final count = u16(end + 10), directory = u32(end + 16);
    if (count == 0 ||
        count > ImportedThemeParser.maxEntries ||
        u16(end + 4) != 0 ||
        u16(end + 6) != 0 ||
        u16(end + 8) != count ||
        directory + u32(end + 12) != end) {
      throw const FormatException('Invalid or oversized ZIP directory.');
    }
    var pos = directory, total = 0;
    final ranges = <({int start, int end})>[];
    for (var i = 0; i < count; i++) {
      range(pos, 46, end);
      if (u32(pos) != 0x02014b50) {
        throw const FormatException('Invalid ZIP entry.');
      }
      final flags = u16(pos + 8), method = u16(pos + 10), crc = u32(pos + 16);
      final compressed = u32(pos + 20),
          size = u32(pos + 24),
          nameLen = u16(pos + 28);
      final extraLen = u16(pos + 30),
          commentLen = u16(pos + 32),
          local = u32(pos + 42);
      final fileType = (u32(pos + 38) >> 16) & 0xf000;
      total += size;
      if (flags & ~0x080e != 0 ||
          (method != 0 && method != 8) ||
          u16(pos + 34) != 0 ||
          !const {0, 0x4000, 0x8000}.contains(fileType) ||
          size > ImportedThemeParser.maxVsixBytes ||
          total > ImportedThemeParser.maxDeclaredBytes ||
          (method == 0 && compressed != size) ||
          nameLen == 0 ||
          nameLen > 1024) {
        throw const FormatException('Unsupported or oversized ZIP entry.');
      }
      range(pos + 46, nameLen + extraLen + commentLen, end);
      _checkExtras(pos + 46 + nameLen, extraLen);
      final nameBytes = Uint8List.sublistView(
        bytes,
        pos + 46,
        pos + 46 + nameLen,
      );
      final name = utf8.decode(nameBytes);
      final dir = name.endsWith('/');
      if (!_safePath(dir ? name.substring(0, name.length - 1) : name) ||
          parts.containsKey(name) ||
          (!dir && (fileType == 0x4000 || u32(pos + 38) & 16 != 0))) {
        throw const FormatException('Unsafe or duplicate ZIP name.');
      }
      range(local, 30, directory);
      if (u32(local) != 0x04034b50 ||
          u16(local + 6) != flags ||
          u16(local + 8) != method ||
          u16(local + 26) != nameLen) {
        throw const FormatException('ZIP local header mismatch.');
      }
      final localExtra = u16(local + 28),
          offset = local + 30 + nameLen + localExtra;
      range(local + 30, nameLen + localExtra + compressed, directory);
      _checkExtras(local + 30 + nameLen, localExtra);
      for (var j = 0; j < nameLen; j++) {
        if (bytes[local + 30 + j] != nameBytes[j]) {
          throw const FormatException('ZIP filename mismatch.');
        }
      }
      var stop = offset + compressed;
      if (flags & 8 != 0) {
        range(stop, 12, directory);
        if (u32(stop) == 0x08074b50) stop += 4;
        range(stop, 12, directory);
        if (u32(stop) != crc ||
            u32(stop + 4) != compressed ||
            u32(stop + 8) != size) {
          throw const FormatException('ZIP descriptor mismatch.');
        }
        stop += 12;
      } else if (u32(local + 14) != crc ||
          u32(local + 18) != compressed ||
          u32(local + 22) != size) {
        throw const FormatException('ZIP local size mismatch.');
      }
      parts[name] = (
        offset: offset,
        compressed: compressed,
        size: size,
        method: method,
        crc: crc,
      );
      ranges.add((start: local, end: stop));
      pos += 46 + nameLen + extraLen + commentLen;
    }
    if (pos != end) throw const FormatException('ZIP count mismatch.');
    ranges.sort((a, b) => a.start.compareTo(b.start));
    for (var i = 1; i < ranges.length; i++) {
      if (ranges[i].start < ranges[i - 1].end) {
        throw const FormatException('Overlapping ZIP entries.');
      }
    }
  }

  void _checkExtras(int pos, int length) {
    final end = pos + length;
    while (pos < end) {
      range(pos, 4, end);
      if (u16(pos) == 1) throw const FormatException('ZIP64 is not supported.');
      final size = u16(pos + 2);
      range(pos + 4, size, end);
      pos += 4 + size;
    }
  }

  _ZipPart part(String name, int limit) {
    final p = parts[name];
    if (p == null || p.size == 0 || p.size > limit) {
      throw const FormatException('Missing or oversized theme document.');
    }
    return p;
  }

  Uint8List read(String name, int limit) {
    final p = part(name, limit);
    final compressed = Uint8List.sublistView(
      bytes,
      p.offset,
      p.offset + p.compressed,
    );
    if (p.method == 0) {
      if (getCrc32(compressed) != p.crc) {
        throw const FormatException('ZIP checksum mismatch.');
      }
      return compressed;
    }
    final sink = _Inflated(p.size);
    final decoder = ZLibDecoder(raw: true).startChunkedConversion(sink);
    // Limit both native input per add and actual output retained, not just
    // declared sizes. Never retry/close after a budget exception from add.
    for (var i = 0; i < compressed.length; i += 1024) {
      decoder.add(
        Uint8List.sublistView(
          compressed,
          i,
          (i + 1024).clamp(0, compressed.length),
        ),
      );
    }
    decoder.close();
    final result = sink.bytes.takeBytes();
    if (result.length != p.size || getCrc32(result) != p.crc) {
      throw const FormatException('Invalid inflated theme document.');
    }
    return result;
  }
}

final class _Inflated implements Sink<List<int>> {
  _Inflated(this.limit);
  final int limit;
  final bytes = BytesBuilder(copy: false);
  @override
  void add(List<int> chunk) {
    if (chunk.length > limit - bytes.length) {
      throw const FormatException('Inflated data exceeds size limit.');
    }
    bytes.add(chunk);
  }

  @override
  void close() {}
}

/// A confirmed, immutable local library. A null selection uses built-in themes.
@immutable
final class ImportedThemeLibrary {
  ImportedThemeLibrary._(Iterable<ImportedTheme> entries, this.selectedId)
    : themes = List.unmodifiable(entries);
  final List<ImportedTheme> themes;
  final String? selectedId;
  ImportedTheme? get selected =>
      themes.where((t) => t.id == selectedId).firstOrNull;
}

/// Device-local, single-key transactions. Saving a variant is idempotent;
/// removing the active variant also clears the selection in the same write.
/// No source bytes, archive paths, script references, or tokenColors are saved.
final class ImportedThemeStore {
  ImportedThemeStore(this._prefs);
  final SharedPreferences _prefs;
  static const preferenceKey = 'imported_vscode_themes_v1';
  static const maxSaved = 48;
  static const _maxRecordChars = 96 * 1024;
  static final _queues = Expando<_StoreQueue>();
  _StoreQueue get _queue => _queues[_prefs] ??= _StoreQueue();

  /// Returns no imports for corrupt/unknown data, without rewriting it. Reads
  /// during a save expose the previous confirmed selection, not plugin optimism.
  ImportedThemeLibrary read() {
    if (_queue.confirmed case final confirmed?) return confirmed;
    try {
      return _decodeLibrary(_prefs.get(preferenceKey));
    } on FormatException {
      return ImportedThemeLibrary._([], null);
    }
  }

  /// Save only the user-chosen variant. A matching VSIX publisher/name/path
  /// updates in place; standalone IDs hash the normalised label and palette.
  Future<void> save(ImportedTheme theme, {bool select = true}) =>
      _change((old) {
        final items = {for (final t in old.themes) t.id: t, theme.id: theme};
        if (items.length > maxSaved) throw StateError('Theme library is full.');
        return ImportedThemeLibrary._(
          items.values,
          select ? theme.id : old.selectedId,
        );
      });

  /// Select an existing variant or pass null to return to built-in themes.
  Future<void> select(String? id) => _change((old) {
    if (id != null && !old.themes.any((t) => t.id == id)) {
      throw StateError('Unknown imported theme.');
    }
    return ImportedThemeLibrary._(old.themes, id);
  });

  /// Idempotent. Removing an unselected import preserves the active one.
  Future<void> remove(String id) => _change(
    (old) => ImportedThemeLibrary._(
      old.themes.where((t) => t.id != id),
      old.selectedId == id ? null : old.selectedId,
    ),
  );

  Future<void> _change(
    ImportedThemeLibrary Function(ImportedThemeLibrary) change,
  ) => _queue.enqueue(() async {
    final previous = _prefs.get(preferenceKey);
    final old = _decodeLibrary(
      previous,
    ); // Don't overwrite corrupt/future data.
    final next = change(old);
    final encoded = next.themes.isEmpty
        ? null
        : jsonEncode({
            'version': 1,
            'selected': next.selectedId,
            'themes': [for (final t in next.themes) t._record()],
          });
    if (previous == encoded) return;
    _queue.confirmed = old;
    try {
      if (!await _set(encoded)) {
        throw StateError('Could not save imported theme.');
      }
    } catch (_) {
      // Legacy SharedPreferences mutates the cached value before platform I/O.
      try {
        await _set(previous as String?);
      } catch (_) {
        /* Preserve original failure. */
      }
      rethrow;
    } finally {
      _queue.confirmed = null;
    }
  });

  Future<bool> _set(String? value) => value == null
      ? _prefs.remove(preferenceKey)
      : _prefs.setString(preferenceKey, value);

  static ImportedThemeLibrary _decodeLibrary(Object? record) {
    if (record == null) return ImportedThemeLibrary._([], null);
    const invalid = FormatException('Invalid saved theme library.');
    if (record is! String || record.length > _maxRecordChars) throw invalid;
    final obj = _decodeObject(record);
    final list = obj['themes'];
    if (obj['version'] != 1 || list is! List || list.length > maxSaved) {
      throw invalid;
    }
    final ids = <String>{}, items = <ImportedTheme>[];
    for (final entry in list) {
      if (entry is! Map) throw invalid;
      final id = entry['id'],
          source = _text(entry['source']),
          label = _text(entry['label']);
      final colors = entry['colors'];
      if (id is! String ||
          !RegExp(r'^vsc-[0-9a-f]{64}$').hasMatch(id) ||
          !ids.add(id) ||
          source == null ||
          label == null ||
          colors is! Map) {
        throw invalid;
      }
      final brightness = switch (entry['brightness']) {
        'dark' => Brightness.dark,
        'light' => Brightness.light,
        _ => throw invalid,
      };
      final palette = <ImportedThemeColor, Color>{};
      for (final r in ImportedThemeColor.values) {
        final n = colors[r.name];
        if (n is! int || n < 0xff000000 || n > 0xffffffff) throw invalid;
        palette[r] = _imported(n);
      }
      items.add(ImportedTheme._(id, label, source, brightness, palette));
    }
    final selected = obj['selected'];
    if (selected != null && (selected is! String || !ids.contains(selected))) {
      throw invalid;
    }
    return ImportedThemeLibrary._(items, selected as String?);
  }
}

final class _StoreQueue {
  Future<void>? _tail;
  ImportedThemeLibrary? confirmed;
  Future<void> enqueue(Future<void> Function() operation) {
    final result = (_tail ?? Future<void>.value()).then((_) => operation());
    final settled = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    _tail = settled;
    settled.then((_) {
      if (identical(_tail, settled)) _tail = null;
    });
    return result;
  }
}
