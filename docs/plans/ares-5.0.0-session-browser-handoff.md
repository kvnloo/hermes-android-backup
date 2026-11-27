# Session search and reading — 5.0.0 lane

**Base:** `cfebbfa8`. **Status:** partial F16/F26; no gateway modification, local inference, release or board transition.

| Job | Available | Boundary |
| --- | --- | --- |
| Find a chat | Active Classic Chats and the NextGen sidebar search loaded titles, IDs, previews and models on-device by default. The search-mode button offers full-text gateway search; a saved server choice merges authenticated dashboard FTS results with local matches. Snippets explain content-only hits. List metadata, pins and current row actions remain available. Queries are debounced; superseded responses and explicitly conflicting query/profile/identity metadata cannot populate a new search. | Searches the selected connection/profile, not all gateways. Missing/unsupported endpoint is not an empty result. No cross-profile fallback. |
| Find in this chat | The find control in the mounted chat steps case-insensitively through prompt/reply occurrences and seeks concrete rendered rows; it highlights glyphs where the text layout exposes the match. Ctrl/Cmd+F in chat is separate from Ctrl/Cmd+Shift+F session search. | Operates on loaded message text, not every unloaded page or hidden tool payload. If Markdown formatting prevents a glyph match, the row is marked instead. |
| Return to a turn | Loaded prompt timeline jumps to the actual transcript; Jump to latest restores end-follow. A settled reading distance is stored locally per surface, connection, profile and stored session. | Restoration is bounded by the available scroll extent; it does not scan unknown older history to recover a never-loaded turn. |
| Organise rows | Both browsers offer created/status/token/cost sorting, status grouping and optional model/usage metadata. Unknown usage is not zero; sorting by a missing metric is disabled. Classic also groups by project using its claim map. Pins remain ahead of groups. NextGen launch restore can be disabled without suppressing deep links. | No multi-gateway/profile grouping, NextGen project grouping, manual order, draft/PR filtering, per-row colours, general server auto-archive policy or external terminal launch. Organisation menu choices are view-local. New strings still need localisation. |

## Verification

`flutter analyze --no-pub --fatal-infos --fatal-warnings`: no issues. `flutter test --no-pub` across the following 12 suites: **227 passed** at `d72a16f1` (not the full repository suite):

```
test/session_search_client_test.dart     test/session_organisation_test.dart
test/workspace_sessions_screen_test.dart test/nextgen_machine_sources_test.dart
test/nextgen_cron_page_fill_test.dart    test/chat_history_widget_test.dart
test/chat_history_scroll_test.dart       test/nextgen_long_chat_test.dart
test/nextgen_chat_row_menu_test.dart     test/server_chat_pins_test.dart
test/chat_foldable_layout_test.dart      test/apple_adaptive_layout_test.dart
```

The new route tests exercise both 390- and 1050-pixel chat widths, duplicate matches in one turn, jumps to initially off-screen prompts and reading-position restore after remount. Existing narrow/wide shell, server-pin, copy-ID, focus, streaming and phone-layout coverage remained in the cohort. No native build or production API was used.

### Search repair verification

- **7/7 reproduced cases passed.** The two fixtures exercising remote results now opt in before searching. The oversized-page probe requires rejection of 61 results for limit 60 and keeps the returned-count assertion on an accepted 60-row page. The HTTP body is still decoded as JSON; the bound applies before creating any session or hit models, not to wire bytes.
- **31 additional tests passed** across `workspace_scope_loading_test`, `transcript_timeline_ownership_test`, `normal_gateway_fresh_chat_test`, `nextgen_unread_test` and `session_search_preferences_test`. Both active layouts were exercised with no saved mode, explicit local mode and a held gateway response. Changing to local hides remote content immediately, and the dashboard rechecks authorization before dispatch after login or a 401. It cannot recall a request already sent. The active layouts do not run the legacy AI query rewriter.
- A held NextGen read cannot undo a subsequent confirmed archive. A failed refresh drops previous server-only rows and snippets. Prompt and latest actions are both scoped to the timeline's reader; glyph selection ignores tool controls. Classic saved a nonzero reading distance under the newly bound stored ID, not the draft ID.
- The original keyboard/stream auto-follow assertion caught an over-broad reader reset during repair. The reader now uses the stable connection presentation registry and session ID, not the connection object instance. The original assertion passed in isolation and in the final cohort.

### Original lane verification notes

Three failures were isolated before rerunning the original cohort:

- The new Classic grouping fixture used the same text for the pinned row and section heading; the row now has a distinct title. The grouping and ordering assertions were retained.
- Stacking optional excerpts under NextGen titles removed their full-width layout constraint. Stretching the title column restores the exact existing phone geometry without suppressing excerpts or altering long-press actions.
- Classic correctly stayed at offset 80 through refresh/completion. A full-pane keyboard focus semantics node made the subsequent **Go to end** accessibility target the size of the viewport, so a tap at its centre missed the button. A non-semantic shortcut focus preserves the original button bounds. The original scroll test passes unchanged.
