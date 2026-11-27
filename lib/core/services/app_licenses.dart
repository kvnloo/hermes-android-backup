import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

bool _registered = false;

/// One licence-page entry for the native WebRTC libraries on every platform.
const _webrtc =
    'WebRTC (webrtc-sdk 150.7871.04 Android, iOS, macOS; '
    'libwebrtc m150.7871.07 Windows, Linux)';

/// Adds local application and third-party notices without reading assets yet.
void registerAppLicenses({AssetBundle? assetBundle}) {
  if (_registered) return;
  _registered = true;

  LicenseRegistry.addLicense(() async* {
    final bundle = assetBundle ?? rootBundle;
    const notices = <String, String>{
      'LICENSE': 'Ares app (formerly Hermes Android)',
      'assets/fonts/OFL.txt': 'Cinzel',
      'assets/fonts/geist/OFL.txt': 'Geist and Geist Mono',
      'third_party/licenses/kyllene-MIT.txt':
          'Kyllene (NextGen design and connection model, source material)',
      'third_party/embedded-push-notice.md': 'embedded-fcm-distributor (3.1.0)',
      'third_party/embedded-push-relink.md': 'embedded-fcm-distributor (3.1.0)',
      'third_party/licenses/embedded-fcm-distributor-LGPL-2.1.txt':
          'embedded-fcm-distributor (3.1.0)',
      'third_party/NOTICE.md': 'Third-party source/build materials (scope)',
      'third_party/licenses/graphify-MIT.txt':
          'Graphify viewer template (source material)',
      'third_party/licenses/hermes-agent-MIT.txt':
          'Hermes Agent message templates (source material)',
      'third_party/licenses/flutter-BSD-3-Clause.txt':
          'Flutter iOS scaffold (source material)',
      'third_party/licenses/Apache-2.0.txt':
          'Gradle wrapper (Library build material)',
      'third_party/licenses/gradle-NOTICE.txt':
          'Gradle wrapper (Library build material)',
      // GPT-Live voice: the native WebRTC stack flutter_webrtc brings in.
      'third_party/webrtc/NOTICE.md': _webrtc,
      'third_party/licenses/webrtc-BSD-3-Clause.txt': _webrtc,
      'third_party/licenses/webrtc-PATENTS.txt': _webrtc,
      'third_party/licenses/webrtc-third-party-licenses.txt': _webrtc,
      'third_party/licenses/audioswitch-Apache-2.0.txt':
          'audioswitch (com.github.davidliu, Android)',
      'third_party/licenses/flutter_webrtc-NOTICE.txt':
          'flutter_webrtc (1.6.3) NOTICE',
      'third_party/licenses/unorm_dart-MIT.txt': 'unorm_dart (0.3.3)',
      'third_party/licenses/Unicode-3.0.txt':
          'Unicode Character Database (unorm_dart 0.3.3 normalisation data)',
    };
    for (final notice in notices.entries) {
      yield LicenseEntryWithLineBreaks([
        notice.value,
      ], await bundle.loadString(notice.key));
    }
  });
}
