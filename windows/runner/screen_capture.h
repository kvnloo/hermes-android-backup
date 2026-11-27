#ifndef RUNNER_SCREEN_CAPTURE_H_
#define RUNNER_SCREEN_CAPTURE_H_

#include <windows.h>

#include <string>

// Windows Graphics Capture for the composer's "Capture screen" action.
//
// The system GraphicsCapturePicker is the consent: the user chooses a window
// or a display (Ares' own windows can be skipped). One frame of the chosen
// item is copied off the GPU and written as a PNG in the folder Dart gave.
// Results come back as window messages so they are handled on the UI
// (platform) thread, where Flutter method results must be completed.
namespace ares::capture {

// True on Windows versions with Graphics Capture (1903 and later).
bool Supported();

// An item the user picked; owned by the message receiver.
struct Picked;

// What a capture produced: a PNG path, or an error code for Dart
// ("cancelled", "failed").
struct Outcome {
  std::string path;
  std::string error;
};

// Opens the picker owned by [owner]. Posts [message] with LPARAM = Picked*
// (nullptr when the user cancelled). Returns false when it could not open.
bool Pick(HWND owner, UINT message);

// Captures one frame of [picked] (takes ownership) on a worker thread into
// [directory]. Posts [message] with LPARAM = Outcome*.
void CaptureAsync(HWND owner, UINT message, Picked* picked,
                  std::wstring directory);

// Frees a Picked* from a message that was not consumed.
void Release(Picked* picked);

}  // namespace ares::capture

#endif  // RUNNER_SCREEN_CAPTURE_H_
