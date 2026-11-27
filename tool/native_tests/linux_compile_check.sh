#!/bin/sh
# Compiles the Linux runner sources (syntax and types, no link) against real
# GTK 3 headers and the Flutter engine's flutter_linux headers, inside a
# disposable Debian container with no network. Not an app build.
#
# Usage: tool/native_tests/linux_compile_check.sh <flutter-gtk-dir>
#   <flutter-gtk-dir> is an unpacked linux-<arch>-flutter-gtk.zip for this
#   Flutter version's engine (it contains flutter_linux/).
# Image: debian:bookworm-slim + clang pkg-config libgtk-3-dev libstdc++-12-dev
#   (ARES_LINUX_CC_IMAGE, default ares-linux-cc:bookworm).
# Sources are streamed in with tar, so no host directory is mounted.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/../.." && pwd)
gtk=$(cd "$1" && pwd)
image=${ARES_LINUX_CC_IMAGE:-ares-linux-cc:bookworm}
{
  COPYFILE_DISABLE=1 tar -C "$root" -cf - linux/runner \
    linux/flutter/generated_plugin_registrant.h
  COPYFILE_DISABLE=1 tar -C "$gtk" -cf - flutter_linux
} | docker run --rm -i --network none "$image" sh -ec '
  mkdir -p /src && tar --ignore-zeros -C /src -xf - 2>/dev/null
  flags="-std=c++17 -Wall -Werror -fsyntax-only \
    -DAPPLICATION_ID=\"com.hermesagent.ares\" \
    $(pkg-config --cflags gtk+-3.0) -I/src -I/src/linux"
  # New code also passes -Wextra; the Flutter template file keeps the
  # project flags (apply_standard_settings: -Wall -Werror).
  clang++ $flags -Wextra /src/linux/runner/desktop_os.cc
  echo "ok desktop_os.cc (-Wall -Wextra -Werror)"
  clang++ $flags -Wextra /src/linux/runner/status_notifier.cc
  echo "ok status_notifier.cc (-Wall -Wextra -Werror)"
  clang++ $flags /src/linux/runner/my_application.cc
  echo "ok my_application.cc (-Wall -Werror)"'
