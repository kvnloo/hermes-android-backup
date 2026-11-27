# Release localisation: chat preview and terminal

**Integration complete:** the parent consumed both registry keys into every catalogue and regenerated localisations. Locale number markers follow the nearby comment-number glossary; English stays unchanged. The verification requirements below are the original pre-integration checklist; final execution results are in [the consolidated report](l10n-release-chat.md).

## Scope and outcome

Read every file in `lib/core/preview/` before edits: `chat_preview.dart`, `preview_messages.dart`, `preview_evidence.dart`, `reader_canvas.dart`, `reader_document.dart`. `lib/core/terminal/` does **not exist** in this checkout; no terminal code was invented or moved. Neither chat screen was edited.

Preview prose, dialogs, tooltips, statuses, errors, reader-console presentation and draft introductions already use shared localisation. Retained existing exact-semantic keys instead of duplicating them. Extracted the remaining two annotation label templates so punctuation/order can also be localised.

## Original literal inventory

Line numbers refer to original HEAD, before edits.

| Original location | Original literal | Treatment |
| --- | --- | --- |
| `chat_preview.dart:767` | `'#${p.number} ${p.note}'` | New `rel_chat_preview_pin_label(number, note)` |
| `reader_canvas.dart:180` | `'#${p.number}'` | New `rel_chat_preview_pin_number(number)` |
| `reader_canvas.dart:93` | `'No crop'` | Internal caught StateError; translated capture failure is rendered instead |
| `chat_preview.dart:802` | `'HTTP 200 · $origin · $count'` | Raw diagnostic compatibility record; UI, clipboard and staged log use existing `release_preview_request_loaded` |
| `preview_evidence.dart:56` | `'#${p.number} · ${p.selector} · ${p.rect.left.round()},${p.rect.top.round()} (${p.rect.width.round()} × ${p.rect.height.round()}): ${p.note}'` | Preserve technical evidence layout: pin ID, DOM selector, pixel coordinates/dimensions, verbatim user note; no English prose |
| `preview_messages.dart:48` | `'Preview crop exceeds its limit.'` | Diagnostic match token; renders `release_preview_crop_limit` |
| `preview_messages.dart:49` | `'The selected image is empty or unreadable.'` | Diagnostic match token; renders `release_preview_image_unreadable` |
| `preview_messages.dart:51` | `'The selected image exceeds the 64 MiB draft budget.'` | Diagnostic match token; renders `release_preview_image_budget` |
| `preview_messages.dart:53` | `'Unsupported image format. Choose a JPEG, PNG, or WebP image.'` | Diagnostic match token; renders `release_preview_image_format` |
| `preview_messages.dart:55` | `'The selected JPEG, PNG, or WebP image could not be decoded safely.'` | Diagnostic match token; renders `release_preview_image_decode` |
| `preview_messages.dart:57` | `'Unable to sanitize this image. Choose a valid JPEG, PNG, or WebP image.'` | Diagnostic match token; renders `release_preview_image_sanitize` |
| `preview_messages.dart:59` | `'You can attach up to 10 items to one Remote Gateway draft.'` | Diagnostic match token; existing UI uses `you_can_attach_up_to_items(maxRemoteAttachmentDrafts)` |
| `preview_messages.dart:61` | `'Attachments are limited to 64 MiB total per draft.'` | Diagnostic match token; renders `release_preview_draft_budget` |
| `preview_messages.dart:63` | `'Generic files are limited to 16 MiB each.'` | Diagnostic match token; renders `release_preview_generic_file_limit` |
| `preview_messages.dart:65` | `'Remote images must be sanitized before upload.'` | Diagnostic match token; renders `release_preview_image_not_sanitized` |
| `reader_document.dart:62` | `'This address is outside the approved preview origin.'` | Diagnostic compatibility getter only |
| `reader_document.dart:63` | `'Page exceeds the reader limit.'` | Diagnostic compatibility getter only |
| `reader_document.dart:64` | `'The page could not be read.'` | Diagnostic compatibility getter only |
| `reader_document.dart:65` | `'This page is too complex for reader mode.'` | Diagnostic compatibility getter only |
| `reader_document.dart:67` | `'HTTP $statusCode. No redirect or sign-in was followed.'` | Diagnostic compatibility getter only |
| `reader_document.dart:69` | `'Only HTML and plain text can open in reader mode.'` | Diagnostic compatibility getter only |
| `reader_document.dart:70` | `'The site could not be loaded securely.'` | Diagnostic compatibility getter only |
| `reader_document.dart:71` | `'Could not capture these pixels.'` | Diagnostic compatibility getter only |

