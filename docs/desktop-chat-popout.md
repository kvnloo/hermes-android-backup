# Desktop single-chat windows

Call `openWorkspacePopout(context, sessionId: row.id, connectionId: connection.id, profile: connection.gatewayProfile ?? '', nextGen: nextGen)` from below `ParallelWorkspaceEntryHost`, for a **stored** row only. `supportsWorkspacePopout` gates the action. The API completes after the child reports its first chat frame or the parent shows a sanitized failure. It never navigates the main window as a fallback.

## Why a separate process?

Flutter 3.44.0's [`_window.dart`](https://github.com/flutter/flutter/blob/559ffa3f75/packages/flutter/lib/src/widgets/_window.dart) explicitly forbids production use and requires an experimental feature flag. `desktop_multi_window` 0.3.1 likewise uses a separate Flutter engine per window: it does not share Dart owner objects, and other plugins require secondary-engine registration. Its published README says MIT, but the **published archive's LICENSE is Apache-2.0**. Ares doesn't depend on or vendor that plugin.

Ares instead starts its own executable without a shell. Each child gets an ordinary OS window and the normal desktop plugin registration. macOS passes the marker to the Flutter project. Windows keeps the primary single-instance mutex; only the exact marker with inherited pipe input can open a child. Linux's GTK runner already forwards argv and uses `G_APPLICATION_NON_UNIQUE`. Nothing is installed or registered with the OS to launch a chat.

- **No account or chat data on argv.** The command line contains only `--ares-workspace-chat-v1`. One bounded, inherited stdin frame supplies the ID tuple and a per-launch check of the captured account. No endpoint, transcript, credential, or reusable sign-in token is serialized to the pipe. There is no network IPC listener or handoff file.
- **No alternate session.** The child reads just the selected saved account's credential bundle, independently verifies it against the parent and fetches exact storage metadata before mounting `ChatScreen` or `NgParallelChatPane`. Missing, ambiguous, remapped, or unqualified named-profile Classic API targets fail. Resume cannot create a new chat when the runtime binding is absent. `/new` and `/reset` cannot navigate to another chat in the pop-out.
- **Owner revocation.** Account mutation (including same-ID edit and rollback), interface/owner replacement, or changed sign-in invalidates the window. A covered or removed owner route also fails closed. The child exits when its parent's pipe closes. Work already accepted by a remote gateway is not implicitly cancelled or resent.
- **No parallel writes to the main app's drafts, activity receipts, or preferences.** Child preference writes stay in memory. Voice drafts, attachment caches, and preview scratch go to the child’s private temporary directory; the parent removes it after process exit. A parent or machine crash can leave temporary files for OS cleanup. The child does not run startup migrations, certificate staging cleanup, root routing, notifications, or browser-token rotation.

## User-visible limits

Pop-outs are independent gateway clients, not live mirrors of each other's unsent input or optimistic state. Unsent drafts, local presentation choices and pending markers in a pop-out do not survive its closure. The server remains authoritative for submitted messages; simultaneous sends from other clients remain subject to its concurrency controls. Refresh expired browser credentials in the main window and reopen. A second request for the same tuple reports that its window is already open rather than creating a duplicate. Desktop focus/placement follows the OS. No mobile or web window fallback is offered.

## Verification

```sh
flutter test --no-pub test/workspace_popout_test.dart
# macOS with a logged-in WindowServer, Flutter SDK and Xcode CLI tools:
python3 tool/popout_smoke/verify_macos.py
```

The macOS smoke compiles a small Cocoa host against the pinned prebuilt engine (not the signed Ares package). It runs the production launch/child bootstrap with in-memory credential/metadata fixtures and loopback-only history. For **both** interfaces it verified an exact transcript in the mounted chat widget, two distinct OS windows, and that same-ID revocation removes the child but not its parent. The [Linux check](linux-runner.md) separately exercised the actual menu in the extracted arm64 release bundle; [recorded output](evidence/workspace-linux-arm64-918aa506.txt).

**Windows native acceptance is still open.** On the available macOS host, `flutter build windows --release --no-pub` exited 1: `"build windows" only supported on Windows hosts.` No local Windows guest or MSVC/MSBuild was available. A Flutter Windows target override is not evidence that the real single-instance runner permits a child. On a disposable Windows desktop with the pinned Flutter SDK and Visual Studio C++ toolchain, build the complete runner; use an isolated fixture account to open both menus, split two chats, pop the selected chat onto a second display and verify the exact transcript and independent live updates. Check ordinary second launches still focus the primary, closing a child keeps the primary alive, and revoking its account closes the child. Check unpackaged and packaged activation after integration with the Windows notification lane. Do not use an installed personal Ares profile for this test.

No new resolved package or version is required. `path_provider_platform_interface` 2.1.3 and `shared_preferences_platform_interface` 2.4.2 (both Flutter Authors, BSD-3-Clause) moved from direct dev to direct runtime dependencies for their supported platform interfaces.
