# Remote workspace owner (Ares 5)

Use `DesktopGatewayClient.workspace` in Classic and `NextGenGateway.workspace` in NextGen. They borrow the gateway's existing authenticated dashboard and JSON-RPC socket; they do not create a second chat, select a global profile or run a local service. **More → Profiles** is the first consumer in both layouts: it lists the profiles on that gateway and refreshes without switching chat profiles. An API-server-only Classic connection cannot serve this surface.

## Capturing and using a target

```dart
// `gateway` is the gateway that supplied the row, not the last-used gateway.
final owner = gateway.workspace;
final rowRoute = owner.route(storedSessionId: session.id);
final pane = owner.pane(); // keep one per independently selectable pane
try {
  final target = await pane.bind(rowRoute, expectedCwd: displayedServerCwd);
  final status = await target.read(WorkspaceRead.gitStatus); // Map or null
  target.checkCurrent(); // recheck in the consumer before publishing
  // null = not a repo, not unknown-method or permission denied.
} on WorkspaceException catch (e) {
  // Render e.reason. Never retry a gesture against the current selection.
} finally {
  pane.close(); // closes this selection, not the gateway or a sibling pane
}
```

`owner.route()` makes a connection/profile target with no session. `WorkspaceRoute` is a Dart record `({Object issuer, String connectionId, String? profile, String? storedSessionId})`. The issuer is local identity, **not** a credential. Mint routes on their source owner. Do not persist, manufacture or resolve them through a singleton. A different gateway instance rejects a route even if all strings match. A null profile means the serving gateway's own profile; it does not mean the literal name `default`.

`WorkspacePane.bind(route, {String? expectedCwd}) → Future<WorkspaceTarget>` synchronously invalidates its prior selection, even on failure. Call `pane.invalidate()` *in* a navigation/change handler before doing async work; call `pane.close()` when the pane leaves. Rebind explicitly after a reconnect. A→B→A does not revive A's previous work. Independent panes on the same gateway do not invalidate each other. A saved-account transaction, even a same-ID edit, revokes the original gateway's workspace owner; create its replacement from confirmed connection settings.

`WorkspaceTarget` exposes `route`, `effectiveProfile`, `runtimeSessionId`, `canonicalCwd`, `sessionAuthority`, `isCurrent`, `checkCurrent()` and `verifySession()`. No socket, cookies, headers, ticket, API key or `SavedConnection` is in its public surface. `checkCurrent()` is synchronous; `verifySession()` also reads back the exact stored row and requires the original profile/cwd/Git metadata generation. A local fence is **not** an atomic server precondition. Never use it as sole authorisation for a destructive change.

## Negotiation and wire shapes

