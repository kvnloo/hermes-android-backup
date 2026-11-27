# Windows notifications — 5.0 development

## What is sent

The Windows runner uses the Windows SDK (`Windows.UI.Notifications`), not a new Flutter plugin. Android and Apple continue to use `flutter_local_notifications` 18. Windows gets a generic, localized event description: no chat title, transcript, prompt, command, credentials, request ID, or approval buttons. Settings **Send test** bypasses the app's category preferences on purpose; it cannot override Windows policy or Do Not Disturb. Closing Ares does not run a background gateway or receive new events; Windows can reopen Ares for a toast it received earlier.

* **Direct distribution:** Inno installs the `com.hermesagent.ares` Start menu shortcut (AUMID + stub toast activator CLSID) and an `ares-notification:` handler in the installing user's profile. A loose executable refuses to post under an installed copy's identity.
* **MSIX:** the manifest declares `ares-msix-notification:`. Windows supplies the process identity; the notifier uses it without a hard-coded Store family name. The toast targets that package family. The two distributions do not compete for one URI scheme.
* **Click:** the only launch argument is a random 32-character lowercase hex ticket. The native runner checks the whole argument and forwards only the ticket to its own window. The shared service looks up a local, non-exported, bounded, three-day receipt, consumes it once, and checks the original account/profile binding. Replacements and cancellations invalidate previous receipts. Test toasts focus the app without opening any chat. A notification cannot answer an approval.
* **Presence:** off by default. When enabled, an open chat reports recent **in-window** input (pointer, keys, composer typing and focus) on its existing session socket only if its gateway acknowledged `client_activity: true` during `client.capabilities`. `client.activity` includes the runtime session ID, input age and alert eligibility, not input contents. Each report replaces the connection's whole statement, so one coordinator per app window reports, per socket, only the on-screen pane with the newest input (refreshed every 45 s, and at once when input follows 60 s or more without any) and withdraws with an empty session list as soon as that chat leaves view (another pane's newer input, a pushed route, a hidden pane or the app leaving the screen). Stale input is left to age on the gateway. `away: true` is never sent: the app has no lock or suspend signal. Pop-out windows report through their own socket; the main window can only turn their sharing off. No socket or remote session is created for presence. A phone notification plugin is needed on the remote side to do anything with these reports. The same opt-in is used on Android, Apple and Linux. It does not read another application's input.
* **Completion sound:** the same four names (`system`, `mail`, `reminder`, `silent`) are stored for every platform. Windows still plays `ms-winsoundevent` clips. Android and Apple play original short tones bundled as `ares_mail` and `ares_reminder` for those two names, and keep the platform default for `system`. Linux asks the desktop sound theme for `message-new-email` and `alarm-clock-elapsed`. The choice applies to a completed turn and the settings test, not to approvals or other kinds. While Ares is in front it also plays the choice in the app when a reply finishes (an in-memory chime for `system`), unless **Mute app sounds** is on. A chat open in both the main window and a pop-out (a separate process) plays that cue in one window only: the pop-out while it holds presence for the chat (newest input there, in front, sharing on) and the main window does not, otherwise the main window when it shows the chat, otherwise the pop-out. The main window decides and tells the pop-out over its stdin (`{"cue":"main"}` or `{"cue":"popout"}`); after ready the pop-out reports its presence on stdout. The tones come from `lib/core/services/completion_tones.dart`; `dart run tool/generate_completion_sounds.dart --check` confirms the bundled WAVs match.

## Verification on SAM-GAMING

The production source at `9a6a4f07` was archived, SHA-256 checked on the Windows host and built with Flutter **3.44.0**, Store-flavour `ARES_PLAY_BUILD=true`. The unsigned MSIX was unpacked again: application ID `Ares`, registered protocol `ares-msix-notification`, and byte-identical executable and AOT payload. Inno Setup compiled the direct installer against that unpacked payload. Neither production artifact was installed or published.

| Production artifact | SHA-256 |
|---|---|
| `ares.exe` | `c58c3a50f6640022e836563b56754d44a2d2174c2c68d32e901f4404211d6035` |
| `data/app.so` | `02f610a3d6e5509d8c85cf21b502b5fb03023b68578cd1a7877525003c0e83f7` |
| unsigned MSIX | `39c2abaa30420de5b6ed03ca475d2c113a7661236d3d4b4872012d6c5e392ab6` |
| direct installer | `c4cf057f5e69d8621a880ad40bae942010cf9d98b78fab0076980aab2e7c3238` |

**Unpackaged runtime:** `tool/windows_toast_probe.dart` ran in the interactive desktop session with a separate executable, AUMID, per-user shortcut, protocol, product name and preferences. Only the registration identifiers and Dart entrypoint were changed for this probe. It used the production WinRT backend, runner IPC and Dart ticket sink. It made no network connections or real account reads. A fresh sender initially failed with `0x80070490` from `ToastNotifier.Setting` before its first submission. After the bootstrap fix, a second *fresh* sender reported permission `true` and posted on the first attempt without priming its history from another program.

