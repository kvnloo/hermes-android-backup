# Managed fleet SSH — validation handoff

## Local candidate

- Branch: `v5/fleet-tofu`; base: `6521d11d`.
- Tested application/source commit: `764f224af5fc10218f7434b776cd9c4cbfea1ff6`.
- Local only; nothing pushed. This report is a subsequent documentation-only commit.
- Scope: the explicitly authorised gateway-API-limited UX, not native Electron parity or relayed Ares chat adoption.

## Implemented

Both layouts expose **Gateway-managed SSH** through More → Gateway fleet, without a device SSH/platform gate. The screen reads existing SSH entries from the serving gateway, shows the host/port and requires TOFU confirmation before a bodyless POST. It explains that gateway OpenSSH remembers the key, later changes are blocked, and no fingerprint is reported to Ares. Independently pinned direct SSH remains available in the same flow.

The single pending state shows elapsed wall-clock time. There is no misleading interrupting Cancel, fabricated log stream or fingerprint. Leaving does not cancel bootstrap. Read status displays the reported gateway/remote loopback ports, host, reuse flag and Hermes version (including a legitimately empty version). Confirmed Disconnect includes the owned remote service teardown warning.

A `502 detail.kind=host-key-changed` blocks with independently verified gateway-operator repair instructions and confirmed Retry; Ares never resets trust or retries automatically. No native-only managed update/recovery controls, credential prompts, generic commands, arbitrary port tunnels or remote chat relay are added. Hosts must already exist in the gateway registry and have Hermes installed.

Owner/pane fences check every await. The displayed registry destination is re-read before each operation. Late results/errors are dropped on owner change, including A→B→A. Raw registry key paths, error messages and credentials are neither rendered nor persisted.

## Execution results

| Gate | Result |
|---|---|
| `flutter pub get --offline --enforce-lockfile` | PASS |
| Pinned-source SSH contract audit at upstream `b7ee21c14e38316273f88d8ed112491ba1c87d15` | PASS |
| `flutter analyze --no-pub --fatal-infos` | Clean |
| Required fleet + gaps/localisation/theme cohort, `-j1` | **41 passed, 0 failed, 0 skipped** |
| Full `flutter test --no-pub -j2 --exclude-tags perf` | **8,382 passed, 0 failed, 0 skipped**, exit 0, final `done.success=true` |
| `git diff --check` | PASS |

The focused cohort includes gateway_fleet, fleet_navigation, fleet_update_admission, fleet_primary_classic, fleet_ssh, fleet_managed_ssh, nextgen_gaps, l10n_placeholders and theme_source_guard. Its totals overlap the full suite and must not be added together. The final full run took 1,473,157 ms (about 24m33s). Earlier interrupted runs were discarded and are not acceptance results.

The final run used `TMPDIR=$PWD/.dart_tool/full-tmp`, the supplied integration-fleet Go SSH fixture, `pty/build/pty-tmp/ares-pty`, the PTY fixture venv Python, and Homebrew ffmpeg/ffprobe. All fixture paths were checked present. No real accounts, remote hosts, Hermes hosting or inference were used.

Four new tests cover the REST request/response contract, endpoint edits, sanitised mismatch/other errors, empty version, pane invalidation, A→B→A late results, and both themes at 320×640 with 2.0× text and keyboard insets. Widget flows exercise first-use Cancel sending nothing, keyboard Tab/Escape dismissal, confirmed retry, elapsed progress, no interrupting Cancel and destructive disconnect confirmation. Existing actual Classic/NextGen More navigation tests now open the managed page too.

Ten shared strings were translated and generated for all 14 ARB files (English plus 13 non-English variants/aliases), preserving English source order and placeholder sets. No NextGen-only strings were introduced. Existing Russian/Ukrainian ICU generator warnings predate this work.

## Evidence retained in this workspace

- `.dart_tool/fleet-tofu-gates.jsonl`: SHA-256 `553f01e6fa69a4f9a5249bc6678de4af01969852e3cf024234c5119c6e9efbc9`
- `.dart_tool/fleet-tofu-full.jsonl`: SHA-256 `2b0f69379dfdf289f34c9cfb00250da61d90401924632c03d6657f7fc9731b9b`
- `tool/audit_managed_ssh_contract.py`: reproducible read-only source audit.

**Integration hotspot:** `lib/core/services/connection_manager.dart` gains the closed managed-SSH transport and bounded error discriminator handling. Reconcile this shared transport carefully with sibling branches, then run the integrated gates. No packaged-device/native Desktop/live SSH deployment is claimed; the existing final integration child owns release-wide verification.
