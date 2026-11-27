# Audio attachment previews

## Audit at 49d29803

Audio **recordings** already had a separate voice-draft player (`local_voice_recorder.dart` and the recording controls). That did not provide playback for files selected with Attach, drop, paste, gateway-file references, or assistant deliveries.

| Surface | Before | Now |
|---|---|---|
| Classic picked-file composer | Generic document tile, no player | Local cached draft preview below its tile |
| NextGen picked-file composer | Filename InputChip, no player | Named audio controls next to the existing draft chips |
| Classic user messages | File clients explicitly disabled for user bubbles; optimistic rows retained names, not references | Audio `@file:` references resolve through the chat's file client, including optimistic sent rows |
| NextGen user messages | Stored `@file:` paths reduced to display filenames | Preserve original reference text; resolve stored and newly attached audio through the owning gateway |
| Classic/NextGen assistant media cards | Audio icon and Download/Share, but no playback | Lazy inline player; the shared preview dialog also handles audio |
| Server Files browser | Audio went through the text-only preview and showed a binary/unavailable message | Lazy shared audio controls with existing Download fallback; preview transfer is streaming-bounded even when the browser's Save client is unbounded |
| Classic/NextGen Session files pane | Verified workspace documents had a text-only binary placeholder | Shared media card with bounded owning-gateway fetch, playback and Download/Share |
| Assets and recovery inspectors | Shared card/dialog had no audio branch | Inherit audio support from the shared widgets |
| NextGen delivered inline links | Root-owned sheet could outlive its originating reply | Shared owner-bound preview route; reference removal, owner replacement or disposal closes it |
| Recorded voice, live voice, TTS | Existing independent workflows | Unchanged |

The missing audio branch in `AttachmentPreviewDialog` and missing composer wiring were the main causes. This was not a missing playback dependency: pinned `audioplayers` 6.8.1 and its five native plugins were already installed. No dependency was added or upgraded; no GPL/AGPL dependency was introduced. No existing cross-attachment player arbiter was found; attachment sessions now serialize play claims and pause the previously playing attachment.

## Behavior and boundaries

- Play is always explicit. Mounting a composer/card/dialog does not create an audio player or autoplay. A delivered file is fetched only by an explicit playback/preview/download action.
- Play/Pause, replay after completion, real duration/elapsed position and seek use the existing native player. Unknown duration is not invented. Decode failure is sanitized, retryable, and leaves remote Download/Share available.
- Extension candidates include the existing gateway audio formats (MP3/M2A/WAV/Ogg/Opus/M4A/FLAC), plus AAC/AIFF/CAF/WMA when supplied by a file-browser entry or local file. Recognized local MIME values can identify extensionless picks. The gateway's `MEDIA:` parser contract/allowlist is unchanged. A candidate does **not** guarantee native codec support.
- Composer previews read a bounded snapshot of the **app-cached** draft, then stage a separate owned native source. They do not upload, submit, clear, rename or modify the draft. Removing the draft cannot delete an active native player's staged source. Composer controls keep their draft and owner identity across reorder/progress rebuilds.
- Remote refs are never passed to `File` or the native player. Existing `AttachmentController`/`RemoteFilesClient` performs the authenticated, profile/session-scoped, bounded transfer. Native sources have generated app-private names, not gateway URLs/paths or credentials. URI-like `@file:` inputs are not converted to client-local paths.
- In-memory playback is capped at the existing **25 MiB** preview budget for both remote and local sources. Media-card Download/Share retains the existing larger-file streaming fallback; the server Files screen keeps its original Download action. A rejected local preview leaves the original draft intact and sendable/removable; it does not add a new composer file-export workflow.
- Owner/reference replacement and disposal synchronously revoke commands and late completions. Teardown joins staging, native initialization and playback commands, then native disposal, **before** deleting the exact owned file/directory. Timeout displays an error but does not pretend native initialization was canceled. Unsettled initialization or failed native disposal retains the locked source rather than deleting under a possibly live reader.
- App inactivity, a covering route or a disabled ticker subtree pauses audio; returning never resumes it automatically, including when the original Play was still loading. The most recent Play gesture wins, not whichever download finishes last. Different attachment previews arbitrate their own players; a closing owner remains a stop barrier until confirmed native disposal. A permanently failed native disposal fails closed for subsequent attachment playback until process restart. Existing voice/TTS/radio services are not changed or silently stopped by this feature.
- Controls are native Flutter buttons/sliders with tooltips/semantics and fit a 320px/2x-text fixture. Error and audio-position strings are present in all 13 shipped locales (including regional/script ARB files).

