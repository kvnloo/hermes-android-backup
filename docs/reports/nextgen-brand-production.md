# NextGen brand production handoff

## Scope and source

- Local branch: `v5/brand`. Nothing pushed.
- Started from prototype `cdfdff56`; no-ff merge of current `feature/ares-v5.0.0` at `5a8cb170` is `558ad5a8`. Both histories are retained. No conflicts; ARBs did not conflict. Ran `flutter gen-l10n`.
- Tested implementation source: `1d86c582062c1bce63c9fe3da7516b07133c44eb`.
- Classic is unchanged. No new dependencies, settings, lifecycle listeners or hosting/inference.

## Behaviour

- Primary NextGen cold starts show the brand landing, including subsequent cold starts. No unrelated last chat is opened behind it.
- New chat, a Recent row or a selected sidebar/drawer chat leaves the landing. Open a chat exposes the drawer for selection. Android Back still opens/closes that drawer and does not restore the landing.
- Notification taps, validated Windows toast targets, notification approval actions, deep links, quick-entry hand-backs, Android share intake and launcher quick-chat actions bypass the landing. Existing target/connection/profile validation is preserved.
- The cold-start decision is owned above gateway-keyed content and navigator replacement. Switching connections is not a new cold start; historical per-connection reopening preferences remain compatible on those switches. Removed the misleading NextGen “Reopen last chat on launch” switch because cold starts now always show the landing.
- Pop-outs and parallel panes continue constructing their own chat views, never the primary landing.
- Share text is an editable draft, never sent automatically. Shared files enter the existing bounded, owner-scoped image/file draft pipeline.
- New-chat brand sits above the retained sparkle and `NgProjectGreeting`. Project selection preserves the draft and sends the selected `cwd` with `cwd_explicit: true` on first create.
- The brand uses the approved white tile, dark ring/glow, graphite-silver light wordmark and silver-white dark wordmark. Cinzel w700, tracking and optical left padding are preserved.
- Decorative wordmark text does not scale independently or get announced twice. The logo is announced once as “Ares”. Header sizing reserves room for scaled greeting text before choosing stacked, compact or hidden brand.
- Landing text is localised with three new `ng_brand_*` keys in all 14 ARBs (English plus 13 translations). Existing `ng_new_chat` is reused. Fixed artwork colours have exact, documented `theme_source_guard_test` exceptions; surrounding surfaces use theme tokens.
- Kept the small leading sidebar button on compact landing screens for discoverability; its position mirrors in RTL. Desktop already has the docked sidebar.

## Regression tests

New file `test/nextgen_brand_test.dart` covers cold launch instead of reopening, repeated cold launch, New chat, Open a chat + drawer selection, Recent selection, wide sidebar selection, notification tap, Windows toast target consumption, notification approval action, session/open/launch deep links, warm deep link, shared text, launcher quick-chat, secondary chat view, and four phone/desktop × dark/light project-picker tests with keyboard/composer bounds and first-send cwd assertions. It also covers 320×640 at 2× text in English and Arabic and one logo announcement.

### Every existing test file changed

No existing notification, catch-up, routing, project-create or layout assertions were removed or relaxed.

1. `test/theme_source_guard_test.dart`: **UI colours come from active tokens, not fixed branding or brightness** — adds exact brand-data exceptions with reasons; stale-exception checks remain.
2. `test/apple_adaptive_layout_test.dart`: **NextGen wide docked sidebar / unfolded/wide window docks the sessions pane** — asserts landing, starts a chat, then retains sidebar/search/toggle assertions. Other changes in this file are Dart formatting only.
3. `test/desktop_os_both_layouts_test.dart`: **wide NextGen opens command palette via button and shortcut, switches sessions by ID, and rebinds in NgSettingsPage** — asserts landing then starts a chat before testing its header palette button. All shortcut, routing and rebinding checks remain.
4. `test/nextgen_foreground_catch_up_test.dart`: shared `pumpMain` asserts landing, then explicitly opens the same stored fixture chat before these unchanged scenarios:
   - back in sight after the turn ended silently: reconcile, one reply, no resend;
   - back in sight with the session epoch: the exact replay finishes the turn;
   - back in sight while it still runs: keep the live reply, then finish it once;
   - back in sight while a newer turn runs: reload it, never continue the old reply.
5. `test/nextgen_notifications_test.dart`: shared `pumpMain` asserts landing then opens `s1` explicitly before:
   - a reply that lands out of sight notifies; back in sight takes it down;
   - a reply in sight, or a stopped turn, does not notify;
   - a failed turn out of sight notifies as a failure.
