# Managed fleet SSH — pinned contract audit

## Decision already settled

Sam approved trust on first use and then authorised the gateway-API-limited UX below. This audit does **not** reopen that decision. Ares offers an honest managed first-use warning alongside the independently pinned direct OpenSSH path. Its shared managed screen starts/attaches and disconnects saved gateway SSH hosts, shows one elapsed pending state and the reported tunnel status, and requires external verified key repair followed by confirmed Retry after a changed-key block.

The remaining issue is the difference between native Desktop's Electron bridge and the gateway's remotely callable REST API at **`b7ee21c14e38316273f88d8ed112491ba1c87d15`**. They do not expose the same capabilities.

## Reproducible evidence

From the Ares checkout:

```sh
python3 tool/audit_managed_ssh_contract.py /path/to/hermes-agent
```

The audit reads the pinned revision with `git show`, checks Python ASTs and the TypeScript bridge sources, and prints the actual route signatures, response fields and source SHA-256 hashes. It does not import Hermes, start a gateway, make an HTTP request, open SSH or use accounts. It passed locally. These are source-contract assertions, **not** Flutter or live SSH acceptance tests.

## Available gateway contract

`hermes_cli/web_routers/gateway_connections_reach.py`:

| Method | Path | Input | Result |
|---|---|---|---|
| GET | `/api/gateway-connections/{connection_id}/ssh` | Registry ID only | `ok`, `connected`, and the tunnel view if present |
| POST | Same | Registry ID only; no request-body parameters | Awaits `ensure_tunnel`, then returns the tunnel view |
| DELETE | Same | Registry ID only | `ok`, `disconnected`; tears down the forward **and owned remote serve** |

The tunnel view in `hermes_cli/gateway_connections_ssh.py:tunnel_status` contains exactly `localPort`, `remotePort`, `pid`, `reused`, `hermesVersion`, `host`. It does not report a host-key fingerprint, job ID, logs or bootstrap phases. The internal `_fingerprint(connection)` is a tuple of saved connection configuration fields, **not an SSH key fingerprint**. Do not expose it as proof of trust.

`gateway_connections_ssh_transport.py:base_ssh_options` uses `StrictHostKeyChecking=accept-new` and `BatchMode=yes`. Changed-key errors are classified as `host-key-changed`, mapped to HTTP 502 with `detail: {message, kind}`. There is no password/passphrase request in this REST contract. First-use trust belongs to OpenSSH's known-hosts configuration on the **serving gateway**, not to the phone or Ares's pinned-key file.

## Requirements that cannot be implemented as native Desktop parity over this API

1. **Bootstrap progress/log parity:** POST is one awaited threadpool operation, not an event stream or cancellable job. GET reports an established tunnel, not intermediate progress. Ares can truthfully display a single pending state, but cannot reconstruct native Desktop's logs or phases.
2. **Cancellation:** `ensure_tunnel` and `disconnect` hold the same per-connection lock. DELETE during POST waits for bootstrap to finish and then tears down the owned serve. It does not interrupt bootstrap. Abandoning the local HTTP future also does not cancel the gateway's thread. A UI labelled simply “Cancel” must not imply remote execution has stopped. A queued disconnect is possible only if explicitly described and authorised as such, including the serve teardown consequence.
3. **Confirmed re-trust:** no route accepts a replacement host key, fingerprint, trust-reset flag or known-hosts mutation. Ares must not pretend that clearing a local preference re-trusts the gateway's key. The upstream mismatch message asks an operator to verify the change and remove the old key on the gateway. Ares could show instructions and a confirmed retry **after external repair**, but that is not an in-app key replacement operation.
4. **Managed update/recovery:** `apps/desktop/src/store/managed-updates.ts` calls `window.hermesDesktop.connections.updateManaged`. Its capability check explicitly hides the section when that native bridge is absent. `apps/desktop/src/lib/browser-saved-connections.ts` exposes no `updateManaged`; there is no equivalent in the pinned gateway SSH router. Reusing `/api/actions/update` is not the transactional SSH drain/update/restore operation and would violate the existing fleet-update boundary.
5. **Adoption into a usable remote chat:** the browser saved-connection bridge explicitly excludes SSH from reachable roster kinds (`remote`, `cloud`) and refuses SSH roster discovery. Starting a tunnel is not by itself parity with a fully adopted chat owner. Any additional relay/ticket/socket work must be separately verified against the relay producer, not inferred from a returned `localPort` on the gateway.

The remote connection implementation also requires Hermes to be installed already (`hermes-not-found` otherwise). “Bootstrap” here starts or attaches an isolated owned `hermes serve`; it is not an installer for an empty host.

## Authorised release scope

Use the **gateway-API-limited** implementation: one elapsed pending state, an explicit no-fingerprint warning, no interrupting cancellation or invented logs, operator-assisted changed-key repair followed by confirmed retry, and no native-only managed SSH update/recovery controls. Leaving the page does not stop the remote operation. Explicit disconnect after completion is separately confirmed because it stops the gateway-owned serve.

Do not invent request parameters, shell out on the gateway to reset trust, tunnel arbitrary ports, weaken the strict pinned path, or mark missing operations successful. Flutter acceptance results belong in the task handoff; the audit alone is not feature validation. No real hosts, accounts, hosting or inference are needed for the fake-gateway tests.
