# Ares 5.0.0 localisation release pass

## Status

This is a **partial release pass**, not an assertion that every UI string in
`lib/` is translated. Work is local on `v5/l10n`, based on `9794eeb3`; nothing
has been pushed. See [the residual source inventory](l10n-release-remaining.md)
for the exact English expressions that still need work.

### Completed catalogue work

- Filled all **2,615 initially missing translations**: de, es, fr, ja, ko, pt,
  pt_BR, ru, zh and zh_Hans: 224 each; uk: 187; ar and zh_Hant: 94 each.
- Extracted **607 additional messages** with descriptions and typed placeholder
  metadata: shared discovery/admin/files/workspace (461), NextGen navigation
  and status (44), chat (35), preview (59) and application shell (8).
- Translated all extracted messages into every one of the **13 locales**.
  Each catalogue now has **3,234 messages**, in the English source's order.
- Preserved every original English value and metadata entry byte-for-byte as
  JSON values; source messages were added, not rewritten.
- European Portuguese and Brazilian Portuguese remain separate; zh and
  zh_Hans are Simplified Chinese, zh_Hant is Traditional Chinese.
- Regenerated `app_localizations*.dart`; generation reports no untranslated
  messages. Pre-existing Russian/Ukrainian redundant plural-branch warnings
  remain outside the new-message set.

### Completed screen areas

- Transcript Find, prompt timeline and chat organisation menus.
- Classic/NextGen chat toolbar and overflow menus, including **More chat tools**,
  **Session files**, **Find in transcript**, **Open browser preview** and
  **Gateway queue**; sender/accessibility labels and several client notices.
- Session files, Git review, image recovery and project controls.
- Fleet, updates, cloud/webapp navigation, queues, schedules and memory graph.
- Parallel workspace, pop-outs and shell navigation/health/discovery notices.
- Preview consent, reader controls, local errors, request logs and annotations.
- NextGen navigation, catalogue/attachment failures and age/duration labels.

Shared widgets use `context.sharedL10n`; NextGen-only additions use `ng_` keys.
The remaining English inventory below is a **pending requirement**, not an
exception to the release criteria.

## Discovery consent

`sessionSearchIdentity` now uses a versioned structured key containing the saved
connection ID, gateway/API/dashboard endpoints and exact profile selector. A
null profile is not guessed to mean an explicitly chosen `default` profile.
Duplicate saved connections to the same host do not share consent.

Legacy gateway-wide permissions are **not migrated**. The supplied local Desktop
snapshot, attributed by its audit appendix to
`b7ee21c14e38316273f88d8ed112491ba1c87d15`, does not establish equivalent migration:

- `apps/desktop/src/app/chat/sidebar/use-server-session-search.ts:13–55` captures
  the selected profile and fences search completion on cleanup.
- `apps/desktop/src/api/sessions.ts:449–460` sends a profile-scoped search.
- `apps/desktop/src/api/sessions.test.ts:342–354` checks the `research` profile.
- `apps/desktop/src/api/client.ts:625–664` keeps connection/profile request owners.

The source snapshot is under
`/Volumes/Storage/Hermes/workspace/ares-hermes-desktop-audit-20261125/desktop`.
It is not a Git checkout; the commit attribution comes from the adjacent audit
appendix, not a newly resolved HEAD. Each newly scoped Ares browser starts with
on-device search and must explicitly opt in again.

Consent writes are serialized and fail closed until physical readback. Stale
permission/authentication/search completions cannot borrow a new browser's
owner. Held grants are withdrawn only on their captured original key. A retained
NextGen input is cleared when its search owner changes, matching the model's
cleared query. Both layouts have permission, non-migration and adverse-order
regressions in `session_discovery_consent_layouts_test.dart`; persistence has
separate unit cases.

## Deliberately retained English and identifiers

These are not missing translations:

