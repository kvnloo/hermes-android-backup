# Canonical wire audit (Hermes 0.23+ session-authority sockets)

Every JSON-RPC request Ares sends on a socket whose `gateway.ready` says
`session_authority: true` must be in a shape the gateway accepts. This page is
the inventory of those requests, how each is checked, and what was changed.

Gateway reference: Hermes commit `b7ee21c14e` (`tui_gateway/contracts/*.py`,
`gateway/session_controls.py` and the handlers it dispatches to).
Ares base: `feature/ares-v5.0.0` at `d15fccd7`. Branch: `v5/wire-audit`.

## Result

Validated: 890 frames, 121 methods, 0 rejected by the gateway, 0 disagreements between the strict fake and the gateway (pin `b7ee21c14e`). 6 further requests are refused in the app before the wire, by design. 20 of the 890 are deliberately wrong frames from the strict fake's own corpus, which the gateway must refuse and does. `tool/canonical_wire_audit.sh` prints the current figures.

No request Ares sends is refused by the gateway. Requests with no canonical
form are refused in the app, by name, before they are sent.

Not covered here, by design: the truncating `prompt.submit` and the
`session.rewind` redirect (owned by the history lane, t_a59a8eac).

## How to run it

```sh
R=~/.hermes/hermes-agent PIN=b7ee21c14e TREE=$(mktemp -d)
git -C $R archive $PIN $(git -C $R ls-tree --name-only $PIN | grep -E '\.py$') \
    acp_adapter agent cron gateway hermes_cli hermes_platform persistence plugins \
    providers session_rules tools tui_gateway utils locales | tar -x -C $TREE
tool/canonical_wire_audit.sh $TREE          # captures + validation, about 10 minutes
```

Nothing is installed, fetched or hosted. The validator is
`tool/canonical_wire_check.py <tree> <capture files>`, run with `python -I`
(it needs pydantic; the Hermes venv has it). It replays what the pinned
dispatcher does with a request:

1. drops `profile` for the verbs where the scope is implicit;
2. checks a verb in `CANONICAL_METHODS` with the dispatcher's own
   `canonical_param_problems` (`4001 invalid_params`);
3. routes it: an authority handler, a group control, or `-32601`, which falls
   back to the legacy sidecar only where `legacy_fallback_allowed` says so (the
   sidecar refuses unknown keys with `4000`);
4. applies the handler's own closed key set. Each rule quotes the source line
   it was read from, and the run stops if that line is no longer in the tree;
5. sends `session.mutate` payloads through the store's `parse_mutation`;
6. validates the declared pydantic model in full.

Output: `build/canonical-wire/results.md` (pass/fail per method),
`results.json` (every frame with its verdict) and `results.txt`.

## What changed in the app

One guard, `CanonicalWire` (`lib/core/services/canonical_wire.dart`), applied in
`WsClient.send` to every request on an authority socket. It is the counterpart
of Hermes Desktop's `canonicalProducerFrame`
(`apps/desktop/src/api/canonical-protocol.ts`). A legacy (pre-0.23) socket
never goes through it, so legacy behaviour is unchanged. Both layouts use
`WsClient.send` (Classic through `DesktopGatewayClient`, NextGen through
`NextGenGateway`), so one guard covers both.

Translated (the owner has a canonical form):

| Legacy request | Sent instead |
| --- | --- |
| `session.title` | `session.mutate` `rename`, fenced by the session revision |
| `session.archive` | `session.mutate` `archive` |
| `session.compress` | `session.mutate` `compress` (revision and generation) |
| `session.branch`, `session.branch_stored`, `session.branch_whole` | `session.mutate` `branch` |
| `session.cwd.set`, `session.workspace.move` | `session.mutate` `workspace` |
| `session.activate` | `session.resume` |
| `session.resume` / `session.create` with legacy keys | the canonical key set (`source: gui`, no `inline_images`, …) |
| `config.set key=model` | `session.mutate` `model` (the owner refuses the config write with `use_session_mutation_model`) |
| `config.set key=reasoning` for a session | `session.mutate` `reasoning` when the fences are known, otherwise the `config.set reasoning` the owner also serves |
| `session.interrupt`, `session.steer`, `session.redirect` | the same verb with `execution_generation` |
| `approval.respond`, `clarify.respond`, `clarify.lock` for a published prompt | answered by `prompt_id` and `execution_generation` |
| `prompt.submit` without an identity | the same request with a `submission_id` |
| `bot_relay.deliver` with `from_*` fields | the closed key set with an `author` |

