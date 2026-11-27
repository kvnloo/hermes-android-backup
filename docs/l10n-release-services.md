# Release localisation — services, notifications and leftovers

## Scope

Local branch `v5/l10n-services`, based on `6521d11d`. This pass covers the part-C ownership list in `l10n-release-remaining.md`; it does not modify the other localisation lanes' Dart files.

- Added 187 messages with source descriptions and typed placeholder metadata, translated into all 13 shipped non-English catalogues: ar, de, es, fr, ja, ko, pt, pt_BR, ru, uk, zh, zh_Hans and zh_Hant.
- Reused existing translated keys where their English text matches the former literal.
- Preserved catalogue message order from `app_en.arb` and regenerated localisations.
- Confirmed all eight `release_misc_*` messages already exist and have explicit translations in every catalogue. No duplicate keys were needed.
- Backup errors/results, certificate import errors, search errors, sign-in callback pages, push availability/settings, tool/status fallbacks, approval scope explanations, image-recovery notices, wake capture notices, transcript alert labels and notification copy now use localisations.
- Shared widgets use `context.sharedL10n`. Services retain compatible callers through the existing active-locale `serviceStrings` scope; completion/activity helpers and push services also accept explicit localisations. No service takes a `BuildContext`.
- `main.dart` maps discovery `TimeoutException` to translated copy rather than displaying the service's English timeout sentence.
- Known worker states, Kanban workspace kinds and Bot Desktop gateway placement are mapped for presentation without changing their stored/wire values.

## Deliberately literal English and technical data

### Notification diagnostics

`turn_notification_service.dart` and `windows_toast_sink.dart` retain stable diagnostic reason tokens such as `not initialised`, `permission denied`, `replies are off`, `conversation`, `notifications are off`, and `Windows did not report its notification setting`. They are not displayed directly: both recent-notification sheets pass them through `TurnNotificationService.localizedAttemptDetail`. This preserves existing diagnostic contracts and lets retained attempts follow the current display language. Unknown platform/server details remain verbatim. Diagnostic kind/outcome identifiers, channel IDs and action IDs remain unchanged.

Internal notification bookkeeping, withdrawn/superseded/disabled sentinel exceptions and their classification text remain technical. OS-visible channel names/descriptions and Darwin action labels are translated; channel IDs and sound choices are unchanged. Channels follow the existing device-language notification-string resolver.

### Push validation and transport

The internal mobile-push sentinels `Allow Android notifications before enabling mobile push.`, `Invalid registration response.`, `Server did not confirm activation.`, `Event cursor did not advance.`, and `Event reconciliation incomplete; retry after the server backlog is reduced.` remain English for validation/classification. The public error field and settings catch path show translated safe explanations, not raw exceptions or credential-bearing platform/server bodies. Native method names, transport IDs, session-scope modes, endpoint paths and VAPID material are protocol data.

### Backups, certificates, search and sign-in

Backup JSON fields, format/version/preference keys, cipher/KDF identifiers, MIME types, filenames, PEM recognition markers, PKCS#12, TLS, API/HTTP identifiers, authentication provider/flow IDs and `deployment-token` remain storage/protocol contracts. Certificate subject names, user labels, URLs, raw server errors and platform diagnostics remain external data inside translated wrappers.

Certificate lease/read-only ownership invariants, malformed persisted chat-space guards, `Unknown chat space`, and chat-space storage `StateError`s remain developer diagnostics. Space storage screens already replace storage failures with their existing translated safe error. Invalid space-name and duplicate-name messages are translated. The three `Certificate file too large.` exceptions in `main.dart` are caught and replaced by the translated certificate-import error.

Browser callback HTML/CSS is literal markup, not prose; its visible title/body are translated. `No tokens returned` is an internal malformed-response guard. Product/platform names such as Ares, Hermes, Hermes Desktop, Android, Windows, Tailscale, Google Play Services, Firebase SDK and UnifiedPush remain names.

### Models, activity, approval and rendering

Tool names, server event kinds, raw server/user titles and descriptions, wake-feed refusal details, paths and IDs remain data. Known locally authored fallback labels are translated. `ms`, `s`, numeric timings and other conventional units retain their technical spelling. Notification payload fields, approval choice IDs, folder access wire values and protocol markers are unchanged.

`reference_completion.dart` keeps `@file:`, `@folder:`, `@url:`, `@image:`, `@tool:`, `@git:`, `@diff` and `@staged` as command syntax; only their visible explanatory metadata is translated.

### Small display leftovers reviewed without unnecessary changes

- `git_review_pane.dart`: Git status letters/numbers, diff counts and the agent-facing hand-off command remain literal technical/command data. The staged label was already translated.
- `session_dock.dart`: a wait barrier's free-form server reason remains verbatim after the translated state label.
- `windows_toast_sink.dart`: retained its stable reason tokens; their localisation is implemented in the shared display mapper, so no source change is necessary here.
- `kanban_board_screen.dart` and `bots_screen.dart`: event kinds remain diagnostic identifiers. Unknown future workspace/placement codes remain diagnosable. Geometry such as display resolution remains technical data.
- `workspace_workers_screen.dart`: known lifecycle states are translated; unknown future state values and worker goals/IDs remain raw.

## Regression coverage and verification

The new `rel_svc_l10n_test.dart` checks explicit non-English catalogue values and descriptions, exact English notification reasons, retained-token localisation, command syntax versus translated metadata, German service/model projection, and German recovery-notice rendering. Three existing notification tests only lose `const` construction because channel labels are now resolved dynamically; none of their assertions is weakened.

Final verification:

- `flutter pub get --offline --enforce-lockfile`: passed; lockfile unchanged.
- `flutter gen-l10n`: passed; a second final generation produced no further diff. Existing Russian/Ukrainian ICU override warnings are unchanged from the base.
- `dart run tool/check_l10n_placeholders.dart`: passed for all 13 source-ordered translated catalogues.
- `flutter analyze --no-pub --fatal-infos`: **No issues found**.
- Changed-Dart `dart format --output=none --set-exit-if-changed`: 46 files, zero changes required.
- Localisation suites (`test/*l10n*_test.dart`, including `l10n_placeholders_test`), `nextgen_gaps_test`, and affected screen/service regressions: **248 test files; 3,197 tests passed, six skipped, zero failures**. These counts exclude hidden setup/teardown events. The runner returned exit 0 and its final JSON event reported `success: true`.
- `git diff --check`: passed.

The broad first run found only an over-strict assertion in the newly added catalogue test: legitimate translated spellings such as German “Status” and French “Important” can equal English. The test now pins those exact locale/key exceptions while still requiring explicit nonempty catalogue entries; the full 248-file rerun passed. No existing assertion was weakened.

No push, publishing, host deployment or inference is part of this task.
