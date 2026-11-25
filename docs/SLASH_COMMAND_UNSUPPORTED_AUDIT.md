# Slash-command refusals: historical audit and current client contract

## Status

PR #303 incorporates the contributor's documentation ancestry from #302 and fixes
classic `ChatScreen` refusal handling. The historical probe below is evidence
reported by the contributor, not a fresh compatibility claim for every Hermes
version or transport. No production commands were executed during maintenance.

The client now:

- renders `data.detail` for a refused invocation, with a localized unavailable
  message otherwise; retains the exact draft and never converts that refusal
  into a prompt, including when the catalog failed or timed out;
- shares learned **bare-command** refusals across routes using the same gateway
  client/profile/socket, resetting them on disconnect, reconnect and close;
- does not hide a whole command after an argument-specific refusal (`/cron add`
  does not establish that `/cron` is unavailable), or after an execution failure;
- honors an explicit `executable`, `supported` or `slash_exec` list for both
  completion and dispatch, including an empty list, if a server supplies one;
- treats timeouts, disconnects, stale sessions and all other execution failures
  as local failures/uncertainty, keeping the draft with **no automatic resend**;
- preserves the plain-send path for unknown names excluded by a successfully
  loaded catalog, before any command execution, and for REST-only ordinary
  slash text. A refusal received without a catalog is not evidence of prose.

`/new` and `/reset` retain main's local fresh-chat implementation. Bare `/model`
opens the existing classic picker, consuming its shortcut only once discovery
actually opens the sheet. Failure, reconnect, resync or a newer edit keeps the
draft. Bare `/sessions` and `/resume` return to the session browser only from a
route explicitly pushed by the classic session list; other entry points give a
localized direction to open the list and retain the draft. They never blindly
pop a cron, notification, deep-link or stacked-chat parent. Argument-bearing
forms of these three shortcuts give a localized explanation and retain the
line; they do not silently ignore the requested model or session name.

These are **classic ChatScreen** changes. NextGen has its own composer, model
picker and session-sidebar navigation; it does not use this slash pipeline. This
change does not replace those routes or add a second command execution path.

## Verified source contract

Maintenance inspected the installed stock Hermes source read-only:

- `tui_gateway/contracts/tools_commands.py`: `CommandsCatalogResult` contains
  ordered `pairs`, `categories[].pairs`, a **dictionary** of `commands` metadata,
  `canon`, skills and plugin entries. Catalog membership is display/discovery
  metadata, **not** an execution guarantee. The stock contract currently declares
  no `executable` set. `desktop` metadata is display intent, not a refusal list.
- `tui_gateway/command_discovery.py`: aliases can be present in `canon` without a
  separate `pairs` row. Alias execution and learned refusal identity resolve to
  the canonical command.
- `SlashExecResult` and `tui_gateway/methods_tools.py`: worker/plugin output is
  normally `{output, warning?}` without `type`. Rerouted `command.dispatch`
  results carry `type` (`send`, `skill`, `prefill`, `exec`, `plugin`, `alias`). A
  result is not retried or re-dispatched by the client. Explicit send/skill
  directives may submit their message once; prefill only edits the untouched
  composer. A delayed directive cannot overwrite or send over newer typing.
- `gateway/session_commands.py`: canonical gateway refusals use
  `data.reason: "unsupported_command"`, optionally `data.detail`; control-socket
  transport maps that refusal to code **4001**. `JsonRpcError.fromGateway`
  preserves that structured reason and detail.
- Standalone TUI **4018 is overloaded**: besides the legacy
  `not a quick/plugin/bundle/skill command:` refusal, it also reports quick
  command execution failures and skills requiring `command.dispatch`. A naked
  code is not a safe learned-refusal signal. The client accepts the exact
  structured reason or legacy refusal message, never a reason substring such as
  `unsupported_session_field`, and never every 4001/4018 error indiscriminately.

## Historical contributor probe (#302)

The contributor reported a stock Hermes v0.23.3 `hermes serve` probe using
`session.create source=gui` followed by bare `slash.exec` calls in a throwaway
session. Its catalog contained **243 rows**: 98 stock names, one plugin command
(`/delegation`) and 144 skill commands. These profile-dependent counts must not
be used as a hardcoded client allow/deny list.

The contributor reported **45 accepted bare forms, 52 observed refusals and
one deliberately unexecuted `/update`** in a 98-name stock sample. However, the
supplied accepted-name list contains only **44 distinct names**, whereas the
refused-name list contains **52**. The raw probe replies were not included, so
one stock entry remains unreconciled; the claimed 45/98 result is not independently
verified here. `/update` was classified refused by source inspection, not by a
live invocation. Do not call this 98 executed commands or count `/update` among
observed replies.

Supplied accepted names (44, despite the original 45 claim):

> `approvals` `autoprune` `blueprint` `bundles` `busy` `codex-runtime`
> `context` `cron` `curator` `debug` `diff` `egress` `fast` `footer` `goal`
> `heartbeat` `help` `init` `insights` `kanban` `learn` `login` `loop`
> `memory` `moa` `personality` `plan` `platforms` `profile` `reasoning`
> `refine` `review` `skills` `status` `subgoal` `suggestions` `title`
> `topup` `usage` `verbose` `version` `voice` `whoami` `yolo`

`/plan`, `/learn` and `/init` returned prompt directives rather than ordinary
output. The reported refused names were:

> `agents` `battery` `bg` `branch` `browser` `btw` `clear` `compress` `config`
> `copy` `density` `export` `focus` `handoff` `hatch` `history` `image`
> `import` `indicator` `journey` `logs` `model` `mouse` `new` `palette`
> `paste` `pet` `plugins` `prompt` `queue` `quit` `redraw` `reload`
> `reload-mcp` `reload-skills` `resume` `retry` `rewind` `rollback` `save`
> `sessions` `skin` `snapshot` `statusbar` `steer` `stop` `subscription`
> `timestamps` `tools` `undo` `wake` `worktree`

`/new` (alias `/reset`) already had a local implementation in #301. The
remaining reported refusals included terminal/client-machine UI actions,
session-runtime actions with dedicated RPC/UI equivalents, and host-state
commands with terminal hints (`export`, `import`, `snapshot`, `rollback`,
`handoff`, `worktree`, `hatch`). Accepted bare commands could still refuse verbs:
`/cron` writes, `/kanban` mutations, `/usage reset`, `/suggestions accept` and
`/voice tts` were the contributor's examples. Behavior can depend on session,
permissions, arguments, gateway version and surface.

## Remaining upstream request

The comment on #302 asks maintainers to publish a surface-aware executable set
(or omit non-executable rows from non-terminal catalogs). This remains
**unresolved**; no upstream implementation or maintainer decision is claimed.
The client tolerates an explicit list but does not invent one from `desktop`
metadata. Even future command-level advertisement cannot replace runtime error
handling or safely describe every argument/permission-specific refusal.

Recommendation: carry this corrected audit with #303, then close #302 as
superseded after #303 is reviewed and merged, rather than merging a second,
stale documentation-only PR. Keep the upstream contract request separately
tracked. Real fresh review and exact-head CI are still required before either
PR is marked ready or merged.