When a fenced edit does not know the session's revision or generation yet, the
guard reads them first with one `session.resume` and then sends the edit. The
receipt is handed back in the shape the legacy caller expects.

Refused before the wire (code `4999`, reason `canonical_unavailable`, message
localised in all 14 locales through `ng_wire_*` keys):

| Request | Message key |
| --- | --- |
| `config.set` with a key outside the 13 the owner serves, or a `scope` on a key other than `reasoning`/`yolo` | `ng_wire_setting_unavailable` |
| a session-owned `connect*` verb outside the manage_connections card, `sudo.respond`, `secret.respond` | `ng_wire_method_unavailable` |
| `session.create` options the create contract has no field for | `ng_wire_session_options_unsupported` |
| an approval or question that is no longer the one the owner waits on | `ng_wire_prompt_stale` |
| a fenced edit whose revision or generation cannot be learned | `ng_wire_revision_unavailable`, `ng_wire_generation_unavailable` |
| a branch at a message with no saved id | `ng_wire_message_not_saved` |

The wording of the first two is Desktop's. `canonicalConfigAvailable(key,
scope:)` answers whether a setting can be changed on an authority socket, and
`ng_wire_not_available` is a note for a control disabled there. No screen in
this base uses either yet; they are there for the voice lane (below).

Controls hidden or disabled: none needed in this base. The only `config.set`
keys Ares sends are `model`, `reasoning` and `fast`, all served; no screen sends
a session-owned connector verb outside the card; `sudo.respond` and
`secret.respond` are fallbacks that an authority socket never reaches (it asks
as a server request and takes the answer as that request's response). The one
control that does need hiding is in the voice lane, see "Lanes not in this
base".

Also fixed: Classic opens chats with the canonical `session.resume`/`create`,
and treats only the refusal reason `not_found` as "the runtime is gone". Before,
any `4001` made it resume and resend a request the owner had already refused.

## Test fakes

One strict fake, generated from the same tables the validator uses:

- `test/support/canonical_wire_contracts.g.dart`: written by
  `tool/canonical_wire_check.py --emit-dart`.
- `test/support/strict_authority_gateway.dart`: `strictAuthorityRefusal`,
  `strictAuthorityReply`, `strictAuthorityFrame`, `strictAuthorityCheck`. It
  answers `4001` for a canonical contract, `-32601` for a verb the authority
  does not serve, `4000` from the legacy sidecar.
- `test/support/strict_authority_server.dart`: a loopback gateway for capture
  suites. `test/support/strict_nextgen_gateway.dart`: the same check for fakes
  that answer `NextGenGateway.call`.

`test/strict_authority_gateway_test.dart` holds 40 right and wrong frames. The
validator checks each against the real dispatcher and reports any frame where
the fake and the gateway disagree (0). The fake models routes, key sets and
top-level types; value constraints (a pattern, a nested model) are checked by
the validator only.

Every authority-mode fake in `test/` now uses it. Suites that could not be
switched: none. Two fakes stay as they are because they are legacy-mode
(`test/chat_approval_route_ownership_test.dart`,
`test/support/fleet_fixture.dart`), and `test/desktop_pause_inflight_turn_test.dart`
uses the legacy ready frame.

No fake was loosened. Suites whose frames are also validated through a tap on
their fake (`ARES_WIRE_TAP_FILE`): `canonical_session_params_test`, `chat_browser_workflow_test`, `classic_canonical_controls_test`, `gateway_queue_wire_test`, `git_review_blockers_test`, `git_review_operations_test`, `host_schedule_memory_contract_test`, `nextgen_canonical_controls_test`, `nextgen_canonical_replay_test`, `nextgen_foreground_catch_up_test`, `nextgen_model_switch_test`, `nextgen_projects_test`, `nextgen_replayed_clarify_test`, `popout_presence_test`, `prepared_image_composers_test`, `prepared_image_recovery_test`, `presence_parallel_panes_test`, `remote_workspace_wire_test`, `session_cwd_mutation_test`, `session_files_navigation_test`, `workspace_workers_navigation_test`, `workspace_workers_wire_test`.

## Capture suites

| Suite | What it drives |
| --- | --- |
| `test/canonical_wire_classic_capture_test.dart` | Classic producers through `DesktopGatewayClient` |
| `test/canonical_wire_nextgen_capture_test.dart` | NextGen producers through `NgChatController` and `NextGenGateway` |
| `test/canonical_wire_services_capture_test.dart` | capabilities, model admin, billing, plans, Projects, regenerate read: each through both layouts' sockets |
| `test/canonical_wire_pending_lanes_capture_test.dart` | frames copied from code, sent through the real socket (see below) |
| `test/strict_authority_gateway_test.dart` | the strict fake's own corpus |

## Inventory

Call sites are `file:line` in `lib/` at this branch. "Keys on the wire" is the
union of the keys the captured frames carried, after the guard. Route:
`authority` (served by the session owner), `authority (group)`, or `sidecar`
(the authority answers `-32601` and the legacy sidecar serves it). "Captured"
names the layouts whose producers sent the frame; `shared` is a service both
layouts use, captured once.

| Method | Call sites | Keys on the wire | Contract | Route | Captured | Status |
| --- | --- | --- | --- | --- | --- | --- |
| `approval.pending` | remote_workspace.dart:417 | `profile`, `session_id` | ApprovalPendingParams | authority | shared: 5 ok | pass |
| `approval.respond` | ws_client.dart:905,1759,1766 | `choice`, `execution_generation`, `profile`, `prompt_id`, `session_id` | CanonicalApprovalParams | authority | classic/nextgen: 3 ok | pass |
| `billing.auto_reload` | remote_model_admin.dart:419 | `enabled`, `profile`, `threshold`, `top_up_amount` | BillingAutoReloadParams | sidecar | classic/nextgen: 2 ok | pass |
| `billing.charge` | remote_model_admin.dart:368 | `amount_usd`, `idempotency_key`, `profile` | BillingChargeParams | sidecar | classic/nextgen: 2 ok | pass |
| `billing.charge_status` | remote_model_admin.dart:379 | `charge_id`, `profile` | BillingChargeStatusParams | sidecar | classic/nextgen: 2 ok | pass |
| `billing.keep_going_on_credits` | remote_model_admin.dart:427 | `enabled`, `profile` | BillingKeepGoingOnCreditsParams | sidecar | classic/nextgen: 2 ok | pass |
| `billing.state` | remote_model_admin.dart:351 | `profile` | ProfileParams | sidecar | classic/nextgen: 2 ok | pass |
| `bot_relay.deliver` | — | `author`, `id`, `message`, `profile` | CanonicalBotDeliverParams | authority | pending lane: 1 ok | pass |
| `clarify.lock` | ws_client.dart:1818 | `answer`, `question_id`, `request_id` | ClarifyLockParams | authority | copied frame, flow not driven: 1 ok | pass |
| `clarify.respond` | ws_client.dart:905,1818 | `answer`, `execution_generation`, `profile`, `prompt_id`, `session_id` | ClarifyRespondParams | authority | classic/nextgen: 2 ok | pass |
| `client.activity` | chat_presence.dart:400 | `basis`, `can_alert`, `idle_seconds`, `sessions` | ClientActivityParams | sidecar | shared: 12 ok | pass |
| `client.capabilities` | ws_client.dart:808 | `server_requests` | ClientCapabilitiesParams | sidecar | classic/nextgen/shared: 112 ok | pass |
| `command.dispatch` | chat_controller.dart:3237 | `arg`, `name`, `session_id` | CommandDispatchParams | authority | copied frame, flow not driven: 1 ok | pass |
| `commands.catalog` | ws_client.dart:1658,1662; slash_catalog.dart:158 | `profile`, `session_id` | CommandsCatalogParams | authority | classic/nextgen/shared: 4 ok | pass |
| `complete.path` | chat_screen.dart:9666; chat_view.dart:2444 | `profile`, `session_id`, `word` | CompletePathParams | authority | classic/nextgen: 2 ok | pass |
| `complete.slash` | chat_screen.dart:9679; ws_client.dart:1677,1684; chat_view.dart:2459 | `profile`, `session_id`, `text` | CompleteSlashParams | authority | classic/nextgen: 2 ok | pass |
| `config.get` | ws_client.dart:2137,2144,2151 | `key`, `profile`, `session_id` | ConfigGetParams | authority | classic: 1 ok | pass |
| `config.set` | ws_client.dart:2113,2120,2128,2169…; remote_model_admin.dart:323,330; chat_controller.dart:3694,3864 | `key`, `profile`, `session_id`, `value` | CanonicalConfigSetParams | authority, not sent | classic/nextgen + pending lane: 5 ok, 3 refused before the wire | pass |
| `connection.respond` | desktop_gateway_client.dart:1446; chat_controller.dart:868 | `op_id`, `owner`, `profile`, `result` | ConnectionRespondParams | authority | classic/nextgen: 4 ok | pass |
| `connectors.accounts` | capability_admin.dart:1151 | `profile` | ConnectorAccountsParams | sidecar, not sent | classic/nextgen: 2 ok, 1 refused before the wire | pass |
| `connectors.accounts.remove` | capability_admin.dart:1183 | `connection_id`, `profile` | ConnectorAccountsRemoveParams | sidecar | classic/nextgen: 2 ok | pass |
| `connectors.connect` | capability_admin.dart:1172 | `alias`, `connectors`, `owner`, `profile`, `reconnect` | ConnectorsConnectParams | sidecar | classic/nextgen: 2 ok | pass |
| `connectors.policy.get` | capability_admin.dart:1191 | `profile` | ProfileParams | sidecar | classic/nextgen: 2 ok | pass |
| `connectors.policy.set` | capability_admin.dart:1232 | `change`, `expected_revision`, `profile` | ConnectorPolicySetParams | sidecar | classic/nextgen: 2 ok | pass |
| `connectors.tools` | capability_admin.dart:1192 | `profile`, `refresh`, `slug` | ConnectorToolsParams | sidecar | classic/nextgen: 2 ok | pass |
| `cron.manage` | — | `action`, `continuity`, `deliver`, `include_disabled`, `name`, `profile`, `prompt`, `repeat`, `schedule` | CronManageParams | sidecar | pending lane: 5 ok | pass |
| `display.install` | — | `profile` | ProfileParams | sidecar | pending lane: 1 ok | pass |
| `display.lease.acquire` | — | `profile`, `reason`, `viewer_id` | DisplayLeaseAcquireParams | sidecar | pending lane: 1 ok | pass |
| `display.lease.release` | — | `force`, `profile`, `viewer_id` | DisplayLeaseReleaseParams | sidecar | pending lane: 1 ok | pass |
| `display.observe` | — | `profile`, `viewer_id` | DisplayObserveParams | sidecar | pending lane: 1 ok | pass |
| `display.start` | — | `profile` | ProfileParams | sidecar | pending lane: 1 ok | pass |
| `display.status` | — | `profile` | ProfileParams | sidecar | pending lane: 1 ok | pass |
| `display.stop` | — | `force`, `profile` | DisplayStopParams | sidecar | pending lane: 1 ok | pass |
| `display.switchSandboxImage` | — | `approve`, `profile` | DisplaySwitchSandboxImageParams | sidecar | pending lane: 1 ok | pass |
| `display.thumbnail` | — | `profile` | ProfileParams | sidecar | pending lane: 1 ok | pass |
| `file.attach` | gateway_turn_coordinator.dart:811; ws_client.dart:2016,2020,2027,2031; chat_controller.dart:2582,2687 | `data_url`, `name`, `path`, `profile`, `session_id` | FileAttachParams | authority | classic/nextgen: 2 ok | pass |
| `gateway.ping` | ws_client.dart:670 | | frame handled in the read loop (`tui_gateway/ws.py`) | frame | not a dispatched request | n/a |
| `groups.capabilities` | — |  | GroupsCapabilitiesParams | authority (group) | pending lane: 1 ok | pass |
| `groups.context` | — | `event_id`, `notes`, `purpose`, `room_id`, `routing` | GroupsContextParams | authority (group) | pending lane: 1 ok | pass |
| `groups.create` | — | `members`, `name`, `room_id` | CanonicalRoomCreateParams | authority (group) | pending lane: 1 ok | pass |
| `groups.list` | — | `include_disbanded`, `limit`, `offset` | GroupsListParams | authority (group) | pending lane: 1 ok | pass |
| `groups.log` | — | `limit`, `room_id`, `since_seq` | GroupsLogParams | authority (group) | pending lane: 1 ok | pass |
| `groups.rename` | — | `event_id`, `name`, `room_id` | GroupsRenameParams | authority (group) | pending lane: 1 ok | pass |
| `groups.send` | — | `event_id`, `payload`, `room_id` | GroupsSendParams | authority (group) | pending lane: 1 ok | pass |
| `groups.state` | — | `room_id` | GroupsStateParams | authority (group) | pending lane: 1 ok | pass |
| `groups.stop` | — | `room_id` | GroupsStopParams | authority (group) | pending lane: 1 ok | pass |
| `handoff.fail` | composer_commands.dart:358 | `error`, `profile`, `session_id` | HandoffFailParams | authority | nextgen: 1 ok | pass |
| `handoff.request` | composer_commands.dart:134 | `platform`, `profile`, `session_id` | HandoffRequestParams | authority | nextgen: 1 ok | pass |
| `handoff.state` | composer_commands.dart:338 | `profile`, `session_id` | SessionParams | authority | nextgen: 4 ok | pass |
| `image.attach_bytes` | gateway_turn_coordinator.dart:810; chat_controller.dart:2554 | `content_base64`, `filename`, `profile`, `session_id` | ImageAttachBytesParams | authority | nextgen/shared: 3 ok | pass |
| `image.detach` | chat_controller.dart:2721 | `path`, `session_id` | ImageDetachParams | sidecar | copied frame, flow not driven: 1 ok | pass |
| `plugins.manage` | capability_admin.dart:849,912,920,934… | `accept_capabilities`, `action`, `catalog_name`, `enable`, `force`, `identifier`, `key`, `name`, `profile`, `ref` | PluginsManageParams | sidecar | classic/nextgen: 16 ok | pass |
| `process.list` | remote_workspace.dart:417 | `profile`, `session_id` | ProcessListParams | authority | shared: 2 ok | pass |
| `profiles.create` | remote_profile_admin.dart:70 | `clone_all`, `clone_channels`, `clone_from`, `mirror_credentials`, `name`, `no_alias`, `profile`, `share_auth` | ProfilesCreateParams | sidecar | copied frame, flow not driven: 1 ok | pass |
| `profiles.list` | remote_workspace.dart:403 | `include_sessions`, `profile` | CanonicalProfilesParams | authority (group) | classic/shared: 9 ok | pass |
| `projects.add_folder` | projects_gateway_client.dart:201,202; workspace_project_settings.dart:125 | `id`, `is_primary`, `label`, `path`, `profile` | ProjectsAddFolderParams | sidecar | classic/nextgen: 2 ok | pass |
| `projects.archive` | projects_gateway_client.dart:175 | `id`, `profile`, `restore` | ProjectsArchiveParams | sidecar | classic/nextgen: 2 ok | pass |
| `projects.create` | projects_gateway_client.dart:149,150 | `description`, `folders`, `name`, `primary_path`, `profile`, `use` | ProjectsCreateParams | sidecar | classic/nextgen: 2 ok | pass |
| `projects.delete` | projects_gateway_client.dart:206 | `id`, `profile` | ProjectIdParams | sidecar | classic/nextgen: 2 ok | pass |
| `projects.discover_repos` | workspace_discovery.dart:34 | `profile`, `scan` | ProjectsDiscoverReposParams | sidecar | copied frame, flow not driven: 1 ok | pass |
| `projects.get` | projects_gateway_client.dart:85,86; workspace_project_settings.dart:106 | `id`, `profile` | ProjectIdParams | sidecar | classic/nextgen: 2 ok | pass |
| `projects.list` | projects_gateway_client.dart:48,80; workspace_project_settings.dart:80 | `profile` | ProfileParams | sidecar | classic/nextgen: 2 ok | pass |
| `projects.project_sessions` | projects_gateway_client.dart:120 | `profile`, `project_id`, `session_limit` | ProjectsProjectSessionsParams | sidecar | classic/nextgen: 2 ok | pass |
| `projects.set_active` | projects_gateway_client.dart:243; workspace_project_settings.dart:150 | `id`, `profile` | ProjectsSetActiveParams | sidecar | classic/nextgen: 2 ok | pass |
| `projects.tree` | projects_gateway_client.dart:105; projects_repository.dart:361 | `preview_limit`, `profile`, `session_limit` | ProjectsTreeParams | sidecar | classic/nextgen/shared: 20 ok | pass |
| `projects.update` | projects_gateway_client.dart:161,165; workspace_project_settings.dart:172 | `id`, `name`, `profile` | ProjectsUpdateParams | sidecar | classic/nextgen: 2 ok | pass |
| `prompt.background` | composer_commands.dart:133 | `profile`, `session_id`, `text` | SideAgentParams | authority | nextgen: 1 ok | pass |
| `prompt.btw` | composer_commands.dart:132 | `profile`, `session_id`, `text` | SideAgentParams | authority | nextgen: 1 ok | pass |
| `prompt.cancel` | workspace_queue.dart:31,86 | `admission_id`, `profile`, `session_id` | PromptCancelParams | authority | shared: 1 ok | pass |
| `prompt.receipt` | workspace_queue.dart:133 | `admission_id`, `profile`, `session_id` | PromptReceiptParams | authority | shared: 9 ok | pass |
| `prompt.replace_queued` | workspace_queue.dart:35,88,125 | `admission_id`, `profile`, `session_id`, `submission_id`, `text` | CanonicalReplaceQueuedParams | authority | shared: 3 ok | pass |
| `prompt.resolve_unknown` | workspace_queue.dart:28,85,128 | `admission_id`, `execution_generation`, `profile`, `session_id` | PromptResolveUnknownParams | authority | shared: 3 ok | pass |
| `prompt.steer_queued` | workspace_queue.dart:32,87 | `admission_id`, `profile`, `session_id` | CanonicalSteerQueuedParams | authority | shared: 1 ok | pass |
| `prompt.submit` | gateway_turn_coordinator.dart:674,681; workspace_queue.dart:54; ws_client.dart:1474,1494,1507,1530…; remote_workspace_fleet.dart:202; chat_controller.dart:3400,3409 | `attachments`, `profile`, `queued`, `session_id`, `submission_id`, `text` | CanonicalSubmitParams | authority | classic/nextgen/shared: 14 ok | pass |
| `rollback.diff` | — | `hash`, `profile`, `session_id` | RollbackDiffParams | authority | pending lane: 1 ok | pass |
| `rollback.list` | — | `profile`, `session_id` | RollbackListParams | authority | pending lane: 1 ok | pass |
| `rollback.restore` | — | `all`, `file_path`, `hash`, `profile`, `session_id` | RollbackRestoreParams | authority | pending lane: 3 ok | pass |
| `secret.respond` | ws_client.dart:1790 |  | handler key set | not sent | shared: 0 ok, 1 refused before the wire | pass |
| `session.branch` | ws_client.dart:1956,1963,1970 | `session_id`, `through_message_id`/whole | → `session.mutate` `branch` | authority | translated by the guard (see `session.mutate`) | pass |
| `session.close` | ws_client.dart:1316 | | not a request: a method-name comparison in `WsClient` | | never sent on an authority socket | n/a |
| `session.compress` | chat_screen.dart:5903; chat_view.dart:950 | `session_id` | → `session.mutate` `compress` | authority | translated by the guard (see `session.mutate`) | pass |
| `session.context_breakdown` | chat_screen.dart:5859; chat_view.dart:1033 | `profile`, `session_id` | SessionContextBreakdownParams | authority | classic/nextgen: 2 ok | pass |
| `session.control` | chat_controller.dart:2263 | `action`, `args`, `profile`, `session_id` | SessionControlParams | authority | nextgen: 13 ok | pass |
| `session.control.read` | chat_controller.dart:2186 | `profile`, `session_id` | SessionControlReadParams | authority | nextgen/shared: 52 ok | pass |
| `session.create` | ws_client.dart:1284,2069,2072,2079…; chat_controller.dart:2439 | `cwd`, `cwd_explicit`, `model`, `profile`, `provider`, `reasoning`, `source` | CanonicalCreateParams | authority | classic/nextgen/shared: 7 ok | pass |
| `session.events.since` | desktop_gateway_client.dart:1397; chat_controller.dart:1721,1742; nextgen_gateway.dart:329 | `last_sequence`, `profile`, `replay_epoch`, `session_id` | CanonicalEventsParams | authority | nextgen/shared: 11 ok | pass |
| `session.export` | — | `format`, `profile`, `redact`, `session_id` | SessionExportParams | authority | pending lane: 1 ok | pass |
| `session.foreign.import` | — | `id`, `profile` | SessionForeignIdParams | sidecar | pending lane: 1 ok | pass |
| `session.foreign.list` | — | `limit`, `offset`, `profile`, `source` | SessionForeignListParams | sidecar | pending lane: 1 ok | pass |
| `session.foreign.preview` | — | `id`, `profile` | SessionForeignIdParams | sidecar | pending lane: 1 ok | pass |
| `session.history` | regenerate.dart:68 | `profile`, `session_id` | SessionHistoryParams | authority | classic/nextgen + pending lane: 3 ok | pass |
| `session.info` | chat_screen.dart:7104; ws_client.dart:365; remote_model_admin.dart:339; chat_controller.dart:2060,2146 | `profile`, `session_id` | CanonicalSessionInfoParams | authority | classic/nextgen: 2 ok | pass |
| `session.interrupt` | ws_client.dart:1731,1732,1739; chat_controller.dart:3038 | `execution_generation`, `profile`, `session_id` | CanonicalControlParams | authority | classic/nextgen/shared: 10 ok | pass |
| `session.list` | — | `include_hidden`, `limit`, `profile`, `title` | CanonicalListParams | authority | pending lane: 1 ok | pass |
| `session.mutate` | workspace_files.dart:272; chat_controller.dart:3785 | `expected_generation`, `expected_revision`, `operation`, `payload`, `profile`, `request_id`, `session_id` | SessionMutateParams | authority | classic/nextgen/shared + pending lane: 41 ok | pass |
| `session.resume` | remote_workspace.dart:154; workspace_queue.dart:173; ws_client.dart:1284,1330,1863,1882; chat_controller.dart:1013,1798 | `defer_history`, `omit_messages`, `profile`, `session_id`, `source` | CanonicalResumeParams | authority | classic/nextgen/shared: 194 ok | pass |
| `session.steer` | ws_client.dart:1630,1631,1639,1649; chat_controller.dart:2955 | `execution_generation`, `profile`, `session_id`, `text` | CanonicalCorrectionParams | authority | classic/nextgen/shared: 8 ok | pass |
| `session.title` | ws_client.dart:1938,1945; sessions_sidebar.dart:152; chat_controller.dart:2063,2147 | `session_id`, `title` | → `session.mutate` `rename` | authority | translated by the guard (see `session.mutate`) | pass |
| `session.usage` | chat_controller.dart:1997 | | not a request: an event type the NextGen controller reads | | never sent | n/a |
| `session.workspace.move` | projects_gateway_client.dart:233 | `session_key`, `cwd` | → `session.mutate` `workspace` | authority | translated by the guard (see `session.mutate`) | pass |
| `shared_metrics.set` | capability_admin.dart:1405 | `enabled`, `profile`, `send` | SharedMetricsSetParams | sidecar | classic/nextgen: 2 ok | pass |
| `shared_metrics.status` | capability_admin.dart:1397 | `profile` | ProfileParams | sidecar | classic/nextgen: 2 ok | pass |
| `slash.exec` | ws_client.dart:1703,1710; chat_controller.dart:3213 | `command`, `profile`, `session_id` | SlashExecParams | authority | classic/nextgen: 2 ok | pass |
| `subagent.interrupt` | chat_controller.dart:2237 | `profile`, `session_id`, `subagent_id` | SubagentIdParams | authority | nextgen: 1 ok | pass |
| `subagent.list` | workspace_workers.dart:131; chat_controller.dart:2216 | `profile`, `session_id` | SessionParams | authority | nextgen/shared: 109 ok | pass |
| `subagent.roster` | workspace_workers.dart:102 | `profile` | ProfileParams | sidecar | shared: 13 ok | pass |
| `subagent.steer` | workspace_workers.dart:83 | `profile`, `session_id`, `subagent_id`, `text` | SubagentSteerParams | authority | shared: 24 ok | pass |
| `subscription.change` | remote_model_admin.dart:442 | `profile`, `subscription_type_id` | SubscriptionChangeParams | sidecar | classic/nextgen: 2 ok | pass |
| `subscription.preview` | remote_model_admin.dart:433 | `profile`, `subscription_type_id` | SubscriptionPreviewParams | sidecar | classic/nextgen: 2 ok | pass |
| `subscription.state` | remote_model_admin.dart:354 | `profile` | ProfileParams | sidecar | classic/nextgen: 2 ok | pass |
| `sudo.respond` | ws_client.dart:1778 |  | handler key set | not sent | shared: 0 ok, 1 refused before the wire | pass |
| `vault.add` | capability_admin.dart:1289 | `kind`, `label`, `origin`, `profile`, `secret` | VaultAddParams | sidecar | classic/nextgen: 2 ok | pass |
| `vault.list` | capability_admin.dart:1243 | `profile` | ProfileParams | sidecar | classic/nextgen: 2 ok | pass |
| `vault.lock` | capability_admin.dart:1336 | `name`, `profile` | VaultLockParams | sidecar | classic/nextgen: 2 ok | pass |
| `vault.remove` | capability_admin.dart:1307 | `id`, `profile` | VaultRemoveParams | sidecar | classic/nextgen: 2 ok | pass |
| `vault.source.set` | capability_admin.dart:1311 | `enabled`, `name`, `profile` | VaultSourceSetParams | sidecar | classic/nextgen: 2 ok | pass |
| `vault.sources` | capability_admin.dart:1244 | `profile` | ProfileParams | sidecar | classic/nextgen: 2 ok | pass |
| `vault.unlock` | capability_admin.dart:1323 | `name`, `password`, `profile` | VaultUnlockParams | sidecar | classic/nextgen: 2 ok | pass |
| `wake.feed` | — | `pcm`, `profile`, `sample_rate` | WakeFeedParams | sidecar | pending lane: 1 ok | pass |
| `wake.pause` | — | `profile` | WakeControlParams | sidecar | pending lane: 1 ok | pass |
| `wake.resume` | — | `profile` | WakeControlParams | sidecar | pending lane: 1 ok | pass |
| `wake.start` | — | `client_capture`, `profile`, `session_id`, `surface` | WakeStartParams | sidecar | pending lane: 1 ok | pass |
| `wake.status` | — | `client_capture`, `profile`, `surface` | WakeStatusParams | sidecar | pending lane: 1 ok | pass |
| `wake.stop` | — | `profile` | WakeStopParams | sidecar | pending lane: 1 ok | pass |

Limits of the capture, stated plainly:

- `prompt.btw`, `prompt.background` and the `handoff.*` calls are captured
  through NextGen only. Classic sends them with the same shared runner
  (`runDedicatedCommand`, `lib/core/composer/composer_commands.dart`), but its
  flow is not driven by a capture suite. `session.control` and
  `subagent.interrupt` have NextGen producers only.
- Five requests are marked "copied frame, flow not driven": the frame is the
  one the named code builds, sent through the real socket and guard, but the
  screen flow that leads to it is not run. They are the batch `clarify.lock`,
  `command.dispatch`, `image.detach`, `profiles.create` and
  `projects.discover_repos`.
- `gateway.ping` is a frame the read loop answers; it has no params contract.

## Lanes not in this base

`v5/history` (ec8af35e), `v5/voice` (30d239e1) and `v5/bots` (123050e4) are not
merged into `d15fccd7`, and they moved while this audit ran. Their requests are
copied from their code into
`test/canonical_wire_pending_lanes_capture_test.dart` and sent through the real
socket and guard ("pending lane" in the table). That checks the shapes, not
the producers. After the merge:

1. Run `tool/canonical_wire_audit.sh` again and add the lanes' authority-mode
   suites to its tap list. Their fakes must use the strict helper.
2. Delete `test/canonical_wire_pending_lanes_capture_test.dart`.

Found in those lanes:

- **v5/voice, needs a change there.** `GatewayWakeWord.setCapturePreference`
  writes `config.set wake_word.capture`. The owner serves no such key and
  Desktop has no such control, so the guard refuses it by name. The capture
  preference control must be hidden or disabled on an authority socket
  (`canonicalConfigAvailable('wake_word.capture')` is false).
- **v5/bots, handled by the guard.** `RemoteBots.botRelayDeliver` sends
  `from_profile`, `from_handle` and `from_connection`, which the canonical
  contract refuses. Sent through `WsClient.send`, the guard rewrites it.
- **v5/history, merge conflict.** Both lanes wrap `WsClient.send`. Resolve it
  as: a legacy socket goes straight to `_sendRequest`; on an authority socket
  the history lane's rewind split runs first and everything else goes to
  `_sendCanonical`. Keep both state fields (`_sessionRevisions`, `_canonical`),
  both lines where the socket state is reset, and both in `_dispatchEvent`.
- `v5/car-docked-sidebar` (e2c9b0d2) adds no gateway method.
