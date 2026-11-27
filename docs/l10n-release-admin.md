# Release localisation: administration (part A)

Implemented on `v5/l10n-admin`, based on `6521d11d`. The inventory at
`../l10n/docs/l10n-release-remaining.md` was read before implementation. Only the
six assigned source files, localisation catalogues/generated output, relevant
tests and this document were changed. No push, merge, board operations, local
model hosting or inference was performed.

## Changes

Added **393 `rel_admin_` keys**, with descriptions in every catalogue, and complete
translations in ar, de, es, fr, ja, ko, pt, pt_BR, ru, uk, zh, zh_Hans and zh_Hant.
Portuguese variants have distinct vocabulary where appropriate; zh and zh_Hans
use Simplified Chinese and zh_Hant uses Traditional Chinese. All catalogues follow
app_en source order. Existing catalogue values and metadata were checked against
the base revision and are unchanged. The new English messages preserve the
original wording, punctuation, spaces and interpolation results.

- Model administration: keys, endpoint editing/testing, accounts, effort and speed
  presets, delegation, mixtures, credit purchases and plan confirmations. Dynamic
  confirmation sentences are complete messages, including the four combinations
  of plan price/schedule details. Effort and API-mode choices have display labels;
  their values are unchanged.
- Model services: `ModelAdminFailure` identifies locally authored failures;
  `ModelAdminException.localized(AppLocalizations)` renders them. HTTP status and
  server detail are separate data. Endpoint results distinguish a server message
  from the locally authored answered/unanswered fallback. Billing fallback text
  accepts localisations. Neither service accesses BuildContext.
- Profile administration: action labels, forms, warnings, pairing, Telegram setup,
  signed routes and backups. Dropdown values remain unchanged while display text
  is translated. Known channel states include pending restart, gateway stopped,
  startup failed, connecting, retrying and fatal; unknown future states remain
  identifiable. These additional states were checked in the local gateway source
  (`hermes_cli/web_routers/messaging.py` and `gateway/run_startup.py`).
- Bundle review: archive selection/export/import, reviewed-file consent text,
  appearance previews, theme modes, layout geometry and completion/error messages.
- Cloud transfer: source/destination labels, every transfer phase, progress,
  replacement/undo confirmations, receipt notices and recovery guidance.

All four core screens resolve strings through `context.sharedL10n`, including
when NextGen provides an ambient locale without the generated delegate. Async
operations capture the localisations before awaiting. Consent gates, billing
amounts/idempotency keys, permissions, routes and protocol payloads are unchanged.

## Deliberate English / literal exclusions

- Product/provider/theme names and external content: Ares, Hermes, Nous, OpenAI,
  Codex, Anthropic, Telegram, Cloud, GitHub/GitLab/Linear, imported theme names,
  user/profile/model names, server descriptions and safe server error details.
- `Hermes Agent` remains the editable default bot name sent in the existing setup
  payload. It is a name, not an action label. `SOUL.md`, `desktop.json`, `.tar.gz`,
  `hermes-backup.zip`, IDs, URLs, paths, environment keys and stored preference keys
  remain unchanged. The `default` profile ID in destination/scope text is literal.
- Wire values such as `chat_completions`, `anthropic_messages`, `loud`, `silent`,
  `yes`, `no`, hook signature/delivery identifiers, transfer/charge codes and
  backend IDs retain their original values. Checked transport and webhook
  signature identifiers remain technical diagnostics. Their surrounding UI
  text and authored choice labels are translated. Currency symbols and USD,
  numeric values, separators and the effort-clamp arrow are unchanged.
- `Other` in provider grouping is a matching token. Network-error matching
  fragments in charge ambiguity classification are internal control text.
  Transfer StateErrors (`changed`, `Receipt not cleared`) are caught and rendered
  through the localised profile failure mapper; they are never displayed raw.
- English compatibility rendering remains available through
  `ModelAdminException.message`/`toString()`, `EndpointTestResult.message`,
  `chargeOutcomeUnknownMessage` and the omitted-locale `safeBillingMessage` path.
  Owned UI paths use the locale-aware alternatives.

**Known boundary outside this assignment:** `workspace_profiles_screen.dart`
currently calls `profileError(e)` without localisations. Its compatible default
therefore remains English. All three owned profile consumers explicitly pass
shared localisations. That caller was not edited because another worker owns it.
Server-authored text and unknown future wire states can also remain English;
this change does not translate arbitrary remote content. No known app-authored
UI literals remain unmapped within the owned scope, subject to the deliberate
name/identifier and compatibility exclusions above.

## Validation actually run

- `flutter gen-l10n`: passed. It reports seven pre-existing ICU warnings for
  overridden `=1` branches: ru `ng_loop_runs`, `ng_dock_subagents`,
  `appearance_embeds_reset`; uk `ng_loop_runs`, `ng_subagent_tools`,
  `ng_chats_unread`, `appearance_embeds_reset`. No new admin key produces a
  warning. Generated Portuguese/Chinese variant method ordering is generator
  output; existing translation values were not edited.
- `flutter analyze --no-pub --fatal-infos`: **passed, no issues**. Earlier async
  context/formatting and test-fixture diagnostics were fixed before this run.
- Full requested test set: **348 passed, 28 files, no failures or skips**, using
  `flutter test --no-pub --concurrency=2 --reporter expanded` with the union of
  `test/*l10n*_test.dart`, `test/nextgen_gaps_test.dart`,
  `test/l10n_placeholders_test.dart` and every test file referencing the owned
  screens/services. The additional referenced files are
  `canonical_wire_services_capture_test.dart`, `model_admin_contract_test.dart`,
  `profile_admin_contract_test.dart`, `review_billing_blockers_test.dart` and
  `theme_source_guard_test.dart`.
- New `release_admin_l10n_test.dart`: **36 passed** in a final focused run. It
  checks typed failures plus exact English rendering, endpoint and billing
  fallbacks, all supported ambient locales without the generated app delegate,
  German profile screens with/without that delegate, known/unknown channel
  states, German charge confirmation and unchanged consent/amount/idempotency
  behaviour, descriptions and placeholders across all catalogues.
- Existing service rejection assertions were strengthened to check reason and
  original English rendering; no existing English widget expectations were
  weakened.
- `dart run tool/check_l10n_placeholders.dart`: **passed** for all 13 translated
  catalogues, including source order and ICU/placeholder consistency.
- Changed handwritten Dart files were formatted; generated files came from
  `flutter gen-l10n`. `git diff --check` passed. A final manifest check confirmed
  source edits are limited to the six owned files. Mechanical helper files and
  logs remain ignored under `.dart_tool/rel_admin`; none are committed.

## Implementation commits

| Commit | Owned file / scope | New keys |
| --- | --- | ---: |
| `e2903e59` | `model_admin.dart`: reasons, rendering, service fallbacks | 52 |
| `99c726ca` | `remote_model_admin.dart`: typed remote failures | 0 |
| `6bc1cad9` | `model_admin_screen.dart`: provider/billing UI and existing contract assertions | 140 |
| `b650a296` | `profile_admin_panel.dart`: profile actions and state displays | 130 |
| `c69d4cc2` | `profile_bundle_screen.dart`: bundle and appearance UI | 39 |
| `3257a016` | `profile_transfer_screen.dart`: transfer UI | 32 |

Each key-bearing implementation commit includes its additions in all 14 ARBs
and corresponding generator output. The final validation commit adds the shared
regression test and this report. Apply the sequence together: the typed service
API and its callers are changed in their respective file-scoped commits.
