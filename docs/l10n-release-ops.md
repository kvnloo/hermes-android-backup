# Release localisation — operations (part B)

## Scope

Branch: `v5/l10n-ops`, based on `feature/ares-v5.0.0` at `6521d11d`. Local only; nothing pushed.

The seven assigned implementation files are localised:

- `lib/core/capabilities/capability_pages.dart`
- `lib/core/capabilities/capability_admin.dart`
- `lib/core/screens/host_operations_screen.dart`
- `lib/core/workspace/terminal_page.dart`
- `lib/core/workspace/ssh_terminal_dialog.dart`
- `lib/core/screens/fleet_ssh_screen.dart`
- `lib/core/services/fleet_ssh.dart`

Added **349 `rel_ops_` keys**: 163 capability, 73 terminal, 46 Fleet SSH and 67 host-operation keys. Every key has description metadata, with typed interpolation arguments. All 13 target catalogues contain real translations in English source order: `ar`, `de`, `es`, `fr`, `ja`, `ko`, `pt`, `pt_BR`, `ru`, `uk`, `zh`, `zh_Hans`, `zh_Hant` (**4,537 translated entries**). Existing shared generic keys are reused where their English text is identical.

Shared widgets use `context.sharedL10n`, including when rendered by NextGen. Capability and Fleet SSH failures expose structured reasons; UI renders their translations. The SSH transport receives a health-success formatter rather than a BuildContext. Host and terminal retained notices resolve during rendering, including after a locale change; initial async host loading does not read inherited localisation from `initState`.

English text and existing widget expectations are preserved. No admission, consent, host-key verification, protocol payload or command translation changes were made. A terminal post-await check now explicitly checks `mounted` before reading localisation; this retains the existing current-owner check.

## Deliberately retained literal text

These exceptions are intentional, not untranslated application sentences:

| Location | Retained text/data | Reason |
|---|---|---|
| Capability pages | `hermes curator restore` | Executable command. Passed as a placeholder inside the translated archive explanation. |
| Capability admin | `_failureEnglish` and legacy exception `message`/`toString()` | Backwards-compatible diagnostic API defaults. Locally authored failures now carry `CapabilityFailure`; owned UI uses the structured reason, not these English defaults. Existing callers/tests retain their exact English diagnostics. |
| Capability admin/pages | RPC method names, endpoint paths, capability IDs, map keys, approval/scan wire values, backend/tool/plugin identifiers, source IDs and widget keys | Machine contracts stay byte-identical. Known wire values used as labels are mapped to localised display text without changing the submitted value; unknown future values remain diagnostic data. |
| Capability admin | `[redacted]` and log-redaction patterns | Stable security markers and matching rules, not interface copy. |
| Capability pages | Skill/plugin descriptions, scan findings, MCP logs, gateway error prose, names, account aliases and other user/server data | External content is preserved, not translated or rewritten. |
| Host operations | `agent`, `errors`, `gateway`, `desktop`; `INFO`, `WARNING`, `ERROR` | Log identifiers and severity filter tokens. The UI shows their exact identifiers for diagnosis and sends them unchanged. |
| Host operations | `doctor`, `security-audit`, `curator-run`, `memory`, `user`, `all` | Command/reset-target identifiers, including placeholders in translated operation-result sentences. |
| Host operations | Three English switch patterns in `_refusalText` | Compatibility matching against the out-of-scope service's local fallback messages. Their rendered results are translated; unmatched host-authored refusal text remains external data. |
| Host operations | Host versions/platforms, profile/connection names, timestamps, log lines, remote check labels/status/messages and diagnostic URLs | Server/operator data, not application-authored prose. The surrounding health, readiness and boolean labels are localised. |
| Terminal page | `StateError('Tab limit')` | Internal exception caught by the localised safe-operation failure path; never shown verbatim. |
| Terminal page/dialog | SSH addresses, ports, fingerprints, process/session IDs, server process statuses, protocol/menu identifiers and terminal escape sequences | Authentication/runtime data and machine contracts. Application-authored tab/status labels and replay-trimming notice are translated. |
| Terminal page | Shell output, clipboard contents and selected text | User/remote payloads remain unchanged in the terminal, paste review and chat-draft export. |
| Fleet SSH service/screen | `SSH`, `OpenSSH`, `Ed25519`, `SHA256`, `HTTP`, `ssh-ed25519`, command flags, HTTP request/header tokens, pin-record markers and filenames | Protocol/product/algorithm names and security-sensitive matching/serialization. |
| Fleet SSH service/screen | Hosts/users, identity-file paths, fingerprints, preview source and remote shell output | User data and remote payloads. Failure reasons and surrounding UI are translated. |

