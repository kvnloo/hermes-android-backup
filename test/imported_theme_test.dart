import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/presentation/imported_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

const jsonTheme = '{"name":"Dusk","colors":{"editor.background":"#123"}}';
const manifestPath = 'extension/package.json';
const themePath = 'themes/dusk.json';
const normal = {'label': 'Dusk', 'uiTheme': 'vs-dark', 'path': './$themePath'};

Uint8List _bytes(String text) => utf8.encode(text);
ImportedTheme _theme(String text) =>
    ImportedThemeParser.parse('picked.jsonc', _bytes(text)).single;
String _manifest(Object? variants, {String version = '1'}) => jsonEncode({
  'publisher': 'demo',
  'name': 'pack',
  'version': version,
  'main': './main.js',
  'contributes': {
    'themes': variants,
    'commands': [
      {'command': 'ignored'},
    ],
  },
});
Uint8List _zip(Map<String, String> files, {bool stored = false}) {
  final archive = Archive();
  for (final e in files.entries) {
    final file = ArchiveFile.string(e.key, e.value);
    if (stored) file.compression = CompressionType.none;
    archive.add(file);
  }
  return ZipEncoder().encodeBytes(archive);
}

Uint8List _vsix({
  Object? themes = const [normal],
  String data = jsonTheme,
  Map<String, String> extra = const {},
  bool stored = false,
}) => _zip({
  manifestPath: _manifest(themes),
  'extension/$themePath': data,
  ...extra,
}, stored: stored);
List<ImportedTheme> _parseVsix(Uint8List bytes) =>
    ImportedThemeParser.parse('pack.VSIX', bytes);

// Locate entries in fixtures emitted by the installed ZIP encoder; no production
// decoder or mocked stream is used to manufacture a passing security check.
({int central, int local, int content}) _entry(Uint8List bytes, String name) {
  final data = ByteData.sublistView(bytes), end = bytes.length - 22;
  int u16(int p) => data.getUint16(p, Endian.little);
  int u32(int p) => data.getUint32(p, Endian.little);
  var c = u32(end + 16);
  for (var i = 0; i < u16(end + 10); i++) {
    final length = u16(c + 28);
    if (utf8.decode(bytes.sublist(c + 46, c + 46 + length)) == name) {
      final local = u32(c + 42);
      return (
        central: c,
        local: local,
        content: local + 30 + length + u16(local + 28),
      );
    }
    c += 46 + length + u16(c + 30) + u16(c + 32);
  }
  throw StateError('Missing fixture part');
}

void _size(Uint8List zip, String name, int size) {
  final entry = _entry(zip, name), data = ByteData.sublistView(zip);
  data.setUint32(entry.local + 22, size, Endian.little);
  data.setUint32(entry.central + 24, size, Endian.little);
}