Source pin: [Hermes `b7ee21c14e38316273f88d8ed112491ba1c87d15`](https://github.com/NousResearch/hermes-agent/tree/b7ee21c14e38316273f88d8ed112491ba1c87d15). Paths below are relative to the configured gateway prefix, not the URL root. The gateway's own REST authentication, mTLS and origin-specific access headers are retained. Workspace binding requires HTTPS except on loopback. Neither the REST reads nor the ticket-bearing WS upgrade follow redirects.

1. Authenticate using the existing client. `POST /api/auth/ws-ticket` returns a single-use `ticket`; `GET /api/ws` offers `hermes-gateway-v1` and `hermes-gateway-ticket.<ticket>` as **subprotocols**, not URL parameters. An already-connected client reuses its existing socket. No API-server bearer is substituted for a dashboard login.
2. Wait for `{"method":"event","params":{"type":"gateway.ready","payload":{…}}}` on that exact socket generation. `payload.session_authority == true` identifies the canonical session protocol. It does **not** advertise Git, plugin, terminal or write permissions. `gateway.capabilities` is not a catalogue: its pinned result has `per_session_exclusive_submit`.
3. For a session, `GET /api/sessions/{stored-id}?profile=P` returns a row, **not** a `session` envelope. Match `id` exactly, not a prefix or lineage alias; verify the server-stamped `profile`. Capture its `cwd` (`String?`) and `git_metadata_generation` (`int?`). `expectedCwd` is a comparison, never an override. A missing cwd does not become the profile default. Reject relative paths, dot components, encoded fallback paths and ambiguous spellings; do not resolve paths using the client OS. This is an absolute *server-reported* path, not client-side proof about links or file revisions.
4. Only a successful `session.create`/`session.resume` **on this socket** can associate a runtime `session_id` with an explicit `stored_session_id` (top level or `info.stored_session_id`). The adapter does not call either to discover features. No live binding means no live-session operation. A coordinator's separate socket is not interchangeable. A close, socket replacement or binding replacement invalidates its evidence.
5. `target.read(WorkspaceRead.x) → Future<Object?>` performs the named operation. `target.probe(x) → Future<WorkspaceFailure?>` performs the same operation and discards the result; `null` means that **operation** succeeded. Prefer `read` if the data is needed. Do not probe all operations on launch. In particular, probe the terminal-ticket issuer only on explicit user intent. There is no speculative write or global capability cache.

| Read | Request | Successful value / meaning |
|---|---|---|
| `profiles` | RPC `profiles.list`, `{include_sessions:false, profile?:P}` | `{profiles:[{name:String,…}], install_id?:String, bot_mode_protocol?:bool}`. Machine roster, limited by the serving gateway. No history fetch. |
| `defaultDirectory` | `GET /api/fs/default-cwd?profile=P` | `{cwd:String, branch:String?}`. Profile file browser's default, **not** a session cwd. |
| `gitStatus` | `GET /api/tools/terminal/backends?profile=P` must report `active:"local"`; then `GET /api/git/status?path=<bound cwd>&profile=P` | `null` or `{branch,defaultBranch,detached,ahead,behind,staged,unstaged,untracked,conflicted,changed,added,removed,files:[…]}`. `path` is the host-side selector, not `session_id`. No caller-supplied path or inferred local fallback. |
| `pendingApprovals` | RPC `approval.pending`, `{session_id:<bound runtime>, profile?:P}` | `{approvals:[{request_id,command,description,…}]}`. Read only. No delivery acknowledgement, response, grant, or reply to a pending server request. |
| `processes` | RPC `process.list`, same live-session params | `{processes:[…]}`. Read-only process roster; neither a PTY nor authority to write stdin. |
| `dashboardPlugins` | `GET /api/dashboard/plugins?profile=P` | **Array** `[{name:String,…}]` filtered by upstream visibility and consent. Not the machine-level `plugins.list` RPC, not desktop JS permission. Never evaluate returned content. |
| `terminalBackends` | `GET /api/tools/terminal/backends?profile=P` | `{active:String, backends:[{name,label,description,active,status,detail}]}`. `active` names the agent's tool execution backend; it is not shell access. |
| `hostTerminalTicket` | `POST /api/webapp/socket-ticket?socket=host-terminal` (no body) | Server: `{ticket:String, ttl_seconds:int}`. Adapter: **`true` only**. Discards the ticket without opening a shell. The issuer does not check a terminal profile at mint time. PTY availability, profile admission and ownership are separate at upgrade/attach. |

All RPCs are `{"jsonrpc":"2.0","id":n,"method":m,"params":{…}}`; tables show the inner `result`. Omit `profile` if unresolved; when a session row resolves it, use that exact name. Session-scoped reads revalidate before dispatch and after the reply. REST response bodies are limited to 2 MiB. Treat payloads as untrusted application data, not diagnostics: do not log transcripts, commands, paths, manager details or raw errors. Server error bodies and transport exception strings do not cross the workspace boundary.

`WorkspaceFailure` distinguishes `stale` (locally revoked owner/selection/socket), `mismatch` (route or server identity/cwd differs), `unbound` (required session/host directory absent or unsuitable), `unsupported` (unknown method or optional route unavailable), `denied` (auth/access), `invalid` (malformed reply, ID or path), `insecure` (unsafe transport) and `unavailable` (other failure). A 404 on a *session row* is unbound, not evidence that a whole feature is missing. No fallback to another host, retry of the operation or downgrade from TLS.

## Downstream integration

- **Fleet / management:** keep the issuing owner with each roster or job. For example, `final t = await pane.bind(owner.route()); final roster = await t.read(WorkspaceRead.profiles);`. Retain `install_id` when the server supplies it; a profile display name is not a machine ID. An *Applies to* switch needs its own profile-bound owner rather than a `profile` override on somebody else's target.
- **Git / files:** keep the session row's route with the diff/editor, bind with its displayed cwd, and refresh on a mismatch. Implement each new audited GET or mutation below the owner boundary with its **actual** scope and response schema. A green status read is no evidence for commit/push, writability, sandbox mounts or conflict-free edits. File overwrites need their own server revision or conflict policy.
- **Approvals:** use `pendingApprovals` for discovery; keep responses on the existing delivering socket, request identity and explicit choice. Neither `probe` nor a roster item is authority to approve. An unbound or replaced runtime must not borrow the same ID from another socket.
- **Plugins:** `dashboardPlugins` is discovery only. Preview origins, install consent and contribution grants are separate authorities. Never pass a workspace owner or transport into guest code.
- **Browser preview:** `target.sharePreview` registers the live runtime on the chat socket that acknowledged it. The socket answers inbound `preview.read` and `preview.act` (`elements`, `scroll`) only while that registration and document are current. Replays, another runtime, vault/type/eval/click actions and a closed selection are refused on the socket. The page is loaded by a separate credential-free client; it never receives the gateway, a cookie, a script bridge, a signed-in browser profile or an injected login. Navigation is back/forward/reload inside an explicitly approved origin. The reader console copies the selected lines, or every line when none are selected, and can stage that text into the composer without sending. Chromium DevTools, pop-out tabs and dev-server restart are not part of this reader.
- **PTY:** `hostTerminalTicket` tests the issuer only. An actual user-requested terminal needs a **fresh** operation-specific ticket hidden inside its transport, the same origin and the selected profile, and must validate the server-assigned terminal ID. The upstream endpoint is `/api/host-terminal`, not `/api/pty` (chat TUI) or JSON-RPC `terminal.resize`. Keep a terminal's authority with the terminal on hide/reattach; never start a shell as a probe. No local fallback.
- **New operations:** add explicit typed calls, derive all routing selectors from the bound target, and apply the selection/socket fence immediately before physical dispatch (including after async authentication) and on both success and error. Revalidate session ownership after any await, including confirmation or file selection. Use server preconditions, idempotency and explicit read-back appropriate to the operation; do not blindly retry a mutation after loss of its reply. Do not add a public URL, RPC-name pass-through or shell endpoint.

For a lane-specific typed read, add a `part` to the `remote_workspace.dart` library (one feature file per lane). Implement an extension on `WorkspaceTarget` using `_withOwner(() async { … }, session: true)` for stored-session reads, `live: true` for runtime reads, or neither for profile/connection reads. `_get(['literal', 'segments'], query)` and `_rpc('literal.method', params)` share the pinned dispatch; decode the actual result in that extension. The public method accepts domain arguments, not a path, method name or profile override. Keep state-changing operations out of `probe()`. An ambiguous out-of-order binding acknowledgement invalidates the affected live binding; a fresh create/resume receipt is needed, not a retry of the original user action.

Inspected implementations: `tui_gateway/ws.py`, `tui_gateway/methods_profiles.py`, `tui_gateway/methods_prompt.py`, `tui_gateway/methods_tools.py`, `apps/shared/src/gateway-contract.openrpc.json`, `hermes_cli/dashboard_auth/routes.py`, `hermes_cli/web_routers/{sessions,files,git,dashboard_ui,tools,webapp}.py`, `hermes_cli/web_server_chat.py`, `hermes_cli/web_git.py` and `persistence/conversation/sessions.py` at the pin.

## Projects and session files

Profile reads stay on `ProjectSettingsActions` and `WorkspaceRepositoryDiscovery`. `projects.discover_repos` is explicit and read-only: the pinned `config.set` contract has no repository-scan setter, so include, exclude and hide are presentation preferences on this device. They do not delete a repository or change the gateway. A project idea is the stored project description. This client does not create `IDEA.md` through the unconditional text-write route.

Session files use `SessionWorkspaceFiles` on the stored-session route. Listings and reads stay under the verified host cwd and require the local terminal backend. `gitIgnored` is optional. `changeCwd` re-reads the mutation snapshot and then sends `session.mutate` operation `workspace` with only `session_id`, `request_id`, `expected_revision`, `expected_generation`, `operation` and `payload`. The pinned owner rejects any extra field, including `profile`. Rebind after a successful move; the old target keeps its previous cwd.

Saving uses `POST /api/fs/replace-text-v1` from `server-patches/0002-confirmed-text-v1.patch`. Ignored flags use `server-patches/0003-list-git-ignored.patch` on `GET /api/fs/list?git_flags=true`. Neither patch is installed by Ares. A missing route, a conflict or a lost reply leaves the draft in place. Do not fall back to `/api/fs/write-text`. v1 admits an existing immediate child of a private macOS APFS session directory only.

## Git review and shipping

Git operations are named methods on `SessionGit`, the extension of `WorkspaceTarget` in `workspace_git.dart`. The bound session directory is the only path. A caller cannot pass a repository path, a profile override, a shell string or a git argument vector. Every call rechecks the local terminal backend and the stored session before and after the request.

Reads: `GET /api/git/review/list`, `review/diff`, `review/commit-context`, `review/rev-parse` (HEAD only), `review/ship-info`, `worktrees`, `branches` and `base-branches`. Mutations: `POST /api/git/review/stage`, `unstage`, `revert`, `commit`, `push`, `create-pr`, `worktree/add`, `worktree/remove` and `branch/switch`. Branch and last-turn scopes are read-only. Last turn requires a captured HEAD sha, not an arbitrary ref. Commit messages drafted in the app are built from the changed paths in `commit-context`; Ares does not call a model to write them. Creating a pull request posts only `{path}` and shows the URL the gateway returns. The app does not launch that URL unless it is http(s) and the user taps Open.

Classic chat and NextGen chat both open this review from the shared session-files surface and from a changed-files card on the latest settled turn. Project lanes with a session open the same pane. Following a worktree uses the existing `session.mutate` workspace move, then rebinds. Pinning the lane keeps the current directory. `DashboardClient.workspaceGitPost` rejects every operation outside that list.

**Verification scope:** `test/git_review_operations_test.dart` drives both production adapters against a loopback gateway that shells to real `git` in a temporary repository and a private bare remote. It covers a last-turn diff, stage, unstage, revert, commit, branch switch, worktree create/remove, follow, push and a local pull-request record. The executable list is only `git`. `test/turn_changed_files_test.dart` covers the turn card derivation. These are macOS-hosted Flutter tests, not packaged or on-device Android, Apple, Linux or Windows gates, and not a hosted Hermes or an external forge.

**Verification scope:** `test/remote_workspace_wire_test.dart` exercises both production adapters with disposable password/cookie/ticket servers. `test/workspace_profiles_navigation_test.dart` taps both production More entries, refreshes the visible roster and verifies revocation. The pinned upstream `web_git.repo_status` was also executed independently on a throwaway repository: one untracked `hello.txt`, `changed:1`, `added:1`. These are client/handler tests, not a deployed multi-service Hermes installation, native device run, PTY session or release acceptance. No dependency or lockfile change, new licence obligation, backend installation, or local inference.

## Session history

History operations are named methods on `SessionHistory`, the extension of `WorkspaceTarget` in `session_history.dart`. The bound stored session is the only id. A caller cannot pass a profile override, a filesystem path, or an arbitrary RPC name.

Branch and rewind use `session.mutate` with `operation` `branch` or `rewind`, the snapshot's revision and generation, and the selected saved `row_id` (`through_message_id` or `target_message_id`). The row must be in the `session.history` result read in that same owner turn. Neither call is sent until the user confirms. Rewind changes the conversation only. It does not restore files.

Lineage comes from `session.list`. A row with `_reset_from` is a new conversation. A row with `_branched_from`, or a legacy `parent_session_id` and no reset, is a fork. Rows that share `_lineage_root_id` are one compressed conversation, not siblings.

`rollback.list` and `rollback.diff` describe filesystem checkpoints. `rollback.restore` is sent only after a second confirmation. A restore without a file sets `all: true` and can also remove later chat messages. Diff text is redacted before it is shown.

`session.export` asks the owner for the complete JSON, Markdown or HTML transcript. With redaction on, this device removes token-shaped text again before the share sheet sees it.

`session.foreign.list`, `preview` and `import` use the host's opaque 64-character handle on the bound owner and profile (`session: route.storedSessionId != null`). A path is rejected before it is sent. Metadata (`title`, `cwd`, `excerpt`) and preview turns are redacted before the page can show them. Importing happens on the host: the page provides source filtering, search, `next_offset` pagination, a redacted preview, explicit import confirmation and opening the resulting session, and reports a clear unsupported state when a gateway refuses the method (`-32601`). No filesystem path or device-picked file is sent. `test/session_history_wire_test.dart` and `test/foreign_import_widget_test.dart` cover both Classic and NextGen. These are macOS-hosted Flutter tests, not on-device Android, Apple, Linux or Windows gates.
