# Release localisation, part D: chat, preview and terminal

## Baseline and scope

- Branch: `v5/l10n-chat`, based on `feature/ares-v5.0.0` at `6521d11d`. Local only; nothing pushed.
- Read the first-pass inventory at `../l10n/docs/l10n-release-remaining.md` before work. Its exclusions describe the first-pass lane, **not the final merged base**: the supplied base already includes `release_chat_*`, `ng_release_chat_*` and `release_preview_*` extraction and all 13 translations. In particular, the listed More chat tools / Session files / Find in transcript / Open browser preview / Gateway queue examples are already localised. Do not duplicate or rename those keys.
- Audited `lib/core/screens/chat_screen.dart` (13,314 original lines; all 757 non-comment string-bearing lines and 162 direct UI sink candidates), `lib/nextgen/ui/chat_view.dart` (5,087 original lines), and all five files in `lib/core/preview/`.
- **`lib/core/terminal/` does not exist at this base.** Terminal implementations live elsewhere (including `lib/core/workspace/terminal_page.dart` and `ssh_terminal_dialog.dart`), outside this card's explicit write ownership. They are listed by the first-pass inventory for the other lanes; no files outside the assigned directories were changed.

## Inventory before conversion

The two detailed inventories record original file:line literals and their treatment:

- [NextGen chat](l10n-release-chat-nextgen.md): seven remaining composed display templates, now `ng_rel_chat_*`.
- [Preview and terminal](l10n-release-chat-preview.md): two annotation display templates, now `rel_chat_preview_*`, plus all diagnostic-only English exclusions.

All nine templates contain only punctuation/currency symbols and supplied placeholders, not standalone English vocabulary. They are now explicit catalogue entries, allowing translators to control placeholder order and presentation without editing Dart.

### Classic chat audit (no source change needed)

Line numbers refer to `6521d11d`, before any edits.

| Original location in `lib/core/screens/chat_screen.dart` | Literal or presentation site | Treatment |
| --- | --- | --- |
| 10377, 10423, 10453, 10514 | Find in transcript / Open browser preview / More chat tools | Existing shared `release_chat_find_in_transcript`, `release_chat_open_browser_preview`, `release_chat_more_tools` |
| 10383–10385, 10429–10431, 10524–10526 | Session files / Gateway queue | Existing shared `release_core_session_files_view_session_files`, `release_core_gateway_queue_screen_gateway_queue` |
| 3615–3638 | Markdown export headings, outcome text and tool records | Headings/outcomes already localised; Markdown syntax and tool data remain unchanged |
| 4324 | `Playback unavailable` | Internal `StateError`, immediately caught at 4326; user sees existing `read_aloud_is_unavailable_on_this_device` at 4335, not the diagnostic |
| 4373, 4381 | `$_sessionTitle: $summary` | User title plus already-localised summary; punctuation-only composition |
| 4411, 4441 | `${context.l10n.approval_needed} — $_sessionTitle`, `${context.l10n.input_needed} — $_sessionTitle` | Already-localised notification headings, verbatim user title |
| 4900 | `404`, `not found` | Error matching tokens, not rendered copy |
| 5382 | `tool` | Fallback tool identity; preserve protocol/tool identifiers |
| 7054 | `/handoff $platform` | Slash-command notice identifier; preserve command/argument |
| 7539 | `undelivered` | Internal sentinel; translated error presentation already exists |
| 8052 | `Test remote transport does not upload files` | Test-only transport invariant, not production UI |
| 8100, 8290 | `[${context.l10n.attached_file}: ${file.name}]` | Existing localised attachment label, exact filename; bracketed attachment representation unchanged |
| 9071 | `Not used for a catalog install.` | Unused client-factory invariant on the catalog-install path; not a rendered message |
| 11905 | `${_receivedOutcomeLabel(fact.outcome)} · $provenance` | Existing localised outcome/provenance composition |
| 13115 | `${MaterialLocalizations.of(context).formatFullDate(localTime)} · $clockTime` | Flutter-localised date/time; no app-authored English |
| 13120–13133 | `role`, `unknown`, `null`, raw `${entry.key}: $value` metadata | Verbose protocol inspection: retain raw field names, role/enum values and null representation per task rules; not human-facing prose labels |
| Throughout | Imports, map keys, event names, MIME types, regexes, widget keys, draft/owner IDs, commands and empty strings | Non-display identifiers/syntax; unchanged |

No remaining standalone app-authored English prose was found in this file's literal inventory. Existing upstream/user/gateway messages are not translated as if they were app copy. This is an audit of owned source, not a claim that every possible gateway response is in the selected language.

## Catalogue integration and language treatment

