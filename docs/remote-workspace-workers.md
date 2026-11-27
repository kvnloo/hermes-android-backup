# Live workers (F20)

In Classic or NextGen, open **More → Live workers** to see counts grouped by stored parent session for the displayed gateway and profile. Refresh to take another snapshot. Background processes have their own count; they are not children you can steer.

Select an attached group, or choose **Live workers** in the toolbar of an attached parent chat. Select the child by its goal and task ID, enter an instruction and press **Steer**. **Queued** means the host accepted the instruction for a checkpoint; it does not mean the child received it. A rejected or unconfirmed request keeps its text in the current editor. No mutation is retried automatically.

## Gateway contract

Canonical sockets dispatch list/steer to the [session authority's child handlers](https://github.com/NousResearch/hermes-agent/blob/b7ee21c14e38316273f88d8ed112491ba1c87d15/gateway/session_ancillary.py). The host rechecks the selected agent object under the live-child registry lock; `queued` is not a delivery acknowledgement. Profile-wide roster discovery is a sessionless handler, not a list of permissions. Sidecar source: pinned Hermes [`methods_subagents.py`](https://github.com/NousResearch/hermes-agent/blob/b7ee21c14e38316273f88d8ed112491ba1c87d15/tui_gateway/methods_subagents.py) and [`methods_session.py`](https://github.com/NousResearch/hermes-agent/blob/b7ee21c14e38316273f88d8ed112491ba1c87d15/tui_gateway/methods_session.py). Ares uses the existing [workspace owner](remote-workspace-contract.md), not a new chat or a global dispatcher.

| Typed operation | Wire scope | Guard |
|---|---|---|
| `target.workerGroups()` | `subagent.roster` with the selected profile (omitted for the serving profile); `sessions[].session_id` is a **stored** parent ID | Counts only, no resume or create. A group captures its source target and any existing binding on that socket. |
| `target.workers()` | `subagent.list` with the bound **runtime** parent ID and effective profile | Verify exact stored parent before/after. Only `subagents[].subagent_id` identifies a worker. Neither `child_session_id` (transcript) nor failed `delegations`, task indexes, goals, or status messages supply control IDs. |
| `worker.steer(text)` | `subagent.steer` with that same runtime parent, profile, selected `subagent_id` and nonempty text | Re-list first; require the same child ID, start/delegation metadata, active status and explicit `accepting_steer`. Recheck owner and stored row before dispatch. Require the matching child/text echo and a `queued` or `rejected` receipt. |

**Limits:** Discovery is one profile/connection at a time. The host can return snapshots via durable lineage while refusing control unless the exact owner transport and session record still match. Group counts on a separate Classic workspace socket, a different client, or after reconnect are not runtime bindings. API-server-only Classic and the separate recovery-v2 transport cannot steer through this surface. No connection, profile, lineage, transport or parent-steer fallback. Local checks are not a server-side child-generation compare-and-swap. A lost acknowledgement cannot establish whether the host queued an instruction.

`workspace_workers_wire_test.dart` and `workspace_workers_navigation_test.dart` exercise production Dart clients and Flutter surfaces against a disposable loopback peer; they do not run a deployed child agent or prove native-device delivery.
