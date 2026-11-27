# Settings redesign

Worktree: `settings-reorganisation`, branch `v5/settings-reorganisation`, baseline `4a73b53e`. Inventory was committed first (`f5de82b2`); the implementation checkpoint is `fac598d9`, followed by the validation/fixes checkpoint recorded in the branch history. No dependency or preference schema changes.

## Navigation and ownership

`SettingsBrowser` takes an explicit `SettingsMode`; it never derives the experience from, or writes, `nextgen_enabled`. `SettingsScreen` supplies the shared and Classic catalog, and `NgSettingsPage` supplies its NextGen controls and owner-bound gateway actions. Scope filtering applies to both browsing and search. The one explicit interface switch retains its existing preference/service behavior.

Nine categories contain real controls: General & language; Appearance; Chat & sessions; Voice; Notifications; Device & shortcuts; Connections & models; Privacy & backup; About & help. Summaries show constituent controls and current interface, language, theme mode, or connection where applicable. Category selection stays within the settings route; Back returns to the catalog/search, then to the caller. Search retains its query, includes category and mode paths, and jumps to mounted control anchors. Shared presentation search/tour IDs are retained. Gateway/model/provider selectors continue to provide their existing nested controls and authority checks.

The existing desktop shortcut, palette `settings`, sidebar/More and drawer entrypoints remain intact. Both deep-link consumers now honor category paths; legacy `gateway`, `connection` and `shortcuts` aliases map to Connections or Device. Settings links never switch the active layout. Existing connection/profile ownership validation runs before consuming a deep link.

Shared controls continue to use the same stores: appearance/reading, text size, reply voice, auto-read, barge-in, notifications, native desktop integration, shortcuts, language and encrypted backup. Classic density, verbosity and source filters remain Classic-only. NextGen theme/accent/glow/black and return-to-gateway restoration remain NextGen-only. Model and provider administration are identified as gateway tools; existing More/tool entrypoints remain available. No updater was reintroduced.

`nextgen_reopen_last_chat` already existed. Its new label describes the actual behavior: it restores a chat when returning to a gateway, not on an ordinary cold launch. The existing landing behavior and explicit notification/link precedence are preserved.

## Presentation and safety

The category body is constrained to 840 logical pixels on desktop. Rows wrap, have at least 64dp height, and use 8/16px spacing. Classic inherits Hermes/Material; NextGen uses Ng typography, colors and surfaces. The NextGen Material bridge is rebuilt from the resolved NextGen/imported scheme so shared selectors, radio sheets, sliders, disabled ink and HermesTokens readers do not inherit Classic palette colors. Existing theme source and contrast guards remain intact.

NextGen theme selection is keyboard accessible with 48dp targets; accent buttons have localized tooltips and selected semantics. Shared dialogs and sheets inherit the enclosing theme. Large-text RTL tests exercise all nine categories at 320px. Backup headings and NextGen connection metadata now wrap correctly. Identity keys retain the selected category during theme rebuilds and reset connection-owned children when the owner endpoint/profile changes.

Gateway sign-out has its own danger group and existing confirmation. Backup import retains the existing passphrase, merge/replace choice and confirmation. Auth identity, connection-check progress/results and sign-out confirmation are generation guarded against owner changes. Native capability checks remain in their existing components. Android battery/background and embedded push controls now use the existing positive capability flags, including exclusion from Linux. Parked builds exclude voice and notification surfaces and skip the NextGen voice refresh.

## Inventory and localization

[settings-inventory.md](settings-inventory.md) records 147 stable IDs, original locations, intended groups, experience scope, persisted services/keys, owner/platform gating, migration status and live target group. The original 139 IDs are preserved; eight additional nested pet/radio controls were added during exercise. A checked-in baseline fixture verifies uniqueness, no lost IDs, scope, and mapping to the rendered per-mode catalog.

All eleven new strings are present in English plus all thirteen translated ARB variants in identical source order. `flutter gen-l10n` regenerated the localization sources. Existing Russian/Ukrainian plural warnings are unchanged.

## Verification

Private temp directory: `/Volumes/Storage/Hermes/scratch/settings-reorganisation-tmp`.

- `flutter analyze --fatal-infos`: clean.
- Focused settings/appearance/notifications/desktop/backup/deep-link/palette/models/session suites: **444 passed** (`focused-final.log`). Includes offline persistence, licenses, model/profile authority, actual palette/shortcut routes, Classic and NextGen category deep links, nested search/tour, keyboard theme activation, shared key round trips, stale identity, all categories at 320px/Arabic RTL (subsequently strengthened to 2.0x; see final verification below), and existing theme source/contrast checks.
- Platform regression batch after using positive Android capability flags: **34 passed** (`platform-tests.log`), covering Android/iOS/Linux/macOS/Windows plus existing background and desktop integration tests.
- `flutter test --no-pub --dart-define=ARES_PARKED_AUTOMOTIVE=true test/settings_platform_gating_test.dart`: **10 passed** (`parked-tests.log`).
- Screenshot harness: **8 scenarios passed**, producing **32 PNGs** (four real screens per scenario). See the capture directory below. Tests fail on layout exceptions and assert actual control identities; desktop native capabilities are synthetic method-channel fixtures.

The single self-review found and fixed theme-change category reset, narrow backup/connection overflow, non-keyboard theme selection, inherited Classic selector/disabled colors in NextGen, and Android-only controls on Linux. Older tests were adapted to tap categories before their existing behavior assertions; the obsolete Classic-only chip test was replaced with live separation/persistence coverage. No assertions were removed from model authority, notification, backup or native capability tests.

## Screenshots and limits