- Added **9 keys** with descriptions and explicitly typed placeholders to English and all **13 target catalogues**: `ar`, `de`, `es`, `fr`, `ja`, `ko`, `pt`, `pt_BR`, `ru`, `uk`, `zh`, `zh_Hans`, `zh_Hant`.
- Entries are appended in the same English source order in every catalogue. Generated Dart localisations are included.
- Read nearby translated `release_preview_comment_number` and `ng_uploading_percent` in every locale. Annotation number markers follow the existing glossary: Spanish/European Portuguese `n.º`, French `n°`, Brazilian Portuguese `nº`, Russian/Ukrainian `№`; the other catalogues retain their existing `#` convention. Simplified and Traditional Chinese remain separate explicit entries.
- The seven NextGen envelopes contain no English vocabulary to translate. Their punctuation-only forms are intentionally identical where appropriate, while all supplied labels/status/progress text continues to come from the locale's existing translations. The existing dollar currency convention, four-decimal precision and compact-number formatting are preserved, not reinterpreted as currency conversion.
- User notes, filenames, notices, page content and tool identifiers/details stay verbatim inside placeholders. English output is unchanged, including null-versus-empty detail behavior.
- Shared preview widgets use `context.sharedL10n` (or its build-local alias), so they work when NextGen omits the app delegate. No service acquired a BuildContext dependency.

## Deliberately retained English and technical text

The literal English exclusions are enumerated in the Classic table and preview inventory. They are caught/test-only invariants, diagnostic match tokens or diagnostic compatibility getters, not UI prose. Existing preview UI resolves structured reasons through shared translations, including unknown errors. Preserve these tokens to avoid breaking diagnostic matching/tests.

Also retain wire/enum/capability values, request keys, signatures, commands, filenames, product names, remote/user/agent content and developer logs. Do not translate them or silently mutate outbound payloads. Raw verbose metadata is deliberately a protocol inspector. No new untranslated English sentence was added to an ARB.

## Verification

All commands ran in this worktree against the committed implementation:

| Gate | Result |
| --- | --- |
| `flutter pub get --offline --enforce-lockfile` | PASS |
| `flutter gen-l10n` | PASS; generated Dart committed |
| `dart format` on the three changed production Dart files and new test | PASS |
| `flutter analyze --no-pub --fatal-infos` | PASS, **No issues found** (rerun after adding the tests) |
| `dart run tool/check_l10n_placeholders.dart` | PASS: all 13 locales have complete source-ordered keys and matching placeholders/ICU structure |
| `flutter test --no-pub test/chat_remaining_l10n_test.dart` | PASS, 3 tests |
| Combined covering-screen and localisation run, `flutter test --no-pub --reporter=json <189 files>` | PASS: **2,821 visible tests**, no failures, errors or skips; final machine `done.success=true`; exit 0 |
| `git diff --check` | PASS |

The combined run includes every top-level `test/*l10n*_test.dart` (22 files, including the new test), `nextgen_gaps_test.dart`, and every recursive test file matching the owned screen/preview widget or service names/imports. The selection expression was `\b(ChatScreen|NextGenChatScreen|ChatView|NgChatView|ChatPreview|ReaderCanvas|PreviewConsoleLog|PreviewError|ReaderDocument)\b|screens/chat_screen.dart|ui/chat_view.dart|core/preview/`. The deduplicated 189-file manifest was compared in code with all 189 actual machine suite records: exact equality. The 2,821 count excludes 197 hidden load/setup/teardown events; component runs were **not** added to the combined total. Elapsed machine run time: 267.43 seconds.

Local execution evidence (not tracked): `.dart_tool/chat-test-files.json`, `.dart_tool/chat-tests.jsonl`, `.dart_tool/chat-test-summary.json`, `.dart_tool/chat-gen.log`. Reproduce with the selection above, sorting/deduplicating paths before passing them as separate arguments to `flutter test --no-pub --reporter=json`.

The new tests check explicit values/generated output and typed placeholders in all 14 catalogues, exact English display output, and the same retained reader pin through en/ar/de locale changes without an app delegate. Existing chat/preview localisation suites additionally cover toolbar labels and error mappings. All 3,244 English keys have counterparts in all 13 target catalogues.

The generator repeats pre-existing Russian/Ukrainian ICU redundant exact-one warnings in unrelated keys. Those existing keys were not changed by this lane.

## Integration handoff

**Hotspot:** all localisation lanes append to `lib/l10n/app_*.arb` and regenerate `app_localizations*.dart`. Keep every lane's unique key block; make all locales follow the final English source order; regenerate generated Dart instead of hand-merging it. The pre-created integration child owns final combined-branch verification. No code outside this card's production ownership was modified; catalogue/generated outputs, documentation and one additive test are the required supporting changes. Classic chat was deliberately left byte-identical to the already-localised base, rather than churning existing translations.