| Category | Retained values / locations | Reason |
|---|---|---|
| Brands and formats | Ares, Hermes, Hermes Desktop, Hermes Cloud, GPT-Live, Kanban, MCP, SSH, MSIX, WebRTC, OpenAI, Claude, Codex; JSON, HTML, HTTP(S), Git, HEAD, Markdown; font-family names | Product/protocol/format identities remain recognisable and must not change. |
| User/server content | Messages, session/project/file names, model/provider IDs, paths, snippets, page content, annotation notes, remote logs and remote diagnostic details | Ares does not translate user content or invent translations of server output. Client-authored fallback sentences are **not** covered by this exception. |
| Executable examples | `hermes dashboard --host 0.0.0.0`, `hermes curator restore`, `@file:` and other CLI/RPC syntax | Translation would make commands, references or protocol payloads invalid. |
| Storage/wire/test IDs | Map keys, RPC methods, preference keys, widget keys, enum codecs, status-matching tokens, MIME types, regexes, PEM markers | Stable implementation contracts, not display copy. Known status labels in changed surfaces are mapped separately. |
| Numeric/symbolic data | Ordinals, match counts, percentages, Git `+/-` statistics, dollar values, coordinates, reference line ranges and separators | Not English prose; this pass does not redefine existing numeric/currency formatting. |
| Registry compatibility metadata | Const built-in labels in `workspace_registry.dart` and `render/plugin_slots.dart` | Rendered through localisation mappers; fallback descriptor identifiers are preserved for extensions. |
| Agent-facing instructions | The Git workspace-shipping prompt and generated commit-message content | Task payload to the agent, not UI chrome. |
| Hidden control-flow diagnostics | `Playback unavailable`, `Test remote transport does not upload files`, `Not used for a catalog install.`, `undelivered`, `No crop`; parser diagnostic getters | Caught and replaced with localised notices, test-only invariants or compatibility contracts. Preview failures carry typed codes and are localised when rendered. |
| Debug-only diagnostics | `debugPrint`, assertions such as `No NgScope above this widget`, unused-operation/state sentinels | Never intended as user-facing copy. |
| Notification diagnostic records | Attempt kinds/outcomes, reference IDs, platform error codes | Raw diagnostic codes; the two app-authored NextGen reasons are mapped to localised copy at rendering. Other client-authored prose is listed as pending, not exempted. |
| Recognition markers | `[System:`, `IMPORTANT`, tool names and protocol-role metadata in verbose message details | Transcript parsing/diagnostic identity. Normal visible sender labels are localised. |
| Keyboard identifiers | Cmd/Meta, Ctrl, Alt, Shift, LTR/RTL | Conventional key/direction identifiers; surrounding descriptions are localised. |
| OS application identity | `Ares — Chat` pop-out title | Application identity retained; chat navigation and notices are localised. |

Unknown server-supplied status codes remain verbatim for diagnosis, inside
localised guidance where available. Locally authored errors such as
`SessionSearchException.message`, configuration/import summaries and terminal
notices are **not** server content; their remaining occurrences are explicitly
listed in the residual inventory.

## Validation

- `flutter pub get --offline --enforce-lockfile`: passed.
- `flutter gen-l10n`: passed; no missing messages.
- `dart run tool/check_l10n_placeholders.dart`: passed for all 13 locales.
- `tool/check_l10n_placeholders.dart` is exercised by
  `test/l10n_placeholders_test.dart`; it checks complete source-ordered keys,
  placeholder names/types, supplied placeholder metadata, and new-message ICU
  branch selectors/nesting.
- All changed Dart files were formatted; `git diff --check` passed.
- `flutter analyze --no-pub --fatal-infos`: passed, no issues.
- Focused validation: **291 passed**, 22 files, including every `*_l10n_test`,
  `nextgen_gaps_test`, locale smoke/placeholder tests and discovery-consent tests.
- Full-suite initial run: **8,333 passed, 24 failed** across 641 non-perf test
  files. These are visible JSON `testDone` results; hidden loading and
  setup/teardown hooks are excluded. The 24 failures were corrected without
  weakening their assertions; the complete 14-file affected subset then passed
  **159 tests**. Fixes included consent fixture scoping, exact localised
  provenance/chooser expectations, retained specific file/delivery refusals,
  compact navigation labels, an embedded-sheet l10n fallback and responsive tip
  banner actions.
- Fresh full-suite rerun: **8,357 passed, 0 failed**, 641 non-perf test files,
  on fixed app source `95035859a66f07eaefb6795ab5239a821ba4d37f` (26m 40.809s).
  `done.success` is true and the process returned 0. Counts come from unique,
  non-hidden JSON `testDone` events; two legitimate test names start with
  “loading” and must not be mistaken for hidden loader events. The command was
  `flutter test --no-pub -j2 --exclude-tags perf --reporter json`.
- [Machine-readable validation evidence](l10n-release-validation.json) records
  the commands, exact source commit, fixture environment, catalogue inventory
  and raw-log paths. The prescribed SSH, PTY/Python and ffmpeg/ffprobe fixtures
  and worktree-local `TMPDIR` were used. No local Hermes service or model
  inference was started. Only documentation changed during the full rerun.
- This green suite does **not** close the remaining legacy extraction work.
  All current catalogue keys are translated, but the additional client-authored
  English inventoried in `l10n-release-remaining.md` still requires extraction
  and translation into all 13 locales before the entire task can be completed.
