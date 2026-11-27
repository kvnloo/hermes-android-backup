// The libwebrtc archive flutter_webrtc downloads for Windows and Linux builds
// is pinned by URL and SHA-256 and checked at configure time (voice review of
// 46683e29, card B item 10). The CMake checks run through `cmake -P` when
// CMake is installed.
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

const _pin = 'third_party/webrtc/libwebrtc_pin.cmake';

const _hashes = {
  'win_x64': '0cf141cd803af8f860080d94861d2d591ab9081a28f5cdead1b7c775ad5d3bf8',
  'win_arm64':
      '2546c8cc20a4326d6b40e06a250a642733e80e03a1ba36a0b115a491d65d3f85',
  'linux_x64':
      'ef380526cf9616848bc0b97b24990cbf2ad851c209d5dce93cc3ebb9d3789fbc',
  'linux_arm64':
      '887de0a1da6c9b8807da9fe2fc237e03ac5fcc3df4142a5f8889d66baa24bf08',
};

String _read(String path) => File(path).readAsStringSync();

/// CMake's output with its line wrapping undone.
String _flat(ProcessResult result) =>
    '${result.stdout}${result.stderr}'.replaceAll(RegExp(r'\s+'), ' ');

Directory? _package(String package) {
  final config =
      jsonDecode(_read('.dart_tool/package_config.json'))
          as Map<String, dynamic>;
  for (final entry in config['packages'] as List) {
    final map = entry as Map<String, dynamic>;
    if (map['name'] != package) continue;
    final root = Uri.parse(map['rootUri'] as String);
    return Directory.fromUri(
      root.isAbsolute
          ? root
          : Uri.directory(Directory.current.path).resolveUri(root),
    );
  }
  return null;
}

String? _cmake() {
  for (final candidate in [
    'cmake',
    '/opt/homebrew/bin/cmake',
    '/usr/bin/cmake',
  ]) {
    try {
      final result = Process.runSync(candidate, ['--version']);
      if (result.exitCode == 0) return candidate;
    } on ProcessException {
      continue;
    }
  }
  return null;
}

