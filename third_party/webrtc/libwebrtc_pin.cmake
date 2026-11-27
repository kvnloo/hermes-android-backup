# Pins and checks the libwebrtc archive flutter_webrtc downloads for the
# Windows and Linux builds.
#
# flutter_webrtc's third_party/CMakeLists.txt downloads
#   <download_url>/<binary_version>/libwebrtc-<os>-<arch>-release.zip
# (both values from its third_party/libwebrtc_version.ini) into its own
# third_party/downloads/, with no checksum, and skips the download when the
# archive is already there. Its CMake takes no URL or hash override. So the
# application's CMake includes this file before the plugins: it puts the
# archive at that exact path itself, downloaded with EXPECTED_HASH, and checks
# an archive already there. A version flutter_webrtc asks for that is not
# pinned here stops the configure. See docs/libwebrtc-desktop-download.md.

set(ARES_LIBWEBRTC_VERSION "libwebrtc.m150.7871.07")
set(ARES_LIBWEBRTC_URL_BASE
    "https://github.com/webrtc-sdk/libwebrtc/releases/download")
set(ARES_LIBWEBRTC_SHA256_win_x64
    "0cf141cd803af8f860080d94861d2d591ab9081a28f5cdead1b7c775ad5d3bf8")
set(ARES_LIBWEBRTC_SHA256_win_arm64
    "2546c8cc20a4326d6b40e06a250a642733e80e03a1ba36a0b115a491d65d3f85")
set(ARES_LIBWEBRTC_SHA256_linux_x64
    "ef380526cf9616848bc0b97b24990cbf2ad851c209d5dce93cc3ebb9d3789fbc")
set(ARES_LIBWEBRTC_SHA256_linux_arm64
    "887de0a1da6c9b8807da9fe2fc237e03ac5fcc3df4142a5f8889d66baa24bf08")

# The archive's OS and arch fields, chosen as flutter_webrtc chooses them.
function(ares_libwebrtc_target out_os out_arch)
  if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(os "win")
    string(TOLOWER "${CMAKE_GENERATOR_PLATFORM}" platform)
    if(platform STREQUAL "arm64")
      set(arch "arm64")
    else()
      set(arch "x64")
    endif()
  else()
    set(os "linux")
    if(DEFINED FLUTTER_TARGET_PLATFORM AND FLUTTER_TARGET_PLATFORM MATCHES "arm64")
      set(arch "arm64")
    elseif(DEFINED FLUTTER_TARGET_PLATFORM AND FLUTTER_TARGET_PLATFORM MATCHES "x64")
      set(arch "x64")
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64")
      set(arch "arm64")
    else()
      set(arch "x64")
    endif()
  endif()
  set(${out_os} "${os}" PARENT_SCOPE)
  set(${out_arch} "${arch}" PARENT_SCOPE)
endfunction()

