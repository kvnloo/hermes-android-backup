#!/bin/sh
# Build only for the app's selected architectures. The sandboxed helper
# inherits its parent's restrictions; do not grant shell-specific entitlements.
set -eu
out="$TARGET_BUILD_DIR/$CONTENTS_FOLDER_PATH/Helpers/ares-pty"
mkdir -p "$(dirname "$out")"
set --
for arch in $ARCHS; do set -- "$@" -arch "$arch"; done
/usr/bin/xcrun clang++ -std=c++17 "$@" -isysroot "$SDKROOT" -mmacosx-version-min="$MACOSX_DEPLOYMENT_TARGET" -O2 "$PROJECT_DIR/../native/terminal/pty_posix.cc" -o "$out"
/usr/bin/codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY:--}" --entitlements "$PROJECT_DIR/terminal-helper.entitlements" "$out"