Captures: `/Volumes/Storage/Hermes/scratch/settings-reorganisation-previews`.

Reproduction:

```sh
HERMES_WORKSPACE_PREVIEW_DIR=/Volumes/Storage/Hermes/scratch/settings-reorganisation-previews \
TMPDIR=/Volumes/Storage/Hermes/scratch/settings-reorganisation-tmp \
flutter test --no-pub test/settings_screenshots_test.dart
```

The harness reuses the existing `theme_app_integration_test.dart` RepaintBoundary capture convention with real fonts and demo-only data. Matrix: Classic/NextGen × light/dark × Android phone 390×844/Linux desktop 1280×900. Each captures categories, appearance, notifications and device settings. `manifest.json` in the capture directory records dimensions and SHA-256 hashes. Representative images were visually inspected, including the corrected NextGen shared controls and desktop integration.

## Final independent verification

The final widget exercise passed **35 tests** (27 redesign tests and eight screenshot scenarios). It strengthens every category's 320px/Arabic RTL coverage to **2.0x text scale**. The capture helper now resolves missing component font families only in the rendered test paragraphs, preserving production sizes, weights, colors and explicit icon/brand fonts. It also enables real shadows. This removes the block-font artifacts observed in Classic segmented controls without changing application code.

Final sendable images and a dimension/SHA-256 manifest: `/Volumes/Storage/Hermes/workspace/ares-v5-lanes/settings-reorganisation-preview` (32 final PNGs: 390×844 phone and 1280×900 desktop). Eight baseline captures are retained in its `before/` subdirectory. Those baseline captures show the old layout; Classic's baseline capture used a generated light/dark scheme and had some test-font artifacts, so it is not a pixel-exact theme comparison.

All eight representative mode/brightness/device combinations were inspected using the vision tool, plus nested appearance, notification and desktop-integration screens. The missing Classic segmented labels were recaptured and explicitly rechecked as readable. No genuine horizontal overflow or collisions were observed. Normal scroll-viewport cutoffs are not counted as layout failures.

Subjective Refactoring UI screenshot review: baseline Classic **6/10** (information architecture only; test-font artifacts excluded), baseline NextGen **7/10**; redesigned Classic **8/10**, redesigned NextGen **8–9/10**. The visible improvements are navigable grouping, density reduction, explicit mode titles, consistent row hierarchy and themed nested controls. Remaining polish: desktop title/content-rail alignment, dense category summaries at narrow widths, and visual density of notification helper text. These scores are screenshot judgments, not automated accessibility certification; existing contrast/source tests remain the objective gates.

`flutter analyze --fatal-infos` passed again. All changed Dart files were formatted, `git diff --check` passed, and the localization checker reported all thirteen translated variants complete, source-ordered and placeholder/ICU-compatible.

### Complete final gates

The complete code/test tree was exercised at **`7dd8faed6b31cb20f7ecfada942fb19e4a636c32`**, with a clean worktree. The later evidence commit changes documentation only.

- Fixture-enabled full suite, excluding performance tags, serial concurrency 1: **8,618 passed, 0 failed, 0 skipped**, terminal `success=true`, exit **0**, **3,542 seconds**. Command: `flutter test --no-pub --concurrency=1 --reporter=json --exclude-tags=perf`.
- Separate serial performance-selector run: **29 passed, 0 failed, 0 skipped**, exit **0**, **5 seconds**. The selector was nonempty and selected `test/delivered_files_perf_test.dart` and `test/transcript_redaction_gateway_test.dart` by the exact `@Tags(['perf'])` marker; both complete files were exercised.
- Both runs enabled the actual fixture executables: `ARES_SSH_FIXTURE=/Volumes/Storage/Hermes/workspace/ares-v5-lanes/integration-fleet/build/fleet-ssh-fixture`, `ARES_TERMINAL_FIXTURE_HELPER=/Volumes/Storage/Hermes/workspace/ares-v5-lanes/pty/build/pty-tmp/ares-pty`, `ARES_TERMINAL_FIXTURE_PYTHON=/Volumes/Storage/Hermes/workspace/ares-v5-lanes/pty/build/pty-tmp/venv/bin/python`, `ARES_TEST_FFMPEG=/opt/homebrew/bin/ffmpeg`, and `ARES_TEST_FFPROBE=/opt/homebrew/bin/ffprobe`. Private `TMPDIR`: `/Users/sam.russell/.hermes/cache/scratch/ares-settings-verification/tmp/`.
- Machine-readable receipts: `/Users/sam.russell/.hermes/cache/scratch/ares-settings-verification/{full,perf}-summary.json` and corresponding `{full,perf}.jsonl`. Copies of summaries and compressed JSONL logs are retained beside the sendable screenshots in `verification/`. Counts are parsed from visible `testDone` events, excluding hidden setup/teardown events.
- Final `flutter gen-l10n`, changed-Dart formatting check (**37 files, zero changed**), full localization key/order/placeholder/ICU checker, `flutter analyze --no-pub --fatal-infos`, and `git diff --check`: all exit **0**; generated sources leave the worktree unchanged.
- The inventory contains **147 unique IDs** across nine groups: **116 shared**, **20 Classic-only**, **11 NextGen-only**. The model-placement regression test (`test/model_management_screen_test.dart`) and dependency manifests remain unchanged from baseline.

No remaining failing gate is known. These are deterministic widget captures and mocked native capabilities, not installer/device acceptance. Root search indexes category hosts and explicit local leaf targets; dynamic gateway model/provider choices remain in their existing nested selectors. No main/other-worktree changes, pushes, tags, publishing, installers, live gateways or live credentials were used.
