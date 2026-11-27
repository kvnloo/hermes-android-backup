// Runs the pinned plugin's REAL image method and Windows GDI conversion on
// synthetic DIBs. All clipboard entry points are intercepted: this executable
// cannot read, empty, or replace any window station's clipboard. No Ares engine,
// account storage, desktop switch, or interactive user session is needed.
#include <Windows.h>
#include <ShlObj.h>
#include <gdiplus.h>
#include <cassert>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <map>
#include <memory>
#include <flutter/method_channel.h>
#include <flutter/method_result_functions.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

static std::vector<unsigned char> fixture;
static unsigned reads = 0;
static BOOL WINAPI FixtureAvailable(UINT format) { return format == CF_DIB; }
static BOOL WINAPI FixtureOpen(HWND) { return TRUE; }
static BOOL WINAPI FixtureClose() { return TRUE; }
static HANDLE WINAPI FixtureRead(UINT format) {
  if (format != CF_DIB) std::abort();
  ++reads;
  return fixture.data(); // Matches the pinned plugin's pointer interpretation.
}
static BOOL WINAPI ForbiddenEmpty() { std::abort(); }
static HANDLE WINAPI ForbiddenWrite(UINT, HANDLE) { std::abort(); }

#define IsClipboardFormatAvailable FixtureAvailable
#define OpenClipboard FixtureOpen
#define CloseClipboard FixtureClose
#define GetClipboardData FixtureRead
#define EmptyClipboard ForbiddenEmpty
#define SetClipboardData ForbiddenWrite
// Include the installed, pinned source rather than reimplementing its image
// method. Only expose the method for this fixture invocation.
#define private public
#include "pasteboard_plugin.cpp"
#undef private
#undef IsClipboardFormatAvailable
#undef OpenClipboard
#undef CloseClipboard
#undef GetClipboardData
#undef EmptyClipboard
#undef SetClipboardData

int run(int argc, char** argv) {
  if (argc != 2) return 2;
  std::filesystem::create_directories(argv[1]);
  for (int kind : {24, 32, 132}) {
    const int depth = kind == 132 ? 32 : kind;
    const int headerSize = kind == 132 ? sizeof(BITMAPV5HEADER) : sizeof(BITMAPINFOHEADER);
    const int width = 3, height = 2;
    const int stride = ((width * depth + 31) / 32) * 4;
    fixture.assign(headerSize + stride * height, 0);
    auto* h = reinterpret_cast<BITMAPINFOHEADER*>(fixture.data());
    h->biSize = headerSize;
    if (kind == 132) reinterpret_cast<BITMAPV5HEADER*>(h)->bV5CSType = LCS_sRGB;
    h->biWidth = width;
    h->biHeight = height;
    h->biPlanes = 1;
    h->biBitCount = static_cast<WORD>(depth);
    h->biSizeImage = stride * height;
    // Top row red/green/blue, bottom row white/black/yellow (BGR, bottom up).
    const unsigned char rgb[2][3][3] = {
      {{255,0,0},{0,255,0},{0,0,255}},
      {{255,255,255},{0,0,0},{255,255,0}}
    };
    for (int y = 0; y < height; ++y) for (int x = 0; x < width; ++x) {
      auto* p = fixture.data() + headerSize + (height-1-y)*stride + x*(depth/8);
      p[0]=rgb[y][x][2]; p[1]=rgb[y][x][1]; p[2]=rgb[y][x][0];
      // Fourth byte intentionally zero: BI_RGB XRGB is opaque, not alpha.
    }
    PasteboardPlugin plugin;
    std::string path, error;
    auto result = std::make_unique<flutter::MethodResultFunctions<flutter::EncodableValue>>(
      [&](const flutter::EncodableValue* v) {
        if (v && std::holds_alternative<std::string>(*v)) path = std::get<std::string>(*v);
      },
      [&](const std::string& code, const std::string&, const flutter::EncodableValue*) { error=code; },
      [&]() { error="not implemented"; });
    plugin.HandleMethodCall(flutter::MethodCall<flutter::EncodableValue>("image", nullptr), std::move(result));
    if (!error.empty() || path.empty()) return 3;
    std::ifstream stream(path, std::ios::binary);
    std::vector<char> bytes((std::istreambuf_iterator<char>(stream)), {});
    if (bytes.size() != 54 + width*height*4 || bytes[0]!='B' || bytes[1]!='M') return 4;
    const auto target = std::filesystem::path(argv[1]) / ("native-dib"+std::to_string(kind)+".bmp");
    std::ofstream output(target, std::ios::binary);
    output.write(bytes.data(), bytes.size()); output.close();
    stream.close();
    std::filesystem::remove(path);
    std::cout << "CF_DIB " << depth << " -> BMP " << bytes.size() << " bytes\n";
  }
  if (reads != 3) return 5;
  std::cout << "PASS: 3 real plugin method calls; fixture-only clipboard API\n";
  return 0;
}

int main(int argc, char** argv) {
  try { return run(argc, argv); }
  catch (const std::exception& e) { std::cerr << e.what() << std::endl; return 10; }
}