Product names remain literal where used. There are no intentionally retained application-authored English UI sentences outside the documented compatibility diagnostics/matching patterns.

## Validation

- `flutter pub get --offline --enforce-lockfile` — passed.
- `flutter gen-l10n` — passed for each screen commit. Existing Russian/Ukrainian plural override warnings on unrelated keys remain unchanged; generation succeeds.
- `flutter analyze --no-pub --fatal-infos` — **No issues found**.
- `dart run tool/check_l10n_placeholders.dart` — **All 13 locales: complete source-ordered keys and matching placeholders/ICU structure**.
- Dart format applied only to changed Dart files; `git diff --check` passed.
- One bounded read-only review of the seven-file implementation diff found no concrete issues.
- Final combined test run: **379 visible tests passed, zero failed, zero skipped**, across **38 files**. Counts exclude hidden loading/setup/teardown events. It includes every `test/*l10n*_test.dart`, `nextgen_gaps_test.dart`, and all tests referencing the owned screens/services.
- New tests cover all 349 keys/descriptions/order, generated-to-ARB equality for every shipped locale (including regional/script variants), structured failure reasons and exact English, Classic/NextGen delegates, async initial-load/disposal safety and retained-notice relocalisation.
- Fixture-gated tests were enabled, not skipped: real OpenSSH enrollment/direct-channel/preview/shell/changed-key refusal and POSIX PTY keyboard/context paste, hide/close and background-process lifetime.

Native fixture setup used managed scratch storage:

```sh
clang++ -std=c++17 -Wall -Wextra -Werror native/terminal/pty_posix.cc -o "$FIXTURES/ares-pty"
go -C tool/fleet_ssh_fixture build -o "$FIXTURES/ssh-peer" .
export ARES_TERMINAL_FIXTURE_HELPER="$FIXTURES/ares-pty"
export ARES_SSH_FIXTURE="$FIXTURES/ssh-peer"
```

The executable basename **must be `ares-pty`**: test process detection uses `pgrep -x ares-pty`. An initial diagnostic run with a differently named helper failed PID assertions; rebuilding under the correct name made all native cases pass without changing test expectations.

Final `flutter test --no-pub --machine` file set:

```text
test/bots_kanban_l10n_test.dart
test/bots_profile_l10n_test.dart
test/canonical_wire_services_capture_test.dart
test/capability_admin_test.dart
test/capability_localisation_reason_test.dart
test/capability_review_blockers_test.dart
test/catalog_install_wire_test.dart
test/chat_release_l10n_test.dart
test/completion_sound_l10n_test.dart
test/core_release_l10n_test.dart
test/cron_upcoming_l10n_test.dart
test/desktop_os_both_layouts_test.dart
test/desktop_os_l10n_test.dart
test/fallback_model_l10n_test.dart
test/fleet_navigation_test.dart
test/fleet_ssh_l10n_test.dart
test/fleet_ssh_test.dart
test/fleet_update_admission_test.dart
test/history_strings_l10n_test.dart
test/host_operations_localization_test.dart
test/host_operations_screen_test.dart
test/l10n_de_ng_regression_test.dart
test/l10n_ja_smoke_test.dart
test/l10n_locale_resolution_test.dart
test/l10n_locales_smoke_test.dart
test/l10n_placeholders_test.dart
test/nextgen_gaps_test.dart
test/nextgen_models_l10n_test.dart
test/nextgen_release_l10n_test.dart
test/ops_release_l10n_test.dart
test/ops_review_blockers_test.dart
test/preview_release_l10n_test.dart
test/projects_root_l10n_test.dart
test/provider_oauth_l10n_test.dart
test/render_strings_l10n_test.dart
test/voice_l10n_test.dart
test/workspace_terminal_page_test.dart
test/workspace_terminal_review_test.dart
```

No local Hermes host/inference, live host maintenance, pushes, releases or store submissions were performed.

## Integration note

ARB additions are append-only and use this lane's namespace. Merge the source catalogues in `app_en` order and regenerate `app_localizations*.dart` rather than hand-merging generated output. The first generation also normalises the existing Portuguese/Chinese generated class blocks, so their diff is larger than just this lane's new methods. No other lane's implementation files were edited.
