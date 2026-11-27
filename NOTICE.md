# Attribution and status

This repository is a community derivative of
[rusty4444/hermes-android](https://github.com/rusty4444/hermes-android).

The Remote Gateway additions are maintained independently and are not an
official Hermes Agent, Nous Research, or upstream Hermes Android release.

The upstream snapshot used for the Remote Gateway work lacked a canonical
licence file, but its README already declared the application MIT-licensed.
The root [LICENSE](LICENSE) records those existing application terms in full;
it does not relicense third-party code or assets. Copyright and other rights
remain with their respective authors. Source history and contributor
attribution are preserved.

The bundled Cinzel font retains its [SIL Open Font License 1.1](assets/fonts/OFL.txt).
The embedded FCM distributor retains its upstream LGPL-2.1-or-later terms; see
the [Library notice](third_party/embedded-push-notice.md),
[verbatim licence](third_party/licenses/embedded-fcm-distributor-LGPL-2.1.txt)
and [source/relink instructions](third_party/embedded-push-relink.md).
Other dependencies retain their own licences and notices.

Files dropped on the composer from the desktop, and files or images pasted
from the clipboard, are read with the `desktop_drop` and `pasteboard` Flutter
plugins from [MixinNetwork/flutter-plugins](https://github.com/MixinNetwork/flutter-plugins)
(Apache License 2.0; neither ships a NOTICE file). Their licence text is
bundled with the app's package licences.

Telegram onboarding draws its QR code on the device with the Dart `qr` library
([BSD-3-Clause licence](third_party/licenses/qr-BSD-3-Clause.txt)); no QR
payload is sent to an image-generation service.

Real-time GPT-Live voice conversations use `flutter_webrtc` 1.6.3
(`dart_webrtc`, `webrtc_interface`, `logger`; MIT). It is not MIT all the way
down: its `NOTICE` adds Apache-2.0 code (Shiguredo) and MIT code
(react-native-webrtc), and it brings native WebRTC libraries under their own
terms: `io.github.webrtc-sdk:android` 150.7871.04 on Android and the
`WebRTC-SDK` 150.7871.04 `WebRTC.xcframework` on iOS and macOS (WebRTC,
BSD-3-Clause with Google's patent grant), `com.github.davidliu:audioswitch`
on Android (Apache-2.0), and the `libwebrtc.m150.7871.07` binaries on Windows
and Linux (an MIT wrapper around WebRTC). The WebRTC libraries bundle
BoringSSL, libvpx, Opus, libyuv, libsrtp, dav1d, libaom, Abseil and others
under BSD, ISC/OpenSSL and Apache-2.0 terms; the Windows and Linux libraries
also carry OpenH264 (BSD-2-Clause), libjpeg-turbo and FFmpeg
(LGPL-2.1-or-later). What ships where, the full texts and the LGPL source
pointers are in [third_party/webrtc/NOTICE.md](third_party/webrtc/NOTICE.md).
flutter_webrtc downloads the Windows and Linux libwebrtc archive at build
time with no checksum of its own; Ares pins it by SHA-256 and checks it before
the plugin runs. What is still trusted is recorded in
[docs/libwebrtc-desktop-download.md](docs/libwebrtc-desktop-download.md).
The gateway host performs session creation and holds any provider API key.

The New Bot form turns a typed name into a profile id with Unicode NFC and
NFKD normalisation from the Dart `unorm_dart` 0.3.3 library
([MIT licence](third_party/licenses/unorm_dart-MIT.txt), Copyright (c) 2018
Yasuhiro Shimizu; no dependencies). Its normalisation tables are derived from
the Unicode Character Database
([Unicode License v3](third_party/licenses/Unicode-3.0.txt), Copyright
© 1991-2026 Unicode, Inc.). Both notices are shown in the app's licences.

The completion sounds `ares_mail.wav` and `ares_reminder.wav` (in
`android/app/src/main/res/raw/`, `ios/Runner/` and `macos/Runner/`) and the
in-app chime are original tones made for this application. They contain no
recorded, sampled or third-party audio:
`lib/core/services/completion_tones.dart` synthesises them with plain
arithmetic, and `dart run tool/generate_completion_sounds.dart` rewrites the
bundled files byte for byte (`--check` reports drift). They are covered by the
application's [MIT notice](LICENSE).

Synthetic fixture credentials are test data only. No private gateway
credentials, release signing keys, device profiles, or operator logs are part
of the public source tree.
