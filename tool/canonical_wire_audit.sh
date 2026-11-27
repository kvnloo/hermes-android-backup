#!/usr/bin/env bash
# Canonical wire audit: capture what Ares sends on a session-authority
# (Hermes 0.23+) socket and validate every frame against the gateway's own
# pydantic contracts.
#
#   tool/canonical_wire_audit.sh <extracted-hermes-tree> [python]
#
# <extracted-hermes-tree> is `git archive` of the pinned Hermes commit (see
# tool/canonical_wire_check.py for the exact command); nothing is installed,
# fetched or hosted. [python] needs pydantic (default: the Hermes venv).
#
# 1. The capture suites drive the real producers of both layouts against the
#    strict gateway and write build/canonical-wire/*.json (pending_lanes.json
#    holds the frames of lanes not merged into this branch yet, copied from
#    their code and sent through the real socket).
# 2. The authority-mode suites that already existed run with a tap on their
#    (now strict) fakes and append build/canonical-wire/tap/*.jsonl.
# 3. tool/canonical_wire_check.py validates every frame and writes
#    build/canonical-wire/results.{json,md}.
set -u
tree=${1:?usage: tool/canonical_wire_audit.sh <extracted-hermes-tree> [python]}
python=${2:-"$HOME/.hermes/hermes-agent/venv/bin/python"}
out=build/canonical-wire
rm -rf "$out"
mkdir -p "$out/tap"
status=0

captures=(
  test/canonical_wire_classic_capture_test.dart
  test/canonical_wire_nextgen_capture_test.dart
  test/canonical_wire_services_capture_test.dart
  test/canonical_wire_pending_lanes_capture_test.dart
  test/strict_authority_gateway_test.dart
)
flutter test --no-pub -j1 "${captures[@]}" >"$out/captures.log" 2>&1 || {
  echo "capture suites failed: see $out/captures.log"
  status=1
}

# Existing authority-mode suites: their producers are the workspace services
# (queue, workers, files, profiles, fleet), the canonical controls and replay,
# presence, and the NextGen create/model/image paths.
taps=(
  canonical_session_params_test
  classic_canonical_controls_test
  nextgen_canonical_controls_test
  nextgen_canonical_replay_test
  nextgen_foreground_catch_up_test
  nextgen_model_switch_test
  nextgen_projects_test
  nextgen_replayed_clarify_test
  prepared_image_composers_test
  prepared_image_recovery_test
  desktop_capture_test
  chat_browser_workflow_test
  remote_workspace_wire_test
  host_schedule_memory_contract_test
  session_cwd_mutation_test
  gateway_queue_wire_test
  workspace_workers_wire_test
  workspace_workers_navigation_test
  session_files_navigation_test
  git_review_blockers_test
  git_review_operations_test
  presence_parallel_panes_test
  popout_presence_test
)
for suite in "${taps[@]}"; do
  ARES_WIRE_TAP_FILE="$PWD/$out/tap/$suite.jsonl" \
    flutter test --no-pub -j1 "test/$suite.dart" >"$out/tap/$suite.log" 2>&1 || {
    echo "$suite failed: see $out/tap/$suite.log"
    status=1
  }
done

shopt -s nullglob
"$python" -I tool/canonical_wire_check.py "$tree" "$out"/*.json "$out"/tap/*.jsonl \
  --json "$out/results.json" --markdown "$out/results.md" >"$out/results.txt" || status=1
shopt -u nullglob
tail -n 3 "$out/results.txt"
exit $status
