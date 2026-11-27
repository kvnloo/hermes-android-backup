# Markdown table layout

## Root cause

`RichPieceView` intercepted Markdown tables *before* the styled `MarkdownBody` renderer. `ResizableMarkdownTable` then rendered every cell as raw `Text`, in independent `Row`s with fixed **96 px** columns, no padding and no borders. Three columns occupied only 288 px even on desktop; emphasis markers remained literal; multiline cells did not share a row-height/grid contract. Classic also capped the whole transcript/composer host at 800 px and inset ordinary bubbles using the screen width rather than making table content use its pane.

The original five-width regression failed before implementation. Real-widget before captures reproduce the narrow unformatted table in Classic and NextGen. Baseline capture source is retained under the ignored `build/` directory; it removes the new layout assertions solely to capture the old production widgets, not to claim a passing regression.

## Implementation

- One shared `Table` with fixed, explicitly budgeted columns draws all horizontal/vertical grid lines, aligns multiline row heights and emphasizes headers. Border/header colors come from the active `ColorScheme`, including imported themes; no black/white constants.
- Short tables fill the incoming pane width. Budget columns at 160 logical pixels for short labels and 240 for longer content; sample at most twelve source rows per column. Respect text scaling. No intrinsic-width measurement or whole-table `TextPainter` passes.
- Wider tables scroll horizontally instead of compressing every column into a fraction of the phone. A persistent horizontal scrollbar and bidirectional-arrow affordance indicate overflow. The scroll viewport remains within the supplied constraints. Touch/trackpad scrolling and scrollbar mouse dragging use Flutter's normal scroll infrastructure.
- Existing header resize handles remain, with a resize cursor and RTL-aware drag direction; user sizes survive appended streamed rows. Schema changes clear incompatible column overrides. The minimum resized width is 144 logical pixels times text scale; maximum is 640 times scale.
- Cell contents reuse each caller's existing Markdown callback: Classic/NextGen link routing, inline code, bold, colors and inherited selection behavior remain intact. No new inline parser or link launcher.
- The table-bearing Classic bubble uses its pane minus 4 px margins and 8 px padding. Ordinary bubbles retain their narrow cap; prose inside a table-bearing reply remains capped. Move the Classic 800 px cap from the whole host to ordinary bubbles and the composer so tables can actually use wide panes.
- Pipe splitting handles escaped pipes before inline parsing, including GFM's escaped-pipe-in-code rule. Optional outer pipes are supported. Existing fence splitting remains authoritative; incomplete body rows are padded safely during streaming.

## Consumer inventory

| Surface | Behavior |
| --- | --- |
| Classic assistant/user message rich-prose blocks | Shared resizable grid; table-bearing bubble uses pane width |
| NextGen assistant rich-prose blocks | Same grid, existing themed Markdown callback and reply-wide SelectionArea |
| Classic Select text dialog | Same grid, dialog-constrained horizontal scrolling, one SelectionArea |
| Markdown file previews, including delivered/generated `.md` files opened through file preview | Same grid via tables-only splitting; source toggle and preview truncation stay intact |
| Delegated-task transcript non-tool rows (both layouts) | Same tables-only grid and one SelectionArea; no chat directive execution |
| Tool-call arguments/results, reasoning disclosures, NextGen user plain-text messages | Intentionally plain text, not Markdown table consumers; unchanged |
| HTML/SVG artifact cards and sandbox HTML previews | Existing safe text/vector renderer, not Markdown tables; unchanged |
| Fenced Markdown/code artifact source | Remains literal code with its existing copy/wrap UI, never reinterpreted as a table |

`tablesOnly` parsing lets document/delegation/selection surfaces adopt the grid without enabling rich chat directives or remote previews.

## Tests and visual evidence

`test/table_layout_test.dart`: 24 cases. Actual viewport/table/cell rectangles, per-pane confinement inside a 1440 px host, 320/390/640/768/1440 px panes, light/dark, RTL plus 2× scaling, nonempty visible grid sides, row count/alignment, short-table fill, scroll extents, resize persistence and schema updates, selection registrar, bold/code spans, escaped pipes, fenced code, and Markdown file preview directive isolation.

`test/table_preview_test.dart`: 40 cases using real `MessageBubble` and `NgChatView`, not a replacement UI. Both modes at the same five widths × light/dark × normal/RTL+2×. Checks viewport width/confinement, minimum column widths, formatted text and tappable link recognizers. Classic captures are production-component previews; NextGen captures mount its actual chat view. These are not native-device or store screenshots.

