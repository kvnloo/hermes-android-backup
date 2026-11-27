# Desktop OS integration (native runners)

Windows, macOS and Linux runners implement a small set of platform channels for the primary window. Dart owns every policy decision (whether a feature is on, menu text, what an action does); the runners draw native UI, register OS hooks and report events. Every feature is opt-in and off by default, and child window processes (pop-out chat, companion, quick entry) never construct any of it.

Dart: `lib/core/desktop/`. Settings: **Desktop integration** card in Classic Settings and NextGen Settings → Interface (desktop only).

## Shell: tray / menu-bar icon — `com.hermesagent.ares/shell`

| Direction | Method | Arguments | Result |
| --- | --- | --- | --- |
| Dart → runner | `setTray` | `{enabled, closeToTray, tooltip, items: [{id, label, checked?, separatorBefore?}]}` | `bool` icon actually shown |
| Dart → runner | `showWindow` | — | — (show, restore, focus the primary window) |
| Dart → runner | `quit` | — | — (runner closes the primary window after replying) |
| Dart → runner | `isTraySupported` | — | `bool`: a tray host this runner can use is there now |
| Dart → runner | `allowForeground` | `{pid}` | `bool` (Windows: `AllowSetForegroundWindow(pid)` for the quick-entry child; others not implemented) |
| runner → Dart | `onTrayAction` | item `id` | — |
| runner → Dart | `onTrayStatus` | `bool` shown | — (the icon appeared or went away after `setTray` answered) |