All locations in the table are under `lib/core/preview/`.

## Existing localisation retained

- `chat_preview.dart:277–308`: open-site confirmation (including origin), cancel/open, discard/keep pins use `release_preview_*`, `cancel`, `ng_models_discard`.
- `chat_preview.dart:364–375`: share confirmation/body/buttons use `release_preview_share_page_*`, `cancel`.
- `chat_preview.dart:463–487`: numbered comment title, note label, cancel/keep pin use `release_preview_comment_number`, `release_preview_note`, `cancel`, `release_preview_keep_pin`.
- `chat_preview.dart:545–638`: preview heading, hide/close, site address/go, forward/reload, share/stop, annotate and reader-console tooltips use existing `release_preview_*`. Back uses Flutter `MaterialLocalizations.backButtonTooltip` at line 590.
- `chat_preview.dart:644–723`: retained notices, reconnect, reader-mode help, sharing status, annotation help, request heading/selection count, copy all/selected, clear and staged log use existing shared keys (`release_preview_*`, `ng_clear`).
- `chat_preview.dart:756–761`: annotation introduction and add-to-draft count use `release_preview_annotation_intro`, `release_preview_add_pins_to_draft`.
- `chat_preview.dart:825`: structured request line uses `release_preview_request_loaded`, including existing English pluralisation.
- `reader_canvas.dart:218`: freeform selector label already uses `release_preview_reader_region`.
- `preview_messages.dart:13–38`: retained `PreviewNotice`, typed `PreviewFailure`, HTTP status and workspace failures map to existing shared keys, including `history_error_unbound`, `history_error_denied` and `workspaceFailureLabel`. Unknown failures use `release_preview_operation_failed`.
- `preview_messages.dart:48–67`: attachment diagnostic match strings never appear directly; recognised cases map to shared keys, unknown diagnostics to `release_preview_stage_failed`.

Both renderers already import `../l10n/l10n.dart`; new templates use `context.sharedL10n` or its build-local `l10n` alias, compatible with NextGen. Parser/loader exceptions remain structured and never take BuildContext. The evidence helper receives its already-localised introduction callback, not a context.

## Exclusions and invariants

Preserve diagnostic match tokens byte-for-byte. `PreviewError.message` is explicitly diagnostic; the UI renders its reason through `previewNoticeText`. Preserve raw console fallback text for existing clients/tests; all actual UI/copy/stage paths provide localisations.

Preserve wire field names (`kind`, `url`, `title`, `elements`, `selector`, etc.), action/direction strings, DOM tags/attributes/selectors, regexes, MIME types, origins/URLs, proxy `DIRECT`, `HTTP 200`, widget keys, font family `monospace`, import paths and whitespace separators. Remote page titles/text and user notes are content, not app-authored English. Evidence coordinates/selectors and technical record punctuation stay unchanged. Product names inside existing translations stay unchanged. No file/command/product literals changed.

No ARBs/generated files, other workers' chat screens, service directories or terminal implementations were edited. No local inference/hosting performed.

## Registry and integration requirements

`.dart_tool/chat-preview-strings.json` contains only new keys, each `{value, description, placeholders}` with explicit `int`/`String` placeholder types. Parent must merge both into all catalogues and regenerate localisation before compiling the new references. English must remain exactly `#1` and `#1 note` (including spacing); do not change user notes.

## Verification and required tests

Static checks: registry JSON/schema/placeholder validation; new key/callsite parity; no collision with existing English catalogue; exact English interpolation comparison against original labels; scoped diff inspection; `git diff --check`. Flutter is intentionally not run by this worker.

After parent catalogue integration/regeneration:

1. Run `flutter analyze`.
2. Run `flutter test test/preview_release_l10n_test.dart test/isolated_preview_test.dart`.
3. Cover both new pin labels in shipped locales, placeholder order and exact English output.
4. Exercise NextGen without generated delegates (sharedL10n fallback) and inherited non-English locale; switch locale while a document, pin or failure is retained.
5. Check copy-all/copy-selected/staged reader logs, annotation draft introductions, known attachment refusals and unknown failures remain localised, while wire/parser diagnostics and evidence coordinates/selectors remain unchanged.

No runtime/test PASS claimed. Formatting/analyser/test execution remains with parent per task request.
