# Remote provider administration and consented Nous billing

Classic More and NextGen More both open the same screen. It talks to the selected profile's dashboard for keys, named endpoints, delegation and mixtures, and to the already connected gateway socket for chat presets and billing. It does not install a local model, download weights, or open the external dashboard.

## What a control does

- **API keys.** `GET/PUT/DELETE /api/env`, limited to provider-category key variables. A save is marked `provider_setup`. The typed value is not shown again.
- **Accounts.** The existing provider sign-in screen still starts a host-managed device login. Disconnect is `DELETE /api/providers/oauth/{id}` and only when that catalog row says `disconnectable`.
- **Named endpoints.** Create, replace, delete and activate `/api/providers/custom-endpoints`. Test calls `/validate` with the selected API mode (empty for Auto, or chat completions, Codex responses, or Anthropic messages) and shows the transport the gateway actually checked. Remote addresses must be HTTPS. HTTP is accepted only for localhost.
- **Presets.** Effort and fast are remembered per provider and model on this device. Apply sends `config.set` for `reasoning` and `fast` on one chat id, after confirmation. Nothing is written to the profile default when no chat id is given.
- **Route clamp.** `session.info`'s `reasoning_effort_wire` is shown only when it differs from the picked level. An empty wire is unknown, not a guessed clamp. NextGen's composer and Classic's context chip use the same rule when a session info event arrives.
- **Delegation.** `GET /api/delegation/routing`, then the backend, model-route and profile-route writes. Unknown route fields are sent back. Limits are a deep-merge of `delegation.max_iterations`, `delegation.max_concurrent_children`, `delegation.child_timeout_seconds` and, when chosen, `delegation.reasoning_effort`.
- **Mixture.** The active preset's references, aggregator, enabled flag and degraded-reference policy are edited. Other preset fields are round-tripped. An incomplete slot is not saved.
- **Billing.** `billing.state` and `subscription.state` on the live socket. Buy credits, auto-reload and keep-going-on-credits run only after confirmation and only when the gateway's eligibility fields allow them. A credit amount has to be one of `charge_presets`. Plan preview uses `subscription.preview`; confirm uses `subscription.change` only when the preview effect is `scheduled`. An immediate charge, a blocked change, or a no-op is explained and not confirmed. There is no store purchase and no portal launch.

## Limits

Tests are macOS-hosted Flutter tests against disposable fixtures. They are not packaged or on-device runs, and they do not contact a personal gateway or a payment provider. Copy added for this screen is English. Local inference stays out of scope.
