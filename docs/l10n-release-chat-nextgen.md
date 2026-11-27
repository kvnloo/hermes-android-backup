# NextGen chat release localisation inventory

**Integration complete:** the parent consumed all seven registry entries into every catalogue and regenerated localisations. These are punctuation/placeholder-only templates, so no English vocabulary needs translation; supplied status/progress labels retain their existing translations. The verification requirements below are the original pre-integration checklist; final execution results are in [the consolidated report](l10n-release-chat.md).

Scope: `lib/nextgen/ui/chat_view.dart` only. Original line numbers below were captured before edits. The complete 5,087-line source and every non-comment string-bearing line were reviewed. Existing English words, labels, menus, tooltips, accessibility labels, status/error messages and approval/question/login controls already use `ngL` or `context.sharedL10n`; no remaining standalone hardcoded English prose was found. This pass extracts the remaining composed display patterns so translators can reorder their placeholders without changing the English output.

## Original display patterns (before edits)

| Original file:line | Original Dart literal(s) | New key |
| --- | --- | --- |
| `lib/nextgen/ui/chat_view.dart:2037` | `'$status — ${st.notice}'` | `ng_rel_chat_wake_status_notice` |
| `lib/nextgen/ui/chat_view.dart:2837` | `'\$${u.cost!.toStringAsFixed(4)}'` | `ng_rel_chat_cost_amount` |
| `lib/nextgen/ui/chat_view.dart:2843-2844` | `'${ngCompactNumber(u.contextUsed!)} / '` + `'${ngCompactNumber(u.contextMax!)}'` | `ng_rel_chat_context_ratio` |
| `lib/nextgen/ui/chat_view.dart:2875` | `'${state.label} ${state.reason}'` | `ng_rel_chat_connection_reason` |
| `lib/nextgen/ui/chat_view.dart:3253` | `'${item.text} · ${ngStamp(context, item.time!)}'` | `ng_rel_chat_notice_time` |
| `lib/nextgen/ui/chat_view.dart:3998` | `'${a.name} · ${ngL.ng_uploading_percent((a.uploadProgress! * 100).round())}'` | `ng_rel_chat_attachment_progress` |
| `lib/nextgen/ui/chat_view.dart:4454` | `'${runningTool.name}${runningTool.detail == null ? '' : ' · ${runningTool.detail}'}'` | `ng_rel_chat_tool_detail` (only when detail is non-null) |

Registry: `.dart_tool/chat-nextgen-strings.json`. Every entry has a description and explicit ICU String placeholders. Already formatted amounts/counts/timestamps and already localised labels are intentionally passed as String; numeric formatting and precision remain unchanged. The dollar sign retains the original currency convention (no currency conversion).

## Exclusions and existing coverage

- All already-localised messages are retained under their exact existing keys, including shared release-chat toolbar/preview/queue strings, attachment preparation errors, live-voice messages, elapsed seconds, tool durations and composer status/snippets.
- Wire/method/parameter identifiers, slash commands and arguments, tool names (`vision_analyze`, `image_generate`), voice mode/status tokens, approval answer tokens, MIME types, widget keys, render/cache identities and the internal `StateError('undelivered')` sentinel are not translated.
- Gateway/user/agent content (titles, prompts, replies, tool input/output/details, raw errors, question/choice text and incoming notices) remains verbatim. Localising a display envelope does not translate its content or alter outbound commands.
- Formatting-only whitespace, newline joins, dot separators in variable-length status/model lists, numeric-only interpolation, Markdown parsing regular expressions/fences and truncation ellipses remain literal; they contain no English words. URI serialisation is not display copy.
- Product names and protocol names are not translated. Comments are developer documentation, not UI copy.

## Verification and parent integration

No Flutter commands, Flutter tests, generation, inference or hosting were run in this worker. `dart format lib/nextgen/ui/chat_view.dart` passed; `git diff --check` passed. A Python check passed for all seven registry entries: exact equality with source key references, nonempty descriptions, matching ICU placeholder names and declared types, and sample substitution preserving all seven original English display envelopes. Parent must merge the registry into ARBs, translate, regenerate localisations and run analysis/tests before the new getters can compile. The registry is inside Git-ignored `.dart_tool`, so consume/copy it explicitly; it will not appear in a normal tracked diff. Concurrent preview-worker changes are outside this worker's scope and were not modified here.

Existing screen coverage found by source inspection includes `test/chat_release_l10n_test.dart` (shared toolbar localisation), `test/voice_l10n_test.dart`, `test/nextgen_read_aloud_test.dart`, `test/history_branch_confirm_widget_test.dart`, `test/canonical_rewind_layouts_test.dart`, `test/session_files_navigation_test.dart`, `test/workspace_workers_navigation_test.dart`, `test/appearance_review_regression_test.dart` and `test/appearance_contrast_walk_test.dart`. These were not executed. The existing chat release test's explicit message map does not include this new registry; parent should extend generated-message/locale coverage for the seven new envelopes.
