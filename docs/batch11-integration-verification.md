# Batch 11 integration verification

## Candidate and scope

- Release base: `49d29803c6f9aadd151441c10a421d2fd6875151` (`feature/ares-v5.0.0`, untouched).
- Integration branch: `v5/integration-batch11`.
- Worktree: `/Volumes/Storage/Hermes/workspace/ares-v5-lanes/integration-batch11`.
- External storage verified as mounted APFS `/dev/disk5s1` at `/Volumes/Storage` before creating the worktree.
- Tested production/test tree: `7a784ee424f175fb45d1b1d0c4a39fee41ef7161`. The subsequent verification commit changes only this report and evidence bookkeeping, not application source, tests, dependencies, generated localization or build configuration.

Merged, in order:

1. `7ad82657fdb84db37e03dbc9047c83ce0b8f34d4`: `v5/sync-pr381` at `12be59942b781be9d63545c53840a9d14072bbba` (includes upstream PR381 at `34ff43ea41e4ee3cc59612c504f1c2abf6f21293`).
2. `6a6d9eb28f1f7c5b4d53f4dbb566d56eb8befccb`: `v5/windows-snipping-paste` at `1f699c60238986cd5bbd39c0510c2539dc4c22d4`.
3. `05a2f13c08c79faf8f7d7c683fb3f29df7a46cba`: `v5/audio-attachment-preview` at `07b6025bc65c74727946094b31e067fa47d51cbe`.
4. `7a784ee424f175fb45d1b1d0c4a39fee41ef7161`: additionally fetched upstream `0bd0671784416b265102abc895b2151c1327201c`, the sole newer origin/main commit since PR381, preparing stable 4.0.19 metadata.

The three feature merges were conflict-free, including the shared Classic chat source. The newer upstream metadata merge conflicted in `.github/workflows/pr-quality.yml`, `.github/workflows/release.yml`, `pubspec.yaml` and `test/release_identity_test.dart`. Resolution preserves `5.0.0+5000`, CI base code `5000`, and 5.0 Store notes/splits; the identity test now requires upgrading every published 4.0.19 split through `30753`. Upstream release documentation and 4.0.19 Store notes remain imported. No upstream commit was skipped. No dependency or lockfile changes, and no updater restoration.

No ARB conflict occurred: only the audio lane changed localizations, so Git retained its complete ordered changes without a JSON conflict resolution. `flutter gen-l10n` completed, produced no further diff, and generated Dart was never manually merged. Combined production diff reviewed once for integration mistakes; no further source fix was needed.

## Gates

All commands ran on the integration worktree unless explicitly labeled base comparison.

| Gate | Result |
| --- | --- |
| `flutter pub get --offline` | Exit 0; unchanged lockfile |
| `flutter gen-l10n` | Exit 0; unchanged generated output |
| `flutter analyze --no-pub --fatal-infos` | Exit 0, no issues |
| `dart run tool/check_l10n_placeholders.dart` | Exit 0; all 13 locales complete, source-ordered and matching placeholders/ICU |
| `python3 -m unittest scripts.test_apk_update_guardrails` | Exit 0; 7 tests passed |
| `git diff --check 49d29803` | Exit 0 |
| Complete `flutter test --no-pub -j1 --exclude-tags perf --file-reporter json:.../full.jsonl` | **8,572 passed, 0 failed, 0 skipped; 656 suites; terminal success=true; exit 0; 3,297.838 seconds** |
| Initial separate serial perf run (two files) | 27 passed, 2 failed, 0 skipped; terminal success=false; exit 1 |
| Same two perf files on detached base `49d29803` | 29 passed, 0 failed, 0 skipped; terminal success=true; exit 0 |
| Integrated serial perf recheck, unchanged tree | **29 passed, 0 failed, 0 skipped; terminal success=true; exit 0** |

Full-suite results are from one wholly green invocation, not assembled reruns. Visible testDone results exclude hidden loader/setup records (704 successful hidden records in the full log). No failing test, threshold or assertion was changed during integration. The audio lane's already-reconciled disabled-seek-until-metadata assertion remains intact.

Perf files were selected with fixed-string `grep -rlF "@Tags(['perf'])" test`, checked nonempty and exactly two: `test/delivered_files_perf_test.dart` and `test/transcript_redaction_gateway_test.dart`. The initial run exceeded unchanged quote-marker and transcript budgets (1979 ms versus <1500; 1109 ms versus <1000). Base comparison passed, then the unchanged integrated tree passed all 29 together. This is timing variability, not a claim that the initial perf invocation passed. An earlier perf command used zsh array syntax under the foreground tool's Bash interpreter and exited 99 before running tests; the corrected Bash-array command performed the actual runs.

## Fixture and resource configuration

Full run used `-j1` from the outset; memory/load inspected before starting. This shared 24 GiB host had fluctuating unrelated build load; resource snapshots are retained. Private temp directory was created with mode 0700 at `.dart_tool/full-tmp`.

```text
ARES_SSH_FIXTURE=/Volumes/Storage/Hermes/workspace/ares-v5-lanes/integration-fleet/build/fleet-ssh-fixture
ARES_TERMINAL_FIXTURE_HELPER=/Volumes/Storage/Hermes/workspace/ares-v5-lanes/pty/build/pty-tmp/ares-pty
ARES_TERMINAL_FIXTURE_PYTHON=/Volumes/Storage/Hermes/workspace/ares-v5-lanes/pty/build/pty-tmp/venv/bin/python
ARES_TEST_FFMPEG=/opt/homebrew/bin/ffmpeg
ARES_TEST_FFPROBE=/opt/homebrew/bin/ffprobe
TMPDIR=/Volumes/Storage/Hermes/workspace/ares-v5-lanes/integration-batch11/.dart_tool/full-tmp
```

All fixture executable paths were checked executable before the complete invocation. No FFmpeg skips remained. Exit status was captured immediately; shell pipefail was set.

## Evidence and limits

Local ignored evidence: `evidence/batch11-full-7a784ee424f1/`, including `full.jsonl`, `full.console.log`, `full.status`, `analyze.log`, `l10n.log`, `updater-guardrails.log`, `environment.log`, `resources-*.log`, `perf.jsonl`, `base-perf.jsonl`, `perf-recheck.jsonl` and their statuses/console logs. `evidence/summarize-json.py` reproduces visible counts, hidden counts, failure/error details and terminal completion from raw JSON. Raw logs are retained locally, not published.

Existing Russian/Ukrainian ICU plural warnings and the existing flutter_tts/flutter_local_notifications Swift Package Manager adoption notices remain; analyzer and localization gates pass.

No platform builds, installation or launch were performed. Real Windows Snipping Tool paste and native audio GUI/codec acceptance still require the parent's later candidate build and user test; inherited worker-native probe results are documented in their original files and are not relabeled as batch-11 device proof. No runtime app, data, credentials or user clipboard was accessed. Main was not moved; nothing was pushed, tagged or published.
