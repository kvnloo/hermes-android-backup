# libwebrtc download for Windows and Linux builds

GPT-Live voice uses `flutter_webrtc` 1.6.3. On Windows and Linux, its CMake
does not build WebRTC: it downloads a prebuilt `libwebrtc` at configure time
and links the app against it. This page records what it downloads, how Ares
checks it, and what is still trusted.

## What flutter_webrtc downloads

`flutter_webrtc/third_party/CMakeLists.txt` reads
`third_party/libwebrtc_version.ini`:

```ini
binary_version = libwebrtc.m150.7871.07
download_url   = https://github.com/webrtc-sdk/libwebrtc/releases/download
```

and fetches `<download_url>/<binary_version>/libwebrtc-<os>-<arch>-release.zip`
into its own `third_party/downloads/` (inside the pub cache), then extracts it
to `third_party/libwebrtc/`. `<os>` is `win` or `linux`; `<arch>` is `x64` or
`arm64` (from `CMAKE_GENERATOR_PLATFORM` on Windows, `FLUTTER_TARGET_PLATFORM`
on Linux). GitHub redirects the URL to `webrtc-sdk/libwebrtc-wrapper`.

The plugin's `file(DOWNLOAD)` has **no checksum**, and the plugin skips the
download whenever the archive is already in `third_party/downloads/`. Its
CMake takes no URL or hash override.

| Archive | SHA-256 | Size |
|---|---|---|
| `libwebrtc-win-x64-release.zip` | `0cf141cd803af8f860080d94861d2d591ab9081a28f5cdead1b7c775ad5d3bf8` | 8,809,098 |
| `libwebrtc-win-arm64-release.zip` | `2546c8cc20a4326d6b40e06a250a642733e80e03a1ba36a0b115a491d65d3f85` | 7,625,855 |
| `libwebrtc-linux-x64-release.zip` | `ef380526cf9616848bc0b97b24990cbf2ad851c209d5dce93cc3ebb9d3789fbc` | 9,244,559 |
| `libwebrtc-linux-arm64-release.zip` | `887de0a1da6c9b8807da9fe2fc237e03ac5fcc3df4142a5f8889d66baa24bf08` | 8,326,710 |

Each hash was computed locally from the downloaded archive and equals both
the release's own `.shasum` file and GitHub's asset digest (2026-11-26).

## How Ares checks it

[`third_party/webrtc/libwebrtc_pin.cmake`](../third_party/webrtc/libwebrtc_pin.cmake)
holds the version, URL and the four hashes. `windows/CMakeLists.txt` and
`linux/CMakeLists.txt` include it and call `ares_pin_libwebrtc_for_app()`
before `include(flutter/generated_plugins.cmake)`, so it runs before the
plugin's own CMake. For the target being configured it:

1. reads the plugin's `libwebrtc_version.ini` and stops the configure if the
   release or URL differs from the pin, so a flutter_webrtc upgrade cannot
   silently change the binary;
2. checks an archive already in the plugin's `third_party/downloads/`: a
   mismatch is deleted together with the extracted `third_party/libwebrtc/`;
3. downloads a missing archive itself to a `.part` file, checks its SHA-256
   (a mismatch is deleted and stops the configure), renames it into place
   and removes any older extraction, so the plugin extracts the checked
   archive.

The plugin then finds the archive in place and does not download anything.
`test/libwebrtc_pin_test.dart` drives these steps through `cmake -P`.

## Updating

When flutter_webrtc moves to another libwebrtc release, the configure stops
with "flutter_webrtc now downloads …". Then:

1. read the new release's assets
   (`gh api repos/webrtc-sdk/libwebrtc/releases/tags/<version>`), download the
   four archives, compute their SHA-256 and compare with the release's
   `.shasum` files and asset digests;
2. update the version and hashes in `libwebrtc_pin.cmake`, this page and
   `third_party/webrtc/NOTICE.md` (and re-check the bundled components there);
3. run `test/libwebrtc_pin_test.dart`.

## What is still trusted

- **The plugin's extracted directory.** If `third_party/libwebrtc/` already
  exists next to a matching archive, it is used as is; it is not re-hashed.
  It lives in the shared pub cache, so anything that can write there can
  change it. A clean CI checkout (fresh pub cache) always extracts from the
  checked archive.
- **Builds outside the app's CMake.** Building flutter_webrtc's example or
  any other project from the same pub cache uses the plugin's unchecked
  download. If that writes the archive first, the next Ares configure checks
  it and replaces it on a mismatch.
- **The release itself.** The pin proves the archive is the one recorded
  here, not how it was built. The wrapper is published by webrtc-sdk; the
  binaries include WebRTC M150 and, on these two platforms, OpenH264 and
  Chromium's FFmpeg (LGPL-2.1-or-later). See
  [`third_party/webrtc/NOTICE.md`](../third_party/webrtc/NOTICE.md).
