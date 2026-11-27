# WebRTC native stack: notices

Real-time GPT-Live voice uses `flutter_webrtc` 1.6.3, which brings a native
WebRTC library onto every platform. This file says what ships where, under
which licence, and what was checked. The complete licence texts are in
[`../licenses/`](../licenses/) and appear in the app under Settings → About →
Licences.

Checked on 2026-11-26 against the exact artefacts below. This is a notice
inventory, not legal clearance.

## What ships

| Platform | Artefact | Source | Identity |
|---|---|---|---|
| Android | `io.github.webrtc-sdk:android:150.7871.04` (AAR; `libjingle_peerconnection_so.so` for arm64-v8a, armeabi-v7a, x86, x86_64) | Maven Central | AAR SHA-256 `1872dda4e3bf7d6ea6f7c6e11861332081c57081a1e62fc82fab72415c69c84c`; POM licence: The 3-Clause BSD License |
| Android | `com.github.davidliu:audioswitch` at commit `039a35aefab7747c557242fa216c9ea11743b604` | JitPack (fork of twilio/audioswitch) | Apache-2.0, Copyright 2020 Twilio, inc. |
| iOS, macOS | `WebRTC-SDK` 150.7871.04 pod (`WebRTC.xcframework`) | <https://github.com/webrtc-sdk/Specs/releases/download/150.7871.04/WebRTC.xcframework.zip> | ZIP SHA-256 `9532fe3ce47507c304f37a4355b907be1e89967971d614a04603005a546249be` (GitHub release digest); its `LICENSE` is the WebRTC BSD-3-Clause text, byte for byte |
| Windows, Linux | `libwebrtc.m150.7871.07` prebuilt (`libwebrtc.dll` / `libwebrtc.so`) | <https://github.com/webrtc-sdk/libwebrtc/releases/tag/libwebrtc.m150.7871.07> | Per-arch ZIP SHA-256 below; downloaded at CMake configure time and checked against these hashes (see [docs/libwebrtc-desktop-download.md](../../docs/libwebrtc-desktop-download.md)) |
| all | `flutter_webrtc` 1.6.3 (with `dart_webrtc`, `webrtc_interface`) | pub.dev | MIT (its LICENSE is in the app's package licences); its `NOTICE` adds Apache-2.0 code from Shiguredo and MIT code from react-native-webrtc |

libwebrtc.m150.7871.07 release archives (SHA-256 computed locally, equal to
the release's `.shasum` files and GitHub's asset digests):

| Asset | SHA-256 |
|---|---|
| `libwebrtc-win-x64-release.zip` | `0cf141cd803af8f860080d94861d2d591ab9081a28f5cdead1b7c775ad5d3bf8` |
| `libwebrtc-win-arm64-release.zip` | `2546c8cc20a4326d6b40e06a250a642733e80e03a1ba36a0b115a491d65d3f85` |
| `libwebrtc-linux-x64-release.zip` | `ef380526cf9616848bc0b97b24990cbf2ad851c209d5dce93cc3ebb9d3789fbc` |
| `libwebrtc-linux-arm64-release.zip` | `887de0a1da6c9b8807da9fe2fc237e03ac5fcc3df4142a5f8889d66baa24bf08` |

The libwebrtc wrapper itself is MIT (Copyright (c) 2019 湖北捷智云技术有限公司,
the `LICENSE` inside each archive; the same text as flutter_webrtc's). It links
Google's WebRTC M150 statically.

## Licences

- **WebRTC** (all platforms): BSD-3-Clause, Copyright (c) 2011, The WebRTC
  project authors, plus Google's Additional IP Rights Grant (Patents):
  [webrtc-BSD-3-Clause.txt](../licenses/webrtc-BSD-3-Clause.txt),
  [webrtc-PATENTS.txt](../licenses/webrtc-PATENTS.txt). Texts taken from
  WebRTC `branch-heads/7871`.
- **Components WebRTC bundles** (texts at the revisions WebRTC M150's `DEPS`
  pins): [webrtc-third-party-licenses.txt](../licenses/webrtc-third-party-licenses.txt).

| Component | Licence | Markers found in |
|---|---|---|
| BoringSSL | Apache-2.0 (with ISC/OpenSSL notices) | Android, Windows, Linux |
| libvpx (VP8/VP9) | BSD-3-Clause + WebM patent grant | Android, Windows, Linux |
| Opus | BSD-3-Clause + Opus patent notices | Android, Windows, Linux |
| libyuv | BSD-3-Clause | Android, Windows, Linux |
| libsrtp | BSD-3-Clause | Android, Windows, Linux |
| dav1d | BSD-2-Clause | Android, Windows, Linux |
| libaom | BSD-2-Clause + AOMedia Patent License 1.0 | Android, Windows, Linux |
| Abseil | Apache-2.0 | Android, Linux |
| crc32c, PFFFT, RNNoise | BSD-3-Clause; BSD-style (FFTPACK); BSD-3-Clause | Linux (WebRTC's audio processing and logging use them on every platform) |
| OpenH264 | BSD-2-Clause | Windows, Linux only |
| libjpeg-turbo | IJG, BSD-3-Clause, Zlib | Windows, Linux only |
| FFmpeg (Chromium's build) | **LGPL-2.1-or-later** | Windows, Linux only |

"Markers found" means strings or symbols of that component in the shipped
native library (`strings` over the Android arm64 `.so`, the Windows x64/arm64
`.dll` and the Linux x64/arm64 `.so`). The stripped Android and Windows
binaries carry fewer names, so a missing marker does not prove absence. The
Apple xcframework (686 MB) was not inspected beyond its `LICENSE`; Apple
builds use VideoToolbox for H.264, but the remaining WebRTC components above
should be assumed present.

- **audioswitch** (Android): Apache-2.0,
  [audioswitch-Apache-2.0.txt](../licenses/audioswitch-Apache-2.0.txt)
  (its own `LICENSE.txt` at the pinned commit, with the Twilio copyright).
- **flutter_webrtc NOTICE**: [flutter_webrtc-NOTICE.txt](../licenses/flutter_webrtc-NOTICE.txt)
  (verbatim from the 1.6.3 package): Apache-2.0
  `SimulcastVideoEncoderFactoryWrapper.kt` (Copyright 2017 Lyo Kato;
  2017-2021 Shiguredo Inc.), MIT code from react-native-webrtc (Copyright
  2015 Howard Yang), and flutter_webrtc's MIT licence.

No GPL or AGPL component was found. Chromium's FFmpeg is built without
`--enable-gpl`; its README lists bsd-2-clause, bsd-3-clause, isc, lgpl-2.1
and mit.

## Obligations to keep

- **FFmpeg (LGPL-2.1-or-later), Windows and Linux.** It is linked into
  `libwebrtc.dll` / `libwebrtc.so`, which the app ships as a separate shared
  library beside the executable, so a user can replace it. The corresponding
  source is public: Chromium's FFmpeg at
  <https://chromium.googlesource.com/chromium/third_party/ffmpeg/+/ad41607c61898cf7150e0fb20fe4bbabd44922a3>,
  WebRTC at `branch-heads/7871`, and the wrapper at
  <https://github.com/webrtc-sdk/libwebrtc>. Release notes for the Windows and
  Linux builds should keep pointing to these sources.
- **H.264.** The Windows and Linux libraries carry an H.264 encoder (OpenH264
  built from source) and decoder (FFmpeg). Cisco's OpenH264 patent licence
  covers only Cisco's own binaries, not these builds; H.264 patent licences
  may apply in some countries.
- **Patent grants.** WebRTC, libvpx, Opus and libaom come with their own
  patent grants or notices; they are part of the texts above.
