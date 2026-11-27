#!/bin/sh
# Type-checks ios/Runner/SceneDelegate.swift (keep-awake and hermes:// deep
# link channels) and the shared Apple layer (apple/AresApple.swift) against
# the iOS SDK and the real Flutter.framework from the Flutter cache, warnings
# as errors. Without the cache it falls back to a declarations-only Flutter
# stub. A compile check of the runner sources, not an app build.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/../.." && pwd)
out=${TMPDIR:-/tmp}/ares-ios-typecheck
rm -rf "$out"
mkdir -p "$out"
sdk=$(xcrun --sdk iphonesimulator --show-sdk-path)
target=${ARES_IOS_TARGET:-arm64-apple-ios15.0-simulator}
flutter_bin=$(command -v flutter || true)
flutter_root=${FLUTTER_ROOT:-$( [ -n "$flutter_bin" ] && cd "$(dirname "$(readlink -f "$flutter_bin")")/.." 2>/dev/null && pwd -P || true)}
real="$flutter_root/bin/cache/artifacts/engine/ios/Flutter.xcframework/ios-arm64_x86_64-simulator"
if [ -d "$real/Flutter.framework" ]; then
  xcrun swiftc -sdk "$sdk" -target "$target" -typecheck -F "$real" \
    -warnings-as-errors \
    "$root/ios/Runner/SceneDelegate.swift" \
    "$root/apple/AresApple.swift"
  echo "iOS SceneDelegate + AresApple Swift type-check against the real Flutter.framework ($target)"
else
  xcrun swiftc -sdk "$sdk" -target "$target" -parse-as-library \
    -emit-module -module-name Flutter \
    -emit-module-path "$out/Flutter.swiftmodule" \
    "$here/flutter_ios_stub.swift"
  xcrun swiftc -sdk "$sdk" -target "$target" -typecheck -I "$out" \
    -warnings-as-errors \
    "$root/ios/Runner/SceneDelegate.swift" \
    "$here/ios_stub_shared.swift"
  echo "iOS SceneDelegate Swift type-checks against the Flutter stub ($target)"
fi
