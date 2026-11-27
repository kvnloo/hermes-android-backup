#!/bin/sh
# Host-side unit tests for the platform-free parts of the desktop runners.
# These compile on any host with a C++17 compiler; they do not build the app.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
out=${TMPDIR:-/tmp}/ares-native-tests
mkdir -p "$out"
cxx=${CXX:-clang++}
status=0
for test in "$here"/*_test.cpp; do
  name=$(basename "$test" .cpp)
  "$cxx" -std=c++17 -Wall -Wextra -Werror -pedantic "$test" -o "$out/$name"
  "$out/$name" || status=1
done
exit $status
