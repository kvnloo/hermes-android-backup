#!/bin/sh
# Builds and runs the StatusNotifierItem tray (linux/runner/status_notifier.cc)
# against a fake watcher and host on a private D-Bus session bus, inside the
# disposable Debian container used by linux_compile_check.sh (network off,
# no display). This is a runtime test of the D-Bus protocol, not an app build.
#
# Usage: tool/native_tests/linux_sni_check.sh
# Image: ARES_LINUX_CC_IMAGE (default ares-linux-cc:bookworm), which needs
#   clang, pkg-config, libglib2.0-dev (via libgtk-3-dev) and dbus-daemon.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/../.." && pwd)
image=${ARES_LINUX_CC_IMAGE:-ares-linux-cc:bookworm}
COPYFILE_DISABLE=1 tar -C "$root" -cf - linux/runner/status_notifier.h \
  linux/runner/status_notifier.cc tool/native_tests/linux_sni_dbus_test.cc |
  docker run --rm -i --network none "$image" sh -ec '
  mkdir -p /src && tar -C /src -xf - 2>/dev/null
  cd /src
  clang++ -std=c++17 -Wall -Wextra -Werror \
    $(pkg-config --cflags gio-2.0) \
    linux/runner/status_notifier.cc tool/native_tests/linux_sni_dbus_test.cc \
    $(pkg-config --libs gio-2.0) -o /tmp/linux_sni_dbus_test
  echo "ok status_notifier.cc + linux_sni_dbus_test.cc (-Wall -Wextra -Werror)"
  dbus-run-session -- /tmp/linux_sni_dbus_test'