| Evidence | Result |
|---|---|
| Windows notification history | `GetHistory` returned group `AresTurns`, tag `515347699`, body `Input needed`, activation type `protocol` for the warm test. |
| Active | Shell-opening the URI read from OS history delivered `qa-active` to existing probe PID `45096`. |
| Minimized | Shell-opening the warm URI restored and foregrounded that PID (`GetForegroundWindow == MainWindowHandle`); delivered `qa-warm`, `qa-connection`, profile `qa`. Reopening the same URI produced no second route. |
| Terminated | After that probe exited itself, shell-opening the cold URI launched PID `45404`; `initial=true`, `qa-cold`, same connection/profile. |
| Cancellation and cleanup | Group history count after cancel: **0**. Independent readback: no probe process, test shortcut, URI handler, settings directory, uninstaller, scheduled task or test package remained installed. |

**This is OS delivery and protocol activation, not evidence of a physical banner/body click.** Windows UI Automation exposed no identifiable fixture notification card to invoke on that desktop. No other window or notification was clicked. The native probe verified routing data; separate Flutter root tests opened the Classic `ChatScreen` and checked the NextGen connection and saved session. They do not substitute for a native click into the shipped UI.

**Packaged runtime remains open.** Windows rejected registration of the distinct unsigned MSIX fixture with `0x80073CFF` (no applicable license/sideloading policy). The system was left unchanged: no developer mode, trust certificate, policy, signing or security changes. A successful package build is not a delivery or activation test.

## Automated checks

On the Mac, `flutter analyze --no-pub --fatal-infos` was clean and the focused notification, navigation, permission, presence, NextGen and socket suites passed (188 tests). On Windows, the four Windows-specific Flutter suites passed (10 tests); the strict URI parser also passed as a standalone MSVC test. The Flutter tests use synthetic services and are separate from the real Windows history and shell evidence above. The release-wide, all-platform test matrix was not run in this lane. `pubspec.lock` and the Android, iOS and macOS runners are unchanged.

## Routing repairs after the native probe

An account edit now revokes its outstanding Windows navigation tickets **before** credentials or metadata are changed. Restoring the previous credential value does not restore the tickets. An alert without a confirmed runtime-to-stored-session mapping is focus-only. A Windows attention post that finishes after the user returns to the app withdraws its ticket and OS notification rather than opening an obsolete chat.

The focused Dart tests are `test/windows_toast_attention_regression_test.dart` and `test/windows_toast_sink_test.dart`. Run `python3 tool/windows_notification_tests/verify_cold_activation.py` for separate issuing and consuming Flutter processes: a synthetic unchanged account may navigate after restart, an edited-and-restored account cannot. These use synthetic preferences/channel state, not a Windows shell. The native artifact hashes above remain historical evidence for **9a6a4f07**, not for the repaired source.

## Ticket ledger integrity (gate fix after 555789a1)

The 555789a1 gate found that Classic's background **Response complete** toast was posted with a ticket that never stayed in `windows_toast_tickets_v1`, so clicking it did nothing (3/3, MSIX and direct). Cause, reproduced in `test/windows_toast_classic_background_ticket_test.dart` against the real root, normal owner and sink: settlement starts an operational-activity write whose `prefs.reload()` snapshot predates the new ticket. When that reload completes after the ticket write, it rolls the ticket out of the process-wide `SharedPreferences` cache, and the next ledger write (the root withdrawing the chat's ongoing entry) persists the ledger without it. On Windows, `shared_preferences_windows` serves `reload()` from its in-process cache, so the plugin store always holds the accepted ticket; only the Dart cache was stale.

* Every ledger read/modify/write (`show`, `cancel`, `cancelAll`, activation) reloads under the ledger lock before reading.
* Once the runner's `show` is invoked, the sink assumes the toast may be on screen. Any later failure cancels that id natively; if the native cancel fails, the ticket is put back rather than leaving a dead toast. Toasts evicted from the bounded ledger are cancelled.
* The runner's `Show` never throws after `ToastNotifier.Show`. It replies `shown`, `blocked` (the post-Show setting is not `Enabled`; the sink withdraws the toast and reports a failure) or `unknown` (the setting read failed; the toast keeps its live ticket).
* Only the primary window writes the ledger. Pop-out children run on an in-memory preference store seeded with the selected connection and appearance keys, and the runner registers no toast channel for them.
* The last 50 notification attempts are stored under `notification_attempts_v1` (kind, id, outcome, error class; never titles, bodies, tickets or message text) and shown under **Recent notifications** in both Classic and NextGen Settings. Windows clicks are logged as `activation` `opened`, `focused`, `skipped` or `failed` `UnknownTicket`, so a dead toast on a later native run can be told apart from a failed post (`PlatformException(windows_toast 0x…)`).

## Remaining release gate

On a Windows desktop with an existing trusted test-install path and a visible notification center, use two disposable connections/profiles with overlapping session IDs. For **both** installed forms and **both** layouts, physically select the test session's toast while Ares is active, minimized and closed. Confirm one correct session, focus on the correct window, no action taken, and no route from a repeated, withdrawn, expired or edited-account ticket. Repeat with Windows notifications blocked (and restored by the tester), master off, category off, a quiet completion sound, and an attention event. Check OS history separately from banners (Do Not Disturb can suppress banners). Confirm the optional phone plugin reacts to activity on the intended test gateway only. Do not sign, ship, or mark WIN/F36 fully verified from the fixture or widget results above.
