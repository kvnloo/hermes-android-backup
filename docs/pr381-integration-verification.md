# PR #381 integration into Ares 5.0.0

## Scope

- Base: `49d29803c6f9aadd151441c10a421d2fd6875151`.
- Fetched `origin/main`: `34ff43ea41e4ee3cc59612c504f1c2abf6f21293` (the only missing upstream commit).
- Independent branch/worktree: `v5/sync-pr381`, `/Volumes/Storage/Hermes/workspace/ares-v5-lanes/sync-pr381`.
- The merge was conflict-free. Imported Classic and NextGen provider filtering and upstream regression tests; formatted all four changed Dart files with Dart 3.12.0.
- No version, dependency, localization, updater, slash-completion implementation, audio-preview or platform-build changes. `pubspec.yaml` remains `5.0.0+5000` (MSIX `5.0.0.0`). Main was not moved; nothing was pushed, tagged or published.

## Behavior covered

Both chat pickers retain configured/current providers, managed local-runtime and opt-in virtual/MoA providers. Existing session selection remains visible without exposing every model from a hidden provider. Phantom initial selections, duplicate-provider ambiguity, legacy flagless inventories, empty configured inventories, search/provider chips and cancellation are covered by the imported tests. Existing model management and slash-command suites were exercised without changing their semantics. HTTP widget fixtures are mocked, not live gateway acceptance tests; additional model/fallback suites exercise unavailable and retry behavior.

## Executed gates

Toolchain: Flutter 3.44.0 / Dart 3.12.0.

- `flutter pub get --offline`: exit 0; no lockfile changes. Existing Russian/Ukrainian ICU plural warnings and flutter_tts/flutter_local_notifications Swift Package Manager notices were emitted.
- `flutter analyze --no-pub --fatal-infos`: exit 0, **No issues found**.
- Four-file `dart format --output=none --set-exit-if-changed`: exit 0, zero changes after formatting.
- `git diff --check`: exit 0.
- Focused model-picker, model-selection, model-management and slash-suggestion/execution run: **301 passed**, zero errors/skips, terminal `done.success=true`.
- Additional model/fallback/localization/routing and remaining slash tests: **230 passed**, zero errors/skips, terminal `done.success=true`.
- Complete `flutter test --no-pub -j2 --exclude-tags perf --machine`, with PTY, Python terminal peer, real SSH and ffmpeg/ffprobe fixture environment enabled: **8,499 passed, 4 failed, zero skipped**, terminal `done.success=false`, exit 1 (2,047.776 seconds).
- Both failing files rerun serially unchanged: **24 passed**, zero errors/skips, terminal `done.success=true`, exit 0.

The complete run was not green. Failures were in unchanged files:

1. `workspace_terminal_review_test.dart`: macOS keyboard-paste review dialog not found.
2. `render_recheck_blockers_test.dart`: quote-line parser budget (143 ms).
3. Same file: NextGen streaming frame budget (250 ms versus <150 ms).
4. Same file: vision expansion frame budget (313 ms versus <150 ms).

All four passed in the unchanged serial two-file rerun. This supports a transient/load-sensitive result, but no base-worktree comparison or second green full-suite run was performed; do not describe the full-suite gate as passed. No thresholds or tests were weakened. Tagged perf tests were excluded as requested.

An initial foreground full-suite attempt was interrupted by the tool's 590-second timeout after 2,350 successful cases; shutdown errors from that interrupted attempt are not acceptance results. The subsequent tracked background run reached terminal completion.

## Local evidence

Ignored logs under this worktree's `build/pr381-gates/`:

- `analyze.log`
- `focused.jsonl`, `focused.stderr`
- `additional.jsonl`, `additional.stderr`
- `full.jsonl`, `full.stderr` (interrupted attempt)
- `full-retry.jsonl`, `full-retry.stderr` (complete run)
- `failures-retry.jsonl`, `failures-retry.stderr`

Counts were parsed from non-hidden `testDone` events, excluding suite-loader events. Terminal `done` events were checked separately. The parent must rerun integrated gates after combining this branch with other lanes.