`test/table_classic_screen_test.dart`: six additional real-route checks. Five mount the complete Classic `ChatScreen` in 320/390/640/768/1440 px panes inside a 1440 px screen and assert table viewport width/confinement, guarding against reintroducing the ancestor 800 px cap. One mounts a delegated transcript with an actual table and checks the shared grid and SelectionArea.

The first complete sweep found one real regression: changing the selection wrapper for *all* delegated prose rows disturbed lazy report expansion restoration (`delegated_background_message_test.dart`, first case). Pristine release head passed; the initial table commit failed reproducibly in isolation. The bounded review fix preserves the exact original MarkdownBody for non-table delegated rows and introduces the table layout only for actual table-bearing prose (fences excluded). No report/pin behavior or existing test assertion was weakened. The original eviction regression and six route checks passed together after the fix; the complete gate was then restarted on the fixed tree.

Optional capture command:

```sh
TABLE_PREVIEW_DIR="$PWD/build/table-previews/after" \
  flutter test --no-pub -j1 test/table_preview_test.dart
```

Capture mode loads actual Geist/GeistMono assets, system prose/mono fonts and MaterialIcons. It is optional and macOS-specific; ordinary tests need no host font files. All data is fictional Cedar/Maple project comparison content. No screenshots of private user content, live gateways, installs or clipboard operations.

Evidence directory (ignored, owned by this worktree): `build/table-previews/` with `before/`, `after/`, `classic-contact.png` and `nextgen-contact.png`. Both sets contain phone 390 px and desktop 1440 px initial/scrolled views. On desktop the full table already fits; initial/scrolled are intentionally equivalent. Phone clipping is intentional *inside* the horizontal scroll viewport; the scrolled frame reveals the assessment column.

Visual review: before **3/10**, after **8/10** for table readability/hierarchy. Confirmed full available horizontal width, visible grid, styled text and phone scroll recovery. Remaining tradeoff: wide phone tables cannot show every column simultaneously; no frozen first column or column-snapping behavior is added. Short fictional conversations leave empty transcript space. Not native hardware accessibility certification.

## Verification receipts

Base: full release-repair head `8a848fdce003e968f72f7e0f627c88dabaca2f1a` (fast-forward merge, not a cherry-pick). It includes all CI, Linux async-save and Automotive navigation repairs supplied by the release lane.

- Fatal-info analyzer: passed, zero issues (`flutter analyze --no-pub --fatal-infos`).
- Final focused table/render/chat-density/Markdown-preview/delegation cohort: **157 passed, zero failures or skips**, terminal `success=true`, exit 0.
- Final fixture-enabled full suite, serial concurrency 1 and excluding `perf`: **8,688 passed, zero failures or skips**, terminal `success=true`, exit 0; subprocess wall time **2,358.304 seconds**. This includes all seventy new regressions. No existing assertions or performance thresholds were weakened.
- Separate serial performance run: **29 passed, zero failures or skips**, terminal `success=true`, exit 0; subprocess wall time **4.777 seconds**. The exact fixed-string `@Tags(['perf'])` selector asserted a nonempty, exact two-file list: `test/delivered_files_perf_test.dart` and `test/transcript_redaction_gateway_test.dart`. Host load immediately before performance: **5.22 / 10.70 / 10.52**.
- All final commands ran on clean implementation/test commit **`e3c5f308586a902a757d81d1f99f33eeba3c4d55`**. The later receipt commit changes this document only.
- Actual SSH, PTY and FFmpeg fixture executables were enabled at the common integration-fleet/pty worktree paths, with `TMPDIR=/Users/sam.russell/.hermes/cache/scratch`; no fixture tests were skipped.
- Machine-readable retained evidence: `build/table-gates/{focused,full,perf}.json`, corresponding `*-summary.json`, `final-exits.json`, `perf-selector.json`, `perf-load.txt`, analyzer and expanded logs. `first-full.*` retains the initial failed sweep rather than overwriting its result. `run-final.py` records the exact commands and tested head.
- Final changed-Dart formatting and `git diff --check` pass; release-repair head is an ancestor. No native builds/installations or publication were attempted.

No dependencies, platform registration, release identity, app installs, push/tag/store or publication changes. Physical mouse/keyboard/trackpad/touch and native selection handles still require device acceptance; widget tests verify layout, Flutter scroll-controller behavior and selection registration rather than pretending to exercise OS input hardware.