# ares_pin_libwebrtc(PLUGIN_DIR <flutter_webrtc dir> OS <win|linux>
#                    ARCH <x64|arm64> [URL_BASE <url>] [SHA256 <hash>])
# URL_BASE and SHA256 default to the pins above (tests override them).
function(ares_pin_libwebrtc)
  cmake_parse_arguments(PIN "" "PLUGIN_DIR;OS;ARCH;URL_BASE;SHA256" "" ${ARGN})
  if(NOT PIN_URL_BASE)
    set(PIN_URL_BASE "${ARES_LIBWEBRTC_URL_BASE}")
  endif()
  if(NOT PIN_SHA256)
    set(PIN_SHA256 "${ARES_LIBWEBRTC_SHA256_${PIN_OS}_${PIN_ARCH}}")
  endif()
  if(NOT PIN_SHA256)
    message(FATAL_ERROR
      "libwebrtc pin: no SHA-256 pinned for ${PIN_OS}-${PIN_ARCH} "
      "(third_party/webrtc/libwebrtc_pin.cmake)")
  endif()

  get_filename_component(third_party "${PIN_PLUGIN_DIR}/third_party" REALPATH)
  set(ini "${third_party}/libwebrtc_version.ini")
  if(NOT EXISTS "${ini}")
    message(FATAL_ERROR "libwebrtc pin: ${ini} is missing")
  endif()
  set(version "")
  set(url_base "")
  file(STRINGS "${ini}" lines)
  foreach(line IN LISTS lines)
    string(STRIP "${line}" line)
    if(line MATCHES "^binary_version[ \t]*=[ \t]*(.+)$")
      string(STRIP "${CMAKE_MATCH_1}" version)
    elseif(line MATCHES "^download_url[ \t]*=[ \t]*(.+)$")
      string(STRIP "${CMAKE_MATCH_1}" url_base)
      string(REGEX REPLACE "/+$" "" url_base "${url_base}")
    endif()
  endforeach()
  if(NOT version STREQUAL ARES_LIBWEBRTC_VERSION OR
     NOT url_base STREQUAL ARES_LIBWEBRTC_URL_BASE)
    message(FATAL_ERROR
      "libwebrtc pin: flutter_webrtc now downloads '${version}' from "
      "'${url_base}', but '${ARES_LIBWEBRTC_VERSION}' from "
      "'${ARES_LIBWEBRTC_URL_BASE}' is pinned. Check the new release and "
      "update third_party/webrtc/libwebrtc_pin.cmake "
      "(docs/libwebrtc-desktop-download.md).")
  endif()

  set(asset "libwebrtc-${PIN_OS}-${PIN_ARCH}-release")
  set(zip "${third_party}/downloads/${asset}.zip")
  if(EXISTS "${zip}")
    file(SHA256 "${zip}" actual)
    if(actual STREQUAL PIN_SHA256)
      message(STATUS "libwebrtc pin: ${asset}.zip matches its SHA-256")
      return()
    endif()
    message(WARNING
      "libwebrtc pin: ${zip} has SHA-256 ${actual}, not the pinned "
      "${PIN_SHA256}; downloading it again")
    file(REMOVE "${zip}")
    # Whatever was extracted from it is not trusted either.
    file(REMOVE_RECURSE "${third_party}/libwebrtc")
  endif()

  set(url "${PIN_URL_BASE}/${ARES_LIBWEBRTC_VERSION}/${asset}.zip")
  message(STATUS "libwebrtc pin: downloading ${url}")
  file(MAKE_DIRECTORY "${third_party}/downloads")
  set(partial "${zip}.part")
  file(REMOVE "${partial}")
  file(DOWNLOAD "${url}" "${partial}" TLS_VERIFY ON STATUS status)
  list(GET status 0 code)
  if(NOT code EQUAL 0)
    file(REMOVE "${partial}")
    message(FATAL_ERROR "libwebrtc pin: download of ${url} failed: ${status}")
  endif()
  # Checked here rather than with EXPECTED_HASH, which would leave the
  # mismatched file behind.
  file(SHA256 "${partial}" downloaded)
  if(NOT downloaded STREQUAL PIN_SHA256)
    file(REMOVE "${partial}")
    message(FATAL_ERROR
      "libwebrtc pin: ${url} has SHA-256 ${downloaded}, not the pinned "
      "${PIN_SHA256}")
  endif()
  file(RENAME "${partial}" "${zip}")
  # flutter_webrtc extracts from the checked archive when this is missing.
  file(REMOVE_RECURSE "${third_party}/libwebrtc")
endfunction()

# For the app's CMakeLists.txt: pins the archive for the target being
# configured, when flutter_webrtc is one of the app's plugins.
function(ares_pin_libwebrtc_for_app)
  set(plugin "${CMAKE_CURRENT_SOURCE_DIR}/flutter/ephemeral/.plugin_symlinks/flutter_webrtc")
  if(NOT EXISTS "${plugin}")
    message(STATUS "libwebrtc pin: flutter_webrtc is not a plugin here")
    return()
  endif()
  ares_libwebrtc_target(os arch)
  ares_pin_libwebrtc(PLUGIN_DIR "${plugin}" OS "${os}" ARCH "${arch}")
endfunction()