void main() {
  test('the pin names flutter_webrtc\'s release and every archive hash', () {
    final pin = _read(_pin);
    expect(
      pin,
      contains('set(ARES_LIBWEBRTC_VERSION "libwebrtc.m150.7871.07")'),
    );
    expect(
      pin,
      contains('"https://github.com/webrtc-sdk/libwebrtc/releases/download")'),
    );
    for (final MapEntry(key: target, value: hash) in _hashes.entries) {
      expect(
        pin,
        contains('set(ARES_LIBWEBRTC_SHA256_$target\n    "$hash")'),
        reason: target,
      );
      for (final doc in [
        'third_party/webrtc/NOTICE.md',
        'docs/libwebrtc-desktop-download.md',
      ]) {
        expect(_read(doc), contains(hash), reason: '$doc $target');
      }
    }
  });

  test('the pin is what the resolved flutter_webrtc downloads', () {
    final package = _package('flutter_webrtc');
    if (package == null) {
      markTestSkipped('flutter_webrtc is not resolved here');
      return;
    }
    final ini = File.fromUri(
      package.uri.resolve('third_party/libwebrtc_version.ini'),
    ).readAsStringSync();
    expect(ini, contains('binary_version = libwebrtc.m150.7871.07'));
    expect(
      ini,
      contains(
        'download_url   = https://github.com/webrtc-sdk/libwebrtc/releases/download',
      ),
    );
    // Its CMake still downloads with no hash and skips an archive that is
    // already there: the reason the app pins it first.
    final cmake = File.fromUri(
      package.uri.resolve('third_party/CMakeLists.txt'),
    ).readAsStringSync();
    expect(
      cmake,
      contains(
        'set(ZIPFILE "\${LIBWEBRTC_THIRD_PARTY_DIR}/downloads/\${LIBWEBRTC_ASSET}.zip")',
      ),
    );
    expect(cmake, contains('if(NOT EXISTS "\${ZIPFILE}")'));
  });

  test('Windows and Linux builds pin libwebrtc before adding the plugins', () {
    for (final path in ['windows/CMakeLists.txt', 'linux/CMakeLists.txt']) {
      final text = _read(path);
      final include = text.indexOf(
        'include("\${CMAKE_CURRENT_SOURCE_DIR}/../third_party/webrtc/libwebrtc_pin.cmake")',
      );
      final call = text.indexOf('ares_pin_libwebrtc_for_app()');
      final plugins = text.indexOf('include(flutter/generated_plugins.cmake)');
      expect(include, greaterThan(0), reason: path);
      expect(call, greaterThan(include), reason: path);
      expect(plugins, greaterThan(call), reason: path);
    }
  });

  group('configure-time check', () {
    final cmake = _cmake();
    late Directory root;
    late Directory plugin;
    late Directory release;
    late List<int> archive;
    late String archiveHash;

    setUp(() {
      root = Directory.systemTemp.createTempSync('libwebrtc_pin_test');
      plugin = Directory('${root.path}/flutter_webrtc')..createSync();
      Directory('${plugin.path}/third_party').createSync();
      File(
        '${plugin.path}/third_party/libwebrtc_version.ini',
      ).writeAsStringSync(
        '[libwebrtc]\n'
        'binary_version = libwebrtc.m150.7871.07\n'
        'download_url   = https://github.com/webrtc-sdk/libwebrtc/releases/download\n',
      );
      release = Directory('${root.path}/release/libwebrtc.m150.7871.07')
        ..createSync(recursive: true);
      archive = utf8.encode('stand-in libwebrtc archive');
      archiveHash = sha256.convert(archive).toString();
      File(
        '${release.path}/libwebrtc-linux-x64-release.zip',
      ).writeAsBytesSync(archive);
    });

    tearDown(() => root.deleteSync(recursive: true));

    ProcessResult run({String? hash, String? version}) {
      if (version != null) {
        File(
          '${plugin.path}/third_party/libwebrtc_version.ini',
        ).writeAsStringSync(
          '[libwebrtc]\nbinary_version = $version\n'
          'download_url = https://github.com/webrtc-sdk/libwebrtc/releases/download\n',
        );
      }
      final script = File('${root.path}/run.cmake')
        ..writeAsStringSync(
          'include("${File(_pin).absolute.path}")\n'
          'ares_pin_libwebrtc(PLUGIN_DIR "${plugin.path}" OS linux ARCH x64 '
          'URL_BASE "${Uri.directory('${root.path}/release')}" '
          'SHA256 ${hash ?? archiveHash})\n',
        );
      return Process.runSync(cmake!, ['-P', script.path]);
    }

    File zip() => File(
      '${plugin.path}/third_party/downloads/libwebrtc-linux-x64-release.zip',
    );

    test('downloads the archive where flutter_webrtc looks, checked', () {
      if (cmake == null) return markTestSkipped('CMake is not installed');
      final result = run();
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
      expect(zip().readAsBytesSync(), archive);
      expect(File('${zip().path}.part').existsSync(), isFalse);
    });

    test('replaces an archive already there with another hash, and what was '
        'extracted from it', () {
      if (cmake == null) return markTestSkipped('CMake is not installed');
      zip().parent.createSync(recursive: true);
      zip().writeAsStringSync('tampered');
      final extracted = Directory('${plugin.path}/third_party/libwebrtc')
        ..createSync();
      final result = run();
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
      expect(_flat(result), contains('not the pinned'));
      expect(zip().readAsBytesSync(), archive);
      expect(extracted.existsSync(), isFalse);
    });

    test('keeps a matching archive and its extraction', () {
      if (cmake == null) return markTestSkipped('CMake is not installed');
      zip().parent.createSync(recursive: true);
      zip().writeAsBytesSync(archive);
      final extracted = Directory('${plugin.path}/third_party/libwebrtc')
        ..createSync();
      final result = run();
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
      expect(extracted.existsSync(), isTrue);
    });

    test('stops the configure when the download does not match', () {
      if (cmake == null) return markTestSkipped('CMake is not installed');
      final result = run(hash: '0' * 64);
      expect(result.exitCode, isNot(0));
      expect(_flat(result), contains('not the pinned'));
      expect(zip().existsSync(), isFalse);
      expect(File('${zip().path}.part').existsSync(), isFalse);
    });

    test(
      'stops the configure when flutter_webrtc asks for another release',
      () {
        if (cmake == null) return markTestSkipped('CMake is not installed');
        final result = run(version: 'libwebrtc.m151.0000.01');
        expect(result.exitCode, isNot(0));
        expect(_flat(result), contains('now downloads'));
        expect(zip().existsSync(), isFalse);
      },
    );
  });
}
