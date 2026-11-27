# Confirmed remote text edits (v1)

`0002-confirmed-text-v1.patch` is an optional Hermes **server** patch, not a service or an Ares-side write fallback. Its base is `b7ee21c14e38316273f88d8ed112491ba1c87d15`. The patch and companion tests are distributed under the [upstream MIT license](confirmed-edit-LICENSE), copyright 2025 Nous Research. Do not apply to an unreviewed upstream revision.

## Client contract

Read with existing `GET /api/fs/read-text` using the explicit profile, exact stored session ID and literal absolute path. Do not edit a binary/truncated preview or one that resolved to another path. Keep the original UTF-8 byte hash (no newline or Unicode normalization). After user confirmation send `POST /api/fs/replace-text-v1?profile=P`, `Content-Type: application/json`:

```
{"session_id":"<stored id>","cwd":"<canonical session cwd>","path":"<absolute file>","expected_sha256":"<64 lowercase hex digits>","content":"<replacement>"}
```

A confirmed response is exactly `{"ok":true,"path":"<same absolute file>","sha256":"<new UTF-8 byte hash>"}`. `409` means reopen and reconcile, not “retry the POST.” A conflict can be detected **after publication**. A lost response or I/O error is also not proof the edit did not happen. On `404`/`405` (older gateways), `501` (unsupported host), permission rejection or any ambiguous result, keep the draft. Never retry via `/api/fs/write-text`, upload, an agent command, or a redirected URL. This patch does not disable upstream routes for other clients.

## Which writes are admitted

- Non-root macOS gateway, local APFS, native exclusive/no-follow/beneath rename support. **Only an existing immediate child of the stored cwd**; the directory must be owned by the service user, mode `0700`, without an ACL. Linux, Windows, containers/remote terminal backends, nested paths and shared workspaces are not portable fallbacks. A pinned nested parent can be moved outside an otherwise authorized cwd; a fresh path walk can select a different parent. V1 refuses that case.
- Explicit profile and verified, current physical session row, checked against the profile's creation receipt, principal, route, current lineage target and restored launch policy. GUI/CLI/TUI local policies with the `file` toolset only. Both the frozen and current terminal policies, and in-process task overrides/environments, must permit local use. Legacy rows without verifiable receipts, isolated/ACP sessions, missing owners and ambiguous identities are not eligible.
- Existing HTTP authentication and native profile scoping still apply. The native scope gate checks the query; only the bounded handler reads this route's JSON, and rejects any extra body field (including `profile`). Hosted/locked-root, sensitive-file, upstream read/write-denied and approval-required paths are checked; no staged-file exemption. The upstream SQLite offline-access lock covers raw descriptor lifetimes. Common database/sidecar names are excluded even when not registered as live.
- Maximum 512 KiB for **both** files; strict UTF-8, no NUL or binary preview, owner-readable/writable, single-link, no flags, ACL, xattrs or special mode bits. Basename must not be hidden; path aliases, symlinks and noncanonical case/spelling are rejected. Replacements retain ordinary mode and group; group mismatch is refused rather than silently changing ownership.

## Publication and recovery

The server creates a fresh owner-private `.ares-replace-v1-<random>/` in the workspace. `target` identifies the original name; `new` is the staged, synced replacement. `original` is the **displaced inode**, not a later copy. The server checks its identity, metadata and bounded bytes in custody, rechecks authority and publishes `new` using a kernel **no-replace** rename. A successful operation checks the visible directory entry and rereads the published bytes. An external writer that creates the public name first wins. On a pre-publication failure the server restores `original` only if the name remains vacant and the workspace still matches.

There is a **vacancy interval**: readers can see `ENOENT`. This is not a general atomic filesystem compare-and-swap. An external write through an old open descriptor remains on the named `original` inode, even after a successful response. The server does not merge that write into the new document. A content hash cannot distinguish a file that was changed and changed back before the request. Profile/session checks are repeated admission checks, not a transaction spanning the database and filesystem. The operator, service UID and private recovery area must be trusted; this is not protection against root or another process deliberately tampering with same-UID private state.

After a crash, conflict, or uncertain reply, **do not automatically replay the edit or restore over an occupied name**. Quiesce local writers, inspect `target`, `original`, any `new`, and the current file on the gateway; recover or merge deliberately. The original is retained on success and on failed restoration. Its directory is excluded by the file-browser sensitivity guard and has its own `.gitignore`, but OS backups/sync tools may still archive it. There is deliberately no automatic deletion policy: recovery data uses disk until the operator retires it after writers have closed. File data and directories are `fsync`ed at phase boundaries. Process death can leave an unfinished phase, and no whole-operation or drive-cache/power-loss guarantee is claimed.

## Disposable verification

From the Ares checkout, on a compatible host with an existing Hermes dependency environment:

```sh
python3 -B server-patches/verify_confirmed_text_v1.py \
  --upstream "$HOME/.hermes/hermes-agent" \
  --python "$HOME/.hermes/hermes-agent/venv/bin/python"
```

The runner exports only pinned source into `server-patches/.dart_tool`, runs `git apply --check` and applies the diff **only in that copy**. Tests create a disposable profile with real Hermes session rows and launch receipts and invoke the actual read and patched save handlers. Authentication at the direct handler boundary is a test double; the native profile gate is also exercised separately. Races use real APFS mutations/open file descriptors with controlled ordering. No install, listener, live profile, gateway credential or end-to-end network claim. The test interpreter blocks process creation and socket connect/bind; an unsupported acceptance host is a failing test, not a green skip.
