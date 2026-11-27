# Capability lifecycle

Skills, plugins, connectors, tool backends, the browser credential vault and
profile policy use the authenticated gateway that already owns the connection.

- Dashboard reads and writes carry `profile` when the connection has one.
- JSON-RPC stays on that connection's socket. A profile argument selects the
  profile on that socket; it does not choose a different machine.
- A hub skill install scans first. A blocked scan is not installed. A caution
  scan is installed only after Install anyway.
- A plugin update that returns `consent_required` or `scan_blocked` changes
  nothing until the user accepts the new capabilities or forces a caution.
- Adding an MCP server reads `mcp_servers` from config without defaults, refuses
  to replace an existing name, and writes the whole map back.
- Tool grants use the member policy revision. With no member revision, the
  control stays disabled.
- Vault passwords, authenticator keys and card data are sent only as the
  `vault.add` or `vault.unlock` secret. They are not listed and are scrubbed
  from errors.
- Agent policy writes the approvals, allowlist, checkpoints and browser fields.
  Shared metrics use `shared_metrics.set` and never send while disabled.
- Folder and website approvals are separate cards from command approvals.
  Read versus read-write is shown only when the gateway says which.
- Folder and preview-script grants stored by the Desktop app on the gateway
  computer have no remote API. Removing a plugin or its desktop half is the
  gateway operation. Those local grants stay on that computer.
