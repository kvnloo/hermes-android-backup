# Windows screenshot paste regression (49d29803)

## Evidence and fix

`ClipboardAttachmentPaste` routes both Ctrl+V and the editor's Paste menu to
`readClipboardAttachment` in `os_intake.dart` in both Classic and NextGen.
Files take precedence. Its image branch reads `Pasteboard.image`, then the UI
stages those bytes as `pasted-*.png` and calls `AttachmentDraftService.prepareImage`.

The pinned **pasteboard 0.6.2 Windows implementation returns a BMP, not a PNG**:
`HandleMethodCall("image")` reads CF_DIB, renders to a 32-bit GDI bitmap, calls
`CreateBMPFile` (whose file signature is `BM`), and returns a temporary filename.
The package's Dart Windows adapter reads and deletes that temporary file. Ares
previously staged these BMP bytes under a PNG extension without conversion.
The service correctly rejects their signature as unsupported (PNG/JPEG/WebP
only). The regression explicitly verifies that raw native output is refused.

The shared Windows clipboard intake now validates the narrow BMP file transport
emitted by this plugin and converts it with the already-used `image` package.
The resulting real PNG still goes through normal service decoding, metadata
scrubbing, attachment limits, and cache ownership. Picked/dropped BMP files are
not newly supported; unknown bytes and headerless DIBs are never relabeled PNG.
No dependencies or native plugins changed. Existing owner fences and file-first
precedence are untouched.

Before BMP decoding, the transport guard checks file/header/pixel extents,
planes, depth, compression, palette absence, and dimensions against a 64 MiB
input / 64 MiB RGBA pixel budget. Arithmetic is bounded before multiplying
stride/height. BI_RGB's reserved fourth byte is opaque, not image alpha.

## Reproducible native evidence (no user clipboard access)

`tool/windows_clipboard_fixture/native_reader.cpp` includes the **actual pinned
plugin source** and directly invokes its actual `HandleMethodCall("image")`
using Flutter's native MethodCall/MethodResult classes. Windows GDI conversion
and BMP serialization are real. Clipboard APIs are intercepted at compile time:
reads come only from generated six-pixel DIB fixtures; writes/empty abort.
**It never reads, saves, clears, or overwrites any real clipboard.** It creates
no Flutter engine and does not launch Ares or touch its credentials/storage.

Compiled and executed on SAM-GAMING using MSVC 17.14.45 and existing Flutter
release wrapper libraries (no installer or full application build). All three
method calls succeeded:

- 24-bit bottom-up BITMAPINFOHEADER, including DWORD row padding;
- 32-bit bottom-up BITMAPINFOHEADER with reserved alpha bytes zero;
- 32-bit bottom-up BITMAPV5HEADER, BI_RGB/sRGB, delivered via the CF_DIB seam.

All three produced identical 78-byte, 3x2 BMP files:
`1d1659e75d396fd175fbb829613147d13410c8300698b77d8e9079be78548977`.
One copy is retained as `test/fixtures/windows_clipboard/native-reader.bmp`.
Dart regression tests assert all six RGB pixels, row order, and opacity after
conversion and again after service sanitization.

Run the native harness from a disposable directory containing its two source
files, with an existing Windows Flutter build (not a running app):

```powershell
powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File .\run.ps1 `
  -BuildRoot C:\path\to\existing\flutter\project `
  -Plugin C:\path\to\pub-cache\hosted\pub.dev\pasteboard-0.6.2
```

`run.ps1` checks the pinned plugin source SHA-256 before compiling. It only
writes its own staging directory and the native plugin's temporary image file,
which the harness deletes after reading. Build artifacts are not committed.

## Coverage boundaries

This is **native method invocation + actual GDI + exported-byte regression**,
not OS clipboard / Snipping Tool / Flutter-engine end-to-end verification.
There is no private screenshot capture and no claim to have isolated an OS
clipboard using a desktop: Windows clipboard isolation is per window station,
not merely per desktop. No actual clipboard API is called by the harness.

The plugin only requests CF_DIB; OS synthesis from CF_BITMAP/CF_DIBV5 and
registered PNG-only clipboard availability remain unverified. Its native reader
has pre-existing limitations for negative-height DIBs / alpha bitfields. This
fix does not rewrite that dependency or claim to fix every Windows clipboard
representation. The Dart conversion separately verifies top-down BMP transport,
24-bit row padding, opaque XRGB, PNG alpha passthrough, malformed/truncated/
overflow/oversized BMP rejection, and unchanged service format policy.

The Classic/NextGen desktop intake tests now feed this native BMP through the
real shared reader's method-channel seam on Windows variants, rather than
returning PNG from the debug reader. They exercise Ctrl+V twice, context-menu
Paste, existing attachments, multiple files, invalid data, text preservation,
draft cap and staging cleanup. They are widget/service tests with channel
fixtures, not native clipboard E2E.

## Validation results

- `flutter analyze --fatal-infos --no-pub`: no issues.
- Full macOS-host Flutter suite with SSH and PTY fixture binaries enabled:
  **8,530 passed, 5 failed, 2 skipped**, all **652 test files** attempted.
  The clipboard/attachment/intake subset contains **323 passing tests** and
  no failures. No suite was excluded.
- The five full-suite failures are outside this change: delivered-files quote
  scan timing, PTY background-sleep startup, two render-recheck time budgets,
  and transcript-redaction timing. Serial reruns passed the PTY and render
  files, while delivered-files and transcript-redaction timing assertions still
  failed on this host. No thresholds were relaxed. The two initially skipped
  FFmpeg tests passed separately with explicit Homebrew ffmpeg/ffprobe paths.
- On actual Windows, `windows_clipboard_image_test.dart`: **22 passed**;
  Classic/NextGen `--plain-name desktop` layout/owner tests: **8 passed**.
  These exercise the Windows Dart adapter's temporary-file read/delete branch
  against channel fixtures, not a loaded native clipboard channel.
- Actual Windows C++ pinned-plugin method/GDI harness: **3 successful native
  method calls**, with the common exported BMP hash recorded above.
- An initial combined Windows run also attempted the older
  `desktop_clipboard_paste_test.dart`; it stalled in its pre-existing async
  file-writing method mock under widget fake-async. Only that owned test
  process tree was stopped. The new conversion file and both layout files
  were subsequently run to completion as reported above; the interrupted
  combined attempt is not counted as a passing suite.

Machine-readable local evidence is in Hermes scratch:
`snipping-full.jsonl`, `snipping-final-analyze.log`, `conversion.jsonl`,
`layouts.jsonl`, `snipping-recheck.jsonl`, and `snipping-extra.jsonl`.
Windows disposable staging roots are `C:\\dev\\ares-snipping-fixture-49d29803`
and `C:\\dev\\ares-snipping-dart-49d29803`. No installer was built, no app
was installed/launched, and no Store/standalone identity was accessed.
