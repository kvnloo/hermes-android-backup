#!/bin/sh
# Type-checks the macOS runner's Swift against the real macOS SDK and a stub
# FlutterMacOS module (declarations only). This is a compile check of the
# runner sources, not an app build: no engine, plugins or bundle.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/../.." && pwd)
out=${TMPDIR:-/tmp}/ares-macos-typecheck
rm -rf "$out"
mkdir -p "$out"
sdk=$(xcrun --sdk macosx --show-sdk-path)
target=${ARES_MACOS_TARGET:-arm64-apple-macos13.0}
xcrun swiftc -sdk "$sdk" -target "$target" -parse-as-library \
  -emit-module -module-name FlutterMacOS \
  -emit-module-path "$out/FlutterMacOS.swiftmodule" \
  "$here/flutter_macos_stub.swift"
xcrun swiftc -sdk "$sdk" -target "$target" -typecheck -I "$out" \
  -warnings-as-errors \
  "$root/macos/Runner/AresDesktopOS.swift" \
  "$root/macos/Runner/AppDelegate.swift" \
  "$root/macos/Runner/MainFlutterWindow.swift" \
  "$here/macos_stub_registrant.swift"
echo "macOS runner Swift type-checks ($target)"

# Second pass against the real FlutterMacOS framework from the Flutter cache,
# with the shared Apple layer (apple/AresApple.swift) instead of its stand-in.
# That file has pre-existing AVFoundation deprecation warnings on macOS 13, so
# this pass fails on errors and on any warning outside it.
flutter_bin=$(command -v flutter || true)
flutter_root=${FLUTTER_ROOT:-$( [ -n "$flutter_bin" ] && cd "$(dirname "$(readlink -f "$flutter_bin")")/.." 2>/dev/null && pwd -P || true)}
real="$flutter_root/bin/cache/artifacts/engine/darwin-x64/FlutterMacOS.xcframework/macos-arm64_x86_64"
if [ -d "$real/FlutterMacOS.framework" ]; then
  printf 'import FlutterMacOS\nfunc RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {}\n' \
    > "$out/registrant.swift"
  log="$out/real.log"
  xcrun swiftc -sdk "$sdk" -target "$target" -typecheck -F "$real" \
    "$root/macos/Runner/AresDesktopOS.swift" \
    "$root/macos/Runner/AppDelegate.swift" \
    "$root/macos/Runner/MainFlutterWindow.swift" \
    "$root/apple/AresApple.swift" \
    "$out/registrant.swift" > "$log" 2>&1 || { cat "$log"; exit 1; }
  if grep -E '^[^ ]+\.swift:[0-9]+:[0-9]+: (warning|error)' "$log" | grep -v '/apple/AresApple.swift:' ; then
    echo "warnings in the macOS runner sources"; exit 1
  fi
  echo "macOS runner Swift type-checks against the real FlutterMacOS framework"
else
  echo "real FlutterMacOS framework not found; skipped the second pass"
fi