Matcher _message(String message) => throwsA(
  isA<FormatException>().having((e) => e.message, 'message', contains(message)),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('local workbench JSON', () {
    test(
      'maps real roles, preserves comment-like string text and strips JSONC syntax',
      () {
        final t = _theme(r'''{
        // Include, token colours, scripts and URLs are inert data.
        "name": "https://example.test/\"/* blue */,]", "type":"dark",
        "include":"../../outside.json", "tokenColors": [{"settings":{"foreground":"#fff"}},],
        "colors": {
          "editor.background":"#000", "editor.foreground":"#def",
          "button.background":"#acf", "focusBorder":"#bb0000",
          "editorWidget.background":"#456", "sideBarSectionHeader.background":"#567",
          "sideBar.background":"#111", "panel.border":"#678", "input.background":"#789",
          "descriptionForeground":"#89a", "editorError.foreground":"#e43",
          "unknown.key":"#a51", /* trailing comma */
        },
      }''');
        expect(t.label, 'https://example.test/"/* blue */,]');
        expect(t.source, 'Local JSON');
        expect(t.brightness, Brightness.dark);
        expect(t.colors.map((r, c) => MapEntry(r.name, c.toARGB32())), {
          'background': 0xff000000,
          'foreground': 0xffddeeff,
          'accent': 0xffaaccff,
          'raised': 0xff445566,
          'card': 0xff556677,
          'sidebar': 0xff111111,
          'border': 0xff667788,
          'input': 0xff778899,
          'mutedForeground': 0xff8899aa,
          'error': 0xffee4433,
        });
        expect(() => t.colors.clear(), throwsUnsupportedError);
      },
    );

    test(
      'flattens CSS-style RGBA; ignores invalid values and infers light mode',
      () {
        final t = _theme(
          '{"colors":{"editor.background":"#ffffff", "editor.foreground":"var(--bad)", "foreground":"#0008", "panel.border":"#00000080"}}',
        );
        expect(t.brightness, Brightness.light);
        expect(t[ImportedThemeColor.foreground].toARGB32(), 0xff777777);
        expect(t[ImportedThemeColor.border].toARGB32(), 0xff7f7f7f);
        expect(t.label, 'picked');
        expect(t.colors.keys, unorderedEquals(ImportedThemeColor.values));
      },
    );

    test('dim brand colours remain legible against their actual sidebar', () {
      for (final color in ['#333', '#aaa']) {
        final t = _theme(
          jsonEncode({
            'colors': {'sideBar.background': color, 'button.background': color},
          }),
        );
        final fg = t[ImportedThemeColor.accent].computeLuminance() + .05;
        final bg = t[ImportedThemeColor.sidebar].computeLuminance() + .05;
        expect(fg > bg ? fg / bg : bg / fg, greaterThanOrEqualTo(4.5));
      }
    });

    test(
      'ids ignore formatting and syntax colours but distinguish same-name palettes',
      () {
        final t = _theme(jsonTheme);
        expect(
          _theme(
            '{"tokenColors": [],"colors":{"editor.background":"#112233"},"name":"Dusk"}',
          ).id,
          t.id,
        );
        expect(_theme(jsonTheme.replaceFirst('#123', '#234')).id, isNot(t.id));
      },
    );

    test(
      'rejects syntax errors, root type, empty palette, invalid UTF-8 and complexity',
      () {
        for (final s in [
          '[]',
          'null',
          '{,}',
          '{"colors":[],}',
          '{"colors":{"foreground":"#12345"}}',
          '{"colors":{"foreground":"red"}}',
          '{"tokenColors":[{"foreground":"#fff"}]}',
          '{"colors":{"foreground":"#000"},"x":[,]}',
          '$jsonTheme /*',
          '{"colors":{"foreground":"#000"},"x":${'[' * 65}1${']' * 65}}',
          '{"colors":{"foreground":"#000"},"x":[${'0,' * 66000}1]}',
        ]) {
          expect(() => _theme(s), throwsFormatException);
        }
        expect(
          () => ImportedThemeParser.parse('t.json', Uint8List.fromList([0xfe])),
          throwsFormatException,
        );
        expect(_theme('\ufeff$jsonTheme').label, 'Dusk');
      },
    );

    test(
      'caps and rejects unsupported or non-basename picker names before decode',
      () {
        for (final name in [
          't.zip',
          't.vsix.exe',
          'https://host/t.json',
          r'C:\t.json',
          '../t.json',
        ]) {
          expect(
            () => ImportedThemeParser.parse(name, _bytes(jsonTheme)),
            throwsFormatException,
          );
        }
        for (final (name, cap) in [
          ('t.vsix', ImportedThemeParser.maxVsixBytes),
          ('t.JSONC', ImportedThemeParser.maxJsonBytes),
        ]) {
          expect(
            () => ImportedThemeParser.parse(name, Uint8List(cap + 1)),
            _message('too large'),
          );
        }
      },
    );
  });

  group('bounded picker stream', () {
    test(
      'invalid size rejected before first listen; overrun cancels stream before next chunk',
      () async {
        var starts = 0, completed = false;
        Stream<List<int>> chunks() async* {
          starts++;
          yield [1, 2];
          yield [3, 4];
          completed = true;
        }

        await expectLater(
          ImportedThemeParser.parseStream(
            't.json',
            chunks(),
            declaredSize: ImportedThemeParser.maxJsonBytes + 1,
          ),
          throwsFormatException,
        );
        expect(starts, 0);
        await expectLater(
          ImportedThemeParser.parseStream('t.json', chunks(), declaredSize: 3),
          throwsFormatException,
        );
        expect(completed, false);
        await expectLater(
          ImportedThemeParser.parseStream('t.json', chunks(), declaredSize: 5),
          _message('Incomplete'),
        );
        await expectLater(
          ImportedThemeParser.parseStream(
            't.json',
            Stream.value(Uint8List(ImportedThemeParser.maxJsonBytes + 1)),
          ),
          throwsFormatException,
        );
      },
    );

    test(
      'passes split picker bytes to an isolate and returns usable typed variants',
      () async {
        final b = _vsix();
        final variants = await ImportedThemeParser.parseStream(
          't.vsix',
          Stream.fromIterable([b.sublist(0, 4), b.sublist(4)]),
          declaredSize: b.length,
        );
        expect(variants.single.id, _parseVsix(b).single.id);
        expect(
          variants.single[ImportedThemeColor.background].toARGB32(),
          0xff112233,
        );
      },
    );
  });

  group('VSIX contribution boundary', () {
    for (final stored in [true, false]) {
      test(
        'only contributed JSON is read and manifest order/mode win (stored=$stored)',
        () {
          final b = _vsix(
            stored: stored,
            themes: [
              {'path': 'light.jsonc', 'label': 'Light', 'uiTheme': 'hc-light'},
              normal,
            ],
            extra: {
              'extension/light.jsonc':
                  '{"type":"dark","colors":{"foreground":"#222",},}',
              'extension/main.js': 'not valid JSON',
              'extension/unlisted.json': 'not valid JSON',
              'extension/hidden/package.json': _manifest([
                {'path': 'poison.js'},
              ]),
            },
          );
          // CRC-corrupt an unrelated member: parsing should not even inflate it.
          b[_entry(b, 'extension/main.js').content] ^= 0xff;
          final variants = _parseVsix(b);
          expect(variants.map((v) => v.label), ['Light', 'Dusk']);
          expect(variants.map((v) => v.brightness), [
            Brightness.light,
            Brightness.dark,
          ]);
          expect(variants.map((v) => v.source).toSet(), {'demo.pack'});
          expect(variants.map((v) => v.id).toSet(), hasLength(2));
          expect(() => variants.clear(), throwsUnsupportedError);
        },
      );
    }
    test(
      'VSIX ID survives archive rename, version, label and palette updates',
      () {
        final id = _parseVsix(_vsix()).single.id;
        final update = _zip({
          manifestPath: _manifest([
            {...normal, 'label': 'Renamed'},
          ], version: '2'),
          'extension/$themePath': jsonTheme.replaceFirst('#123', '#987'),
        });
        expect(ImportedThemeParser.parse('new.vsix', update).single.id, id);
      },
    );

    test('manifest required; no scanning for JSON or recursive includes', () {
      for (final files in [
        {'extension/$themePath': jsonTheme},
        {
          'package.json': _manifest([normal]),
          'extension/$themePath': jsonTheme,
        },
        {manifestPath: '{}', 'extension/$themePath': jsonTheme},
        {
          manifestPath: _manifest([normal]),
          'elsewhere/$themePath': jsonTheme,
        },
        {
          manifestPath: _manifest([normal]),
          'extension/$themePath': '{"include":"../other.json"}',
          'extension/other.json': jsonTheme,
        },
      ]) {
        expect(() => _parseVsix(_zip(files)), throwsFormatException);
      }
    });

    test(
      'rejects every unsafe or non-JSON contribution and duplicate canonical paths',
      () {
        for (final path in [
          '../../other.json',
          'themes/../ok.json',
          '/etc/t.json',
          r'themes\t.json',
          'file:///t.json',
          'https://host/t.json',
          'C:/t.json',
          'themes//t.json',
          '%2e%2e/t.json',
          't.js',
          't.json?x',
          'package.json',
        ]) {
          expect(
            () => _parseVsix(
              _vsix(
                themes: [
                  normal,
                  {'path': path},
                ],
              ),
            ),
            _message('path'),
            reason: path,
          );
        }
        expect(
          () => _parseVsix(
            _vsix(
              themes: [
                normal,
                {'path': themePath},
              ],
            ),
          ),
          _message('duplicate'),
        );
        expect(
          () => _parseVsix(
            _vsix(
              themes: List.filled(ImportedThemeParser.maxVariants + 1, normal),
            ),
          ),
          _message('bounded list'),
        );
      },
    );

    test(
      'rejects traversal, duplicate names and symlinks even in unused entries',
      () {
        final name = 'ab/unused', alt = 'cd/unused';
        for (final change in [
          'traversal',
          'duplicate',
          'symlink',
          'mismatch',
        ]) {
          final b = _vsix(extra: {name: 'x', alt: 'y'}), e = _entry(b, name);
          if (change == 'symlink') {
            ByteData.sublistView(
              b,
            ).setUint32(e.central + 38, 0xa1ff0000, Endian.little);
          } else if (change == 'mismatch') {
            b[e.local + 30] ^= 1;
          } else {
            final replacement = _bytes(
              change == 'duplicate' ? alt : '../unused',
            );
            b.setRange(
              e.central + 46,
              e.central + 46 + replacement.length,
              replacement,
            );
            b.setRange(
              e.local + 30,
              e.local + 30 + replacement.length,
              replacement,
            );
          }
          expect(() => _parseVsix(b), throwsFormatException, reason: change);
        }
      },
    );

    test(
      'checks central count, ranges, encryption and selected CRC before JSON',
      () {
        for (final change in [
          'count',
          'range',
          'encrypted',
          'checksum',
          'deflate',
        ]) {
          final b = _vsix(stored: change != 'deflate'),
              d = ByteData.sublistView(b),
              e = _entry(b, 'extension/$themePath');
          switch (change) {
            case 'count':
              d.setUint16(b.length - 12, 0xffff, Endian.little);
            case 'range':
              d.setUint32(e.central + 42, 0xffffff, Endian.little);
            case 'encrypted':
              d.setUint16(e.central + 8, 1, Endian.little);
            case 'checksum':
              b[e.content] ^= 1;
            case 'deflate':
              b[e.content] = 0xff;
          }
          expect(() => _parseVsix(b), throwsFormatException, reason: change);
        }
        expect(() => _parseVsix(_bytes('PK')), throwsFormatException);
      },
    );

    test(
      'rejects oversized manifests and theme entries before inflation; actual output is capped too',
      () {
        final manifest = _vsix();
        _size(manifest, manifestPath, ImportedThemeParser.maxManifestBytes + 1);
        expect(
          () => _parseVsix(manifest),
          _message('oversized theme document'),
        );
        final selected = _vsix();
        _size(
          selected,
          'extension/$themePath',
          ImportedThemeParser.maxJsonBytes + 1,
        );
        expect(
          () => _parseVsix(selected),
          _message('oversized theme document'),
        );
        final dishonest = _vsix(data: '$jsonTheme${' ' * 32000}');
        _size(dishonest, 'extension/$themePath', 32);
        expect(
          () => _parseVsix(dishonest),
          _message('Inflated data exceeds size limit'),
        );
      },
    );

    test('preflights aggregate budgets before parsing any selected theme', () {
      final names = [for (var i = 0; i < 9; i++) 'themes/$i.json'];
      final selected = _vsix(
        themes: [
          for (final n in names) {'path': n},
        ],
        extra: {for (final n in names) 'extension/$n': 'not json'},
      );
      for (final n in names) {
        _size(selected, 'extension/$n', ImportedThemeParser.maxJsonBytes);
      }
      expect(() => _parseVsix(selected), _message('Contributed themes exceed'));
      final declared = _vsix(extra: {for (final n in names) n: 'unused'});
      for (final n in names) {
        _size(declared, n, ImportedThemeParser.maxVsixBytes);
      }
      expect(() => _parseVsix(declared), _message('oversized ZIP entry'));
    });
  });

  group('confirmed local library', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));
    test(
      'saves just the selected projection; reload, replace, select and remove are stable',
      () async {
        final prefs = await SharedPreferences.getInstance(),
            store = ImportedThemeStore(prefs);
        final night = _parseVsix(_vsix()).single, day = _theme(jsonTheme);
        await store.save(night);
        await store.save(day, select: false);
        await store.save(
          _parseVsix(
            _vsix(data: jsonTheme.replaceFirst('#123', '#fed')),
          ).single,
        );
        await prefs.reload();
        final reopened = ImportedThemeStore(prefs).read();
        expect(reopened.themes.map((t) => t.id), [night.id, day.id]);
        expect(
          reopened.selected![ImportedThemeColor.background].toARGB32(),
          0xffffeedd,
        );
        final raw = prefs.getString(ImportedThemeStore.preferenceKey)!;
        for (final forbidden in [
          'package.json',
          themePath,
          'main.js',
          'contributes',
          'editor.background',
        ]) {
          expect(raw, isNot(contains(forbidden)));
        }
        await expectLater(store.select('missing'), throwsStateError);
        expect(store.read().selectedId, night.id);
        await store.select(day.id);
        await store.remove(night.id);
        expect(store.read().selectedId, day.id);
        await store.select(null);
        expect(store.read().selected, isNull);
        expect(store.read().themes.single.id, day.id);
        await store.select(day.id);
        await store.remove(day.id);
        await store.remove(day.id);
        await prefs.reload();
        expect(store.read().selectedId, isNull);
        expect(store.read().themes, isEmpty);
        expect(prefs.containsKey(ImportedThemeStore.preferenceKey), false);
      },
    );

    test(
      'corrupt, oversized and future preference payloads never render or get overwritten',
      () async {
        final prefs = await SharedPreferences.getInstance(),
            store = ImportedThemeStore(prefs),
            t = _theme(jsonTheme);
        await store.save(t);
        final valid = prefs.getString(ImportedThemeStore.preferenceKey)!;
        for (final bad in [
          '?',
          valid.replaceFirst('"version":1', '"version":2'),
          valid.replaceFirst(t.id, 'unknown'),
          valid.replaceFirst('"dark"', '"unknown"'),
          valid.replaceFirst(
            t[ImportedThemeColor.foreground].toARGB32().toString(),
            '-1',
          ),
          'x' * 100000,
        ]) {
          await prefs.setString(ImportedThemeStore.preferenceKey, bad);
          expect(store.read().themes, isEmpty);
          await expectLater(store.save(t), throwsFormatException);
          expect(prefs.getString(ImportedThemeStore.preferenceKey), bad);
        }
      },
    );

    test(
      'held failed save is not observable and cannot undo a queued newer save',
      () async {
        final prefs = _HeldPrefs(),
            first = ImportedThemeStore(prefs),
            other = ImportedThemeStore(prefs);
        final t = _theme(jsonTheme),
            newer = _theme(jsonTheme.replaceFirst('#123', '#457'));
        final rejected = expectLater(first.save(t), throwsStateError);
        await prefs.started.future;
        expect(prefs.cache, isNotNull);
        expect(other.read().themes, isEmpty);
        final success = other.save(newer);
        prefs.gate.complete(false);
        await rejected;
        await success;
        expect(first.read().themes.map((e) => e.id), [newer.id]);
        expect(first.read().selectedId, newer.id);
        expect(prefs.cache, prefs.durable);
      },
    );
  });
}

class _HeldPrefs extends Fake implements SharedPreferences {
  final gate = Completer<bool>(), started = Completer<void>();
  String? cache, durable;
  @override
  String? get(String key) => cache;
  @override
  Future<bool> setString(String key, String value) async {
    cache = value;
    if (!started.isCompleted) {
      started.complete();
      if (!await gate.future) return false;
    }
    durable = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    cache = null;
    durable = null;
    return true;
  }
}