6. `test/nextgen_pane_resume_test.dart`: adds explicit no-landing assertions to all three existing real pane/pop-out flows:
   - a NextGen pane lists the connection's chats and, outside a workspace, opens the pick in place of its chat;
   - a NextGen workspace pane opens the pick as another pane of the workspace; its own pane stays;
   - a NextGen pop-out window opens the pick over its own chat; closing the pick goes back to it.
7. `test/nextgen_projects_test.dart`: shared `_app(main: true)` starts a draft from the landing when present; repeated pumps of the same already-open view do not restart it. All project/picker/cwd/draft/authority assertions remain. Affected cases (template variants included):
   - new chat greeting offers a project picker without replacing its draft;
   - picker send is explicit, hides after create and excludes folderless projects;
   - Home clears a pending cwd and sends neither cwd field;
   - held Projects never blocks typing and chosen cwd stays visible;
   - picker hidden with no projects / only folderless projects;
   - pending pick resets on connection / profile replacement;
   - greeting stays hidden on an existing empty stored chat;
   - browser and greeting reuse the exact same Projects repository;
   - late greeting list cannot restore an old scope cwd or choices;
   - root cwd keeps a nonempty greeting label while projects load;
   - project picker fits narrow phone at large text in en/de/ja/ru;
   - NextGen Files / Assets / project folder / chat attachment opens the same rich Markdown fixture (all five existing platform variants);
   - existing project chat uses the normal NextGen owner and route;
   - new project chat binds cwd on its first actual create;
   - folderless project cannot replace the open draft;
   - normal New chat clears Project cwd without creating a session.

## Final mockups and visual verification

Output: `/Volumes/Storage/Hermes/workspace/ares-v5-lanes/mockups/nextgen-brand/final/`.

- A1–A5: same phone, desktop and Android devices, dark/light.
- B1–B5: final new-chat screens. B2 is named `B2-newchat-phone-dark-approved-sparkle.png`: the rejected no-sparkle alternative is intentionally not a production mode.
- B6/B7: phone/desktop with the selected **Home project ⌄** picker visible.
- Two contact sheets: `contact-launch.png`, `contact-newchat.png`.
- The real widget harness loads Cinzel with `FontLoader`; the production TextStyle specifies Cinzel w700. Vision sees the matching letter-spaced serif ARES artwork (font identity itself is established by the harness/source, not pixels alone).
- Vision transcribed launch text: **ARES**, **New chat**, **Open a chat**, **RECENT**, **or pick a chat from the sidebar**; recent rows include **Plan the garden irrigation**, **Draft release notes**, **Summarise meeting notes**, **Trip packing list**.
- Vision transcribed new-chat text: **What should we work on?**, **Home project ⌄** in B6/B7, **Ask Hermes anything. It can run tools, browse and work in your files on the server.**, **Message Hermes**, **gpt-5**. Sparkle retained throughout.
- B4 hides the decorative brand, retains sparkle/greeting and keeps the focused composer entirely above the keyboard. Harness composer rectangle is `(19,403 355×48)` on the 393×852 phone; keyboard starts at y=516.
- No brand, landing, greeting, project-picker or composer clipping/overlap found. Full-resolution A4 check confirmed the partially visible sidebar chip is intentional horizontal scrolling; the fixed filter icon is fully visible. Light graphite-silver wordmark is readable on the light surface.
- Render harness: 13 tests passed, producing 12 device PNGs plus contact sheets; the extra test exercises drawer/Recent navigation without an image.

## Required gates

- `flutter analyze --no-pub --fatal-infos`: clean on the frozen source.
- Full non-perf `flutter test --no-pub -j2 --exclude-tags perf`: **8,336 passed, 0 failed, 0 skipped**, 635 suites, reporter `done.success=true`, process exit 0 (1,223.138 seconds).
- Serial perf files at `-j1`: **29 passed, 0 failed, 0 skipped**, 2 suites, reporter `done.success=true`, process exit 0 (6.583 seconds). Files: `test/delivered_files_perf_test.dart`, `test/transcript_redaction_gateway_test.dart`.
- Required combined test total: **8,365 passed**. These are disjoint non-perf and perf runs, not overlapping targeted-run totals.

Full-suite environment uses the task's exact SSH/PTY/Python fixtures, system ffmpeg/ffprobe, and `TMPDIR=$PWD/.dart_tool/full-tmp`. Initial exploratory runs are diagnostic only and are not claimed as completed gates. The final full-suite run is recorded separately in `.dart_tool/brand-full-final.jsonl`.

Native OS notification delivery, physical-device keyboard behaviour and store builds are not claimed by these widget/fixture gates; the downstream integration card owns the broader device/release acceptance checks.