## Verification

`test/audio_preview_presence_test.dart` intentionally uses only base-revision APIs. In a disposable detached worktree at `49d29803`, both tests ran and failed on missing playback controls (not compilation). The same tests pass with this feature.

Additional regressions exercise the real Classic and NextGen composers via file intake, the real user/assistant history widgets, optimistic Classic sent-file references, the NextGen inline preview route, file retrieval with profile/session parameters, no autoplay, play/pause/replay/seek, loading/error/retry, narrow/large-text controls on all five platform variants, draft removal, owner A→B→A during held retrieval, held read/stage/play/initialization/disposal, failed native disposal, popup/app suspension, single-player arbitration and actual bounded local staging.

Native smoke entry: `tool/audio_attachment_probe.dart`. It never loads Ares main/profile code: it generates a private 2-second silent WAV, sets volume to zero, stages through the production audio session, seeks/plays/pauses/disposes and checks removal. A macOS debug build and native run succeeded: duration **2000 ms**, position after seeking/playing **654 ms**, zero retained staging entries. This was an **ad-hoc, unsandboxed probe artifact only**, to allow its explicit managed-scratch root; the first sandboxed attempt correctly returned `PathAccessException` for that external scratch path. No shipping entitlement/source was changed, no installed app or Windows app/data was touched. The existing Darwin plugin also emitted a duplicate-method-response warning during the successful run; the smoke result proves the tested muted WAV path, not every codec or release sandbox/GUI behavior.

Native Android/iOS/Windows/Linux decoding and audible GUI playback have **not** been exercised here. Their controls/wiring use the same shared Dart path and installed native plugins, and five-platform widget variants are adapter-mocked tests, not native playback proof. Format support ultimately follows MediaPlayer/AVFoundation/Windows media/GStreamer availability.

Final fatal-info analysis is clean, and the final focused run passed **189 visible tests across 18 files**, with zero failures or skips. The locale validator reports all 13 locales complete.

Independent read-only review identified two lifecycle races (a skipped queued pause during close, and an initial held Play borrowing resumed permission); both were reproduced and repaired, and targeted recheck passed. The file-surface review then identified same-owner/same-route workspace runtime replacement. The final repair combines synchronous binding invalidation with a completion-time target fence; four real-loopback regressions cover both layouts with held downloads and already-playing audio while proving owner and route stay unchanged.

The full `--exclude-tags perf` invocation completed with **8,530 passed, 1 failed and 2 skipped** across **655 files**. Its sole failure was the historical `render_review_blockers_test.dart` assertion that audio must have no slider. That assertion was reconciled with the implemented behavior: seek exists but stays disabled until real native duration is available, and no fake speed/position controls appear. The owning test file and the two FFmpeg-gated cases were then run with real local FFmpeg/FFprobe paths: **21 passed, zero failed/skipped**. SSH and PTY fixtures were enabled during the full invocation. No production source changed after that full run. A second entirely green full-suite invocation after the expectation-only test edit was **not** run; the original full-run failure is retained rather than relabeled as a pass.

Commands, source hashes, exclusions, fixture configuration, review scope and exact run counts are recorded in `audio-attachment-validation.json`.