- Settings asks `isTraySupported` (and the hotkey's `isSupported`) before offering anything: where the answer is no, the card shows one disabled row with the reason instead of the tray, close-to-tray and hotkey switches and the **Change** button, so no switch only fails after it is turned on. Nothing is shown for a control until its runner has answered. The same holds in Classic and NextGen Settings (one shared card).
- Item ids are `[a-z-]{1,32}`; labels are cleaned of control characters and bounded (64 characters, tooltip 127). At most 16 items. Unknown ids from the runner are ignored by Dart.
- Menu: Open Ares, New chat, Quick entry… (when available), Pause notifications (checked while the notification master switch is off), Quit Ares. A left click (Windows, Linux) shows the window; macOS opens the menu.
- **Close to tray** is a second opt-in. It only applies while the icon is actually shown: Windows hides on `WM_CLOSE` only with an installed icon; Linux only while the icon is shown (the StatusNotifierItem is hosted, or the XEmbed icon is embedded); macOS keeps the app running after the last window closes and a Dock click or the menu brings it back.
- Windows: `Shell_NotifyIconW` (version 4). A wanted icon is re-added on every `TaskbarCreated` (Explorer restarted, or it was not ready when `setTray` first asked at sign-in, even if it was never installed), and a failed `NIM_ADD` is also retried on a short backoff timer (1, 2, 4, 8, 15 and 30 s, `TrayRetryDelayMs`); when it works Dart hears `onTrayStatus`, and close-to-tray applies from then on. The menu runs with `TrackPopupMenuEx` over a snapshot of the items taken when it opens, so a `setTray` that lands while it is open cannot remap the chosen command to another action. No new activator, COM server or instance path; toast activation is unchanged ([windows-notifications.md](windows-notifications.md)). A second launch still focuses the hidden window through the existing mutex path.
- macOS: `NSStatusItem` with a template SF Symbol.
- Linux: a **StatusNotifierItem** (`org.kde.StatusNotifierItem` with a `com.canonical.dbusmenu` menu, `linux/runner/status_notifier.cc`), implemented over GDBus with no new library. It works on X11 and Wayland wherever the shell hosts one: KDE Plasma, GNOME with the AppIndicator/KStatusNotifierItem extension, Xfce, MATE, Cinnamon, Budgie, LXQt and wlroots bars (waybar). The item owns `org.kde.StatusNotifierItem-<pid>-<n>`, registers with `org.kde.StatusNotifierWatcher` whenever one appears (a shell restart re-registers it), shows the bundle icon as `IconPixmap` (22, 32 and 48 px), and keeps each menu item's dbusmenu id for the process lifetime, so a click on a menu the host built earlier still names the action it showed. Only on X11, and only while no watcher hosts the item, the fallback is the XEmbed `GtkStatusIcon` (a `_NET_SYSTEM_TRAY_S<n>` tray host); a StatusNotifierItem that comes up later removes the XEmbed icon, so there are never two. `isTraySupported` is true when a watcher reports a host or an XEmbed host runs. Showing is asynchronous, so `setTray` answers `true` only once the icon is shown (it waits at most 2.5 s, then answers `false`); a later change is reported with `onTrayStatus`. Without either (plain GNOME on Wayland, for example) Settings shows one disabled row. `tool/native_tests/linux_sni_check.sh` runs the item against a fake watcher and host on a private D-Bus.

## Quick entry (HUD)

A small always-on-top window for typing a prompt into a chosen chat or a new one. Opened from the tray, the global hotkey, or **Quick entry** in the command palette (Classic and NextGen).

- It reuses the pop-out child machinery: the primary starts the same executable with `--ares-quick-entry-v1` (Windows launch role `quick_entry`, which requires a parent pipe on stdin and must be the only argument), sends one launch frame through `watchPopoutPipe` (≤ 2 KB: up to 12 recent chats `{id, title}` and the app locale), and the child exits when the pipe closes. The child owns no connection, credentials, tray, hotkey, toast routing or instance mutex.
- The child writes `ARES_QUICK_ENTRY_READY_V1`, then at most one line `{"prefill": text, "session": id|null}` and exits. The primary accepts only a chat id it offered and text up to 4,000 characters, then shows the main window and routes `hermes://session/<id>?prefill=…` or `hermes://open/chat?prefill=…` through the validated deep-link router. The hand-back belongs to the connection and gateway profile whose chats were offered when the window opened (`HermesLinkOwner`, captured with the chat list; the child never sees or returns it, and no `hermes://` URL can carry one): only that owner's Classic workspace or NextGen main page consumes it, and the app root brings that shell forward (NextGen switches its connection; Classic opens the workspace unless one is mounted). If that connection is gone, or now talks to another profile, the text is kept as a new draft in whichever chat list is showing, never put into another connection's chat. **Nothing is sent**: Enter in the window only puts the text in the composer; Shift+Enter adds a line; Escape closes.
- Showing it while it is open closes it (toggle). Windows activation stays primary-only: no second activator, COM server or `WM_COPYDATA` path. Right after starting the child, Dart sends its process id to the shell's `allowForeground {pid}`, and the primary (which holds the foreground right just after the hotkey press or the tray menu choice) calls `AllowSetForegroundWindow(pid)` for that one process, never `ASFW_ANY`. Other runners ignore it.
- Placement: Windows centres it on the monitor under the pointer, a fifth of the way down, `HWND_TOPMOST`; macOS uses a floating window on all Spaces (also over full-screen apps); Linux keeps it above, centred, without a taskbar entry.

## Global hotkey — `com.hermesagent.ares/hotkey`

| Direction | Method | Arguments | Result |
| --- | --- | --- | --- |
| Dart → runner | `isSupported` | — | `bool`: this desktop lets an app register a global shortcut (Linux: X11 only) |
| Dart → runner | `register` | `{key, meta, ctrl, alt, shift}` (`key` in `shortcuts_store` names, e.g. `space`, `keyK`) | `registered`, `conflict`, `unsupported` or `invalid` |
| Dart → runner | `unregister` | — | — |
| runner → Dart | `onHotKey` | — | — |

- Opt-in (off by default) and remappable in **Desktop integration → Quick entry shortcut**. The default is Cmd+Shift+Space on macOS and Ctrl+Shift+Space on Windows and Linux. A press toggles quick entry.
- Dart checks a chord before the runner sees it: it needs Cmd, Ctrl or Alt; the Windows/Super key is refused on Windows and Linux; a short list of system chords is refused (Spotlight, app switching, Task Manager, lock screen …); and it must not equal an in-app shortcut, including the Ctrl form of an uncustomized Cmd shortcut on Windows and Linux. Rebinding an in-app shortcut onto the hotkey releases the hotkey. The runner reports a chord another app owns as `conflict`.
- Unregistered when turned off, before a remap, when Dart disposes, and by the runner when the primary window goes away (exit).
- Windows: `RegisterHotKey` on the primary window with `MOD_NOREPEAT` (`ERROR_HOTKEY_ALREADY_REGISTERED` → conflict); after `WM_HOTKEY` only the quick-entry child it starts may take the foreground (`allowForeground` with its pid).
- macOS: Carbon `RegisterEventHotKey` (no Accessibility permission needed; `eventHotKeyExistsErr` → conflict).
- Linux: a passive `XGrabKey` on the X11 root window, also covering Caps Lock and Num Lock (`BadAccess` → conflict). libX11 (MIT), already a GTK 3 dependency, is linked directly. Wayland has no app-registered global shortcut, so `register` returns `unsupported` and Settings says so; the XDG GlobalShortcuts portal is not used.

## Wake / sleep and keep-awake — `com.hermesagent.ares/power`

| Direction | Method | Arguments | Result |
| --- | --- | --- | --- |
| Dart → runner | `isSupported` | — | `bool` |
| Dart → runner | `setAwake` | `{owner, enabled}` | — |
| Dart → runner | `isLocked` | — | `bool`, or `null` when the runner cannot tell (Linux only; others answer not implemented) |
| runner → Dart | `onPowerEvent` | `suspend`, `resume`, `lock` or `unlock` | — |

- Events feed `SystemSleepGate` (`lib/core/services/system_sleep_gate.dart`). While the computer sleeps **or** the session is locked, every `DesktopGatewayClient` (Classic) and `NextGenGateway` closes its live socket and stops redialling; calls fail fast instead of dialling. Waking onto the lock screen keeps the pause until unlock.
- The pause fails safe: it never outlives the user's return. Focus coming back to the primary window, a pointer press or a key press in it lifts the pause (`SystemSleepGate.noteUserActivity`), and every `resume` re-reads the lock state with `isLocked` (a definite `false` lifts the lock; `null` keeps it until the user is back in the window). So a lock whose unlock is never reported cannot leave the sockets paused until restart.
- A Classic dial already in flight when the pause begins (ticket being minted, or the WebSocket upgrade under way) checks the gate again once the ticket arrives and once the socket connects: it closes the socket and fails instead of leaving it live during the pause, and the wake reconnects it.
- On resume a client that had a live socket reconnects; the new socket re-binds stored sessions with `session.resume`, and NextGen chats reattach through `reconnected`. Classic normal-chat recovery is held while paused and runs again on resume. **No prompt is sent again**: an in-flight submission is reconciled from history by the existing recovery journal. A NextGen socket the user stopped stays stopped; an idle Classic client dials lazily on its next call.
- Keep-awake (Off / While working / Always): Windows `SetThreadExecutionState(ES_CONTINUOUS | ES_SYSTEM_REQUIRED)`; macOS `IOPMAssertionCreateWithName(kIOPMAssertionTypePreventUserIdleSystemSleep)`; Linux an xdg-desktop-portal `Inhibit` request with the *suspend* flag (released with `Request.Close`), or without a portal `org.freedesktop.ScreenSaver.Inhibit` (released with `UnInhibit`); both calls are asynchronous (never a blocking D-Bus call on the UI thread), and an answer that arrives after the last owner let go is released at once. None of the desktop ones keeps the display on. Android (`MainActivity`) sets `FLAG_KEEP_SCREEN_ON` and iOS (`SceneDelegate`) `UIApplication.isIdleTimerDisabled`, so phones and tablets call it **Keep screen on**. Runners release the request when the window goes away.
- `isSupported` is true only where it works; Settings (Classic and NextGen) shows the card, and its section header, only then. Linux answers asynchronously: true when the portal implements `org.freedesktop.portal.Inhibit` (its `version` property can be read, which also starts an activatable portal and fails without an Inhibit backend) or a service owns `org.freedesktop.ScreenSaver` right now. A name that is merely activatable does not count.
- Dart (`KeepAwakeController`, owned by `HermesApp`) releases the request when the turn ends however it ends (finished, failed, cancelled), when the app is paused (background) or detached (exit), and takes it again on resume while still wanted. A minimised desktop window reports `hidden` and keeps it, so a long turn can finish while you are away.
- It is also released while the computer sleeps or the session is locked (`SystemSleepGate`): the sockets are paused, so a turn that ends meanwhile is never seen and a "while working" request would otherwise stay held until unlock. After the pause it is taken again only once the turn is known to still run: chats that had a running turn when the pause started hold `SystemSleepGate.holdReconcile` (Classic `NormalGatewayChatOwner`, NextGen `NgChatController`) and release it once they have read their state again (Classic recovery's resume/history read or settlement; NextGen re-attach and catch-up), which bumps `SystemSleepGate.reconciled`. A turn seen to end or start after the pause also counts. "Always" has no turn to wait for and is taken again as soon as the pause lifts.
- Windows: `WM_POWERBROADCAST` (`PBT_APMSUSPEND`, `PBT_APMRESUMESUSPEND`/`PBT_APMRESUMEAUTOMATIC`) and `WM_WTSSESSION_CHANGE` (`WTSRegisterSessionNotification`, links `wtsapi32.lib`).
- macOS: `NSWorkspace` will-sleep/did-wake and session resign/become active, plus the `com.apple.screenIsLocked`/`Unlocked` distributed notifications.
- Linux: logind `PrepareForSleep` (system bus) for suspend/resume. The lock state comes from its two sources of truth: the session's `LockedHint` property (`PropertiesChanged` on `org.freedesktop.login1.Session`; the session is found with `GetSessionByPID`, or `GetSession("auto")` for a process started outside one) and `ActiveChanged` from `org.freedesktop.ScreenSaver` / `org.gnome.ScreenSaver` (session bus); the session counts as locked while either says so (`LockTracker`, `desktop_os_logic.h`). logind's `Lock`/`Unlock` signals are only requests (`Unlock` follows `loginctl unlock-session` alone; swaylock, i3lock and `IdleAction=lock` unlock locally), so they only trigger an asynchronous re-read of both sources. A locker that sets neither `LockedHint` nor a screensaver state does not pause the sockets. GIO only; no new library.

## hermes:// links — `com.hermesagent.ares/deeplink`

| Direction | Method | Arguments | Result |
| --- | --- | --- | --- |
| Dart → runner | `getInitialLink` | — | the launch link, once, or `null` |
| runner → Dart | `onDeepLink` | the whole link (string) | — |

Every runner only bounds a link (scheme `hermes:` in any case, at most 16 KiB, no control characters) and hands the whole string to Dart's validated router (`lib/core/services/hermes_deeplink.dart`). A link can navigate and prefill a draft; it never sends, approves or installs anything. A link that arrives before Dart has asked for the initial one waits in the runner (the latest wins). Primary window only.

- **Android:** `VIEW` intent filter (`DEFAULT`, `BROWSABLE`, `scheme="hermes"`) on `MainActivity` (`singleTop`): cold from the launch intent, warm from `onNewIntent`. Flutter's built-in route push is off (`flutter_deeplinking_enabled=false`); the app has no named routes for links.
- **iOS:** `CFBundleURLTypes` (`hermes`), `FlutterDeepLinkingEnabled=false`; `SceneDelegate` reads `connectionOptions.urlContexts` (cold) and `scene(_:openURLContexts:)` (warm) into `AresDeepLinkInbox` (`apple/AresApple.swift`).
- **macOS:** `CFBundleURLTypes` (`hermes`); `AppDelegate.application(_:open:)` feeds the same inbox (created before launch finishes, so a cold link waits) and shows the main window. A child window process (pop-out, companion, quick entry) ignores links.
- **Windows:** the Inno installer registers `HKCU\Software\Classes\hermes` (task **Open hermes:// links with Ares**, on by default, since Hermes Desktop uses the same scheme) and the MSIX manifest declares `hermes` next to `ares-msix-notification`. `ClassifyLaunch` accepts a link only as the sole argument (`LaunchRole::deep_link`, `deep_link.h`); it never reaches Dart's entrypoint arguments. A second launch forwards it over the existing single-instance path to the **primary** window class with `WM_COPYDATA` (`dwData` `'ARLK'`; toast tickets use `'ARES'`), like toast tickets: no second activator, COM server or window class. The primary restores itself and passes the link to Dart.
- **Linux:** `linux/packaging/com.hermesagent.ares.desktop` (`MimeType=x-scheme-handler/hermes;`, `Exec=ares %u`), installed into the bundle's `share/applications`. The primary is a unique `GApplication` with `G_APPLICATION_HANDLES_OPEN` (children stay non-unique): a link launch while Ares runs reaches the primary's `open` over D-Bus; otherwise that launch becomes the primary. A second plain launch activates the running primary the same way and exits without a window, so it never adds a second tray icon or hotkey; the primary shows its window again, also when it was closed to the tray. See [linux-runner.md](linux-runner.md#hermes-links).

## Screen capture — `com.hermesagent.ares/capture`

| Direction | Method | Arguments | Result |
| --- | --- | --- | --- |
| Dart → runner | `status`, `requestPermission` | — | `{supported, permission}` with `granted`, `denied`, `prompt` or `not-required` |
| Dart → runner | `openSettings` | — | `bool` (macOS privacy pane) |
| Dart → runner | `capture` | `{directory}` | PNG path inside `directory`; errors `cancelled`, `permission-denied`, `unsupported`, `failed` |

- **Capture screen** in the attach sheet of both composers (Classic and NextGen), offered only where the runner's `status()` reports `supported` (asked when the sheet opens; `screenCaptureOffered`), not merely on a desktop OS. The capture becomes an ordinary image draft through each composer's existing attachment path; the user reviews it and presses Send. **Never auto-sends.**
- Dart creates a private `ares-capture-*` folder, accepts only a non-empty PNG (signature checked, ≤ 25 MB) inside that folder, and removes the folder once the draft has its own copy or the capture is rejected.
- macOS (14 or later): `CGPreflightScreenCaptureAccess`; the first request shows the system prompt (`CGRequestScreenCaptureAccess`); afterwards Ares explains the Screen Recording setting and opens it (`x-apple.systempreferences:…Privacy_ScreenCapture`). The capture is the frontmost on-screen window of another app (no Ares process: main, pop-out, companion, quick entry), or the main display without Ares' windows, via ScreenCaptureKit `SCScreenshotManager`. macOS 13 reports `unsupported`.
- Windows: Windows Graphics Capture with the system `GraphicsCapturePicker` (the picker is the consent; the user chooses a window or display). One frame is copied to a staging texture on a worker thread, made opaque and written as PNG with WIC; results return to the UI thread as window messages. Links `d3d11`, `dxgi`, `windowscodecs`.
- Linux: xdg-desktop-portal `Screenshot` with `interactive: true` (the portal dialog is the consent and lets the user pick screen, window or area). The portal's file is copied into Ares' folder; the desktop's own copy stays where it saved it. No portal → `unsupported`.

## Checks without an app build

- `tool/native_tests/ios_typecheck.sh` — type-checks `ios/Runner/SceneDelegate.swift` (keep-awake and deep-link channels) and `apple/AresApple.swift` against the iOS SDK and the real Flutter.framework from the Flutter cache (a declarations-only stub when the cache is absent), warnings as errors.

- `tool/native_tests/run.sh` — host C++17 unit tests (including `windows/runner/deep_link.h` through `launch_role.h`) (`clang++ -std=c++17 -Wall -Wextra -Werror -pedantic`) for the platform-free headers `windows/runner/desktop_os_logic.h` and `linux/runner/desktop_os_logic.h`.
- `tool/native_tests/macos_typecheck.sh` — type-checks the macOS runner Swift against the macOS SDK and a declarations-only FlutterMacOS stub, with warnings as errors, then again against the real FlutterMacOS framework from the Flutter cache together with `apple/AresApple.swift`.
- `tool/native_tests/linux_compile_check.sh <flutter-gtk-dir>` — compiles the Linux runner sources (`-fsyntax-only`) against Debian 12 GTK 3 and the engine's `flutter_linux` headers in a network-less container.
- `tool/native_tests/linux_sni_check.sh` — builds `status_notifier.cc` with a test harness in the same container and runs it under `dbus-run-session`: a fake `StatusNotifierWatcher` and host register the item, read its properties and dbusmenu layout, click items (including with an id from an older layout), activate it, and restart the watcher.
- The Windows runner files that include `windows.h` need the Windows SDK: build on the Windows host (`/W4 /WX`).
