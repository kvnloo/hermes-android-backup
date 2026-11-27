// The native WebRTC stack that GPT-Live voice brings in is noticed as what
// it is (voice review of 46683e29, card B item 9): not "MIT only", with the
// WebRTC, bundled-component, audioswitch and flutter_webrtc NOTICE texts in
// the app's licence page. settings_licenses_test opens those entries.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _read(String path) => File(path).readAsStringSync();

/// The pub-cache directory of [package], from the resolved package config.
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

void main() {
  test('NOTICE.md no longer calls the WebRTC stack MIT only', () {
    final notice = _read('NOTICE.md');
    expect(notice, isNot(contains('distributed under the MIT Licence')));
    for (final term in [
      'io.github.webrtc-sdk:android',
      '150.7871.04',
      'WebRTC.xcframework',
      'com.github.davidliu:audioswitch',
      'libwebrtc.m150.7871.07',
      'BSD-3-Clause',
      'Apache-2.0',
      'LGPL-2.1-or-later',
      'BoringSSL',
      'libvpx',
      'Opus',
      'third_party/webrtc/NOTICE.md',
    ]) {
      expect(notice, contains(term), reason: term);
    }
  });

  test('the WebRTC notice names every shipped artefact and component', () {
    final notice = _read('third_party/webrtc/NOTICE.md');
    for (final term in [
      // Android AAR, as in the review's licence inventory.
      '1872dda4e3bf7d6ea6f7c6e11861332081c57081a1e62fc82fab72415c69c84c',
      '039a35aefab7747c557242fa216c9ea11743b604',
      // Apple xcframework release asset.
      '9532fe3ce47507c304f37a4355b907be1e89967971d614a04603005a546249be',
      // Windows and Linux libwebrtc archives.
      '0cf141cd803af8f860080d94861d2d591ab9081a28f5cdead1b7c775ad5d3bf8',
      '2546c8cc20a4326d6b40e06a250a642733e80e03a1ba36a0b115a491d65d3f85',
      'ef380526cf9616848bc0b97b24990cbf2ad851c209d5dce93cc3ebb9d3789fbc',
      '887de0a1da6c9b8807da9fe2fc237e03ac5fcc3df4142a5f8889d66baa24bf08',
      for (final component in [
        'BoringSSL',
        'libvpx',
        'Opus',
        'libyuv',
        'libsrtp',
        'dav1d',
        'libaom',
        'Abseil',
        'OpenH264',
        'libjpeg-turbo',
        'FFmpeg',
        'Shiguredo',
      ])
        component,
    ]) {
      expect(notice, contains(term), reason: term);
    }
    final texts = _read('third_party/licenses/webrtc-third-party-licenses.txt');
    for (final heading in [
      'BoringSSL',
      'libvpx (VP8/VP9)',
      'Opus',
      'libyuv',
      'libsrtp',
      'dav1d (AV1 decoder)',
      'libaom (AV1)',
      'Abseil',
      'OpenH264 (Windows and Linux libwebrtc)',
      'FFmpeg (Windows and Linux libwebrtc)',
    ]) {
      expect(texts, contains('\n$heading\nSource: '), reason: heading);
    }
    expect(texts, contains('GNU LESSER GENERAL PUBLIC LICENSE'));
    expect(
      _read('third_party/licenses/webrtc-BSD-3-Clause.txt'),
      startsWith(
        'Copyright (c) 2011, The WebRTC project authors. All rights reserved.',
      ),
    );
    expect(
      _read('third_party/licenses/webrtc-PATENTS.txt'),
      startsWith('Additional IP Rights Grant (Patents)'),
    );
    expect(
      _read('third_party/licenses/audioswitch-Apache-2.0.txt'),
      contains('Copyright 2020 Twilio, inc.'),
    );
  });

  test('the flutter_webrtc NOTICE is the resolved package\'s own', () {
    final package = _package('flutter_webrtc');
    if (package == null) {
      markTestSkipped('flutter_webrtc is not resolved here');
      return;
    }
    expect(package.path, contains('flutter_webrtc-1.6.3'));
    expect(
      _read('third_party/licenses/flutter_webrtc-NOTICE.txt'),
      File.fromUri(package.uri.resolve('NOTICE')).readAsStringSync(),
    );
  });

  test('every licence-page asset is bundled', () {
    final registry = _read('lib/core/services/app_licenses.dart');
    final pubspec = _read('pubspec.yaml');
    final assets = RegExp(
      r"'((?:LICENSE|assets|third_party)[^']*)'",
    ).allMatches(registry).map((m) => m[1]!).toList();
    expect(assets, contains('third_party/webrtc/NOTICE.md'));
    for (final asset in assets) {
      expect(File(asset).existsSync(), isTrue, reason: asset);
      expect(pubspec, contains('    - $asset\n'), reason: asset);
    }
  });
}
