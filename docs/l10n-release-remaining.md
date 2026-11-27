# Residual release-localisation audit

## Scope and result

- Write ownership: **only `lib/main.dart`**. It is the only Dart file under `lib/` outside `lib/core/**`, `lib/nextgen/**`, and `lib/l10n/**`.
- Read-only inventory: **436 core/NextGen Dart files**; **3454 candidate literals** inspected by lexical inventory plus manual sink checks. Counts are inventory evidence, not proof that every runtime error path is localized.
- Explicit exclusions: `lib/core/screens/chat_screen.dart`, `lib/nextgen/ui/chat_view.dart`, `lib/core/preview/**`, and `lib/core/terminal/**` are concurrently owned and not included in findings. `core/workspace/terminal_page.dart` and `ssh_terminal_dialog.dart` are outside those directory exclusions and are audited **read-only** here.
- Remaining findings below: **616 literal occurrences in 11 direct UI files**, **318 client-authored downstream literal occurrences in 28 files**, and **18 raw status/diagnostic display sites**. These are source occurrences, not distinct strings or translation-key counts; adjacent literal fragments and duplicate button labels are intentionally counted separately.
- No core/NextGen source, ARB, generated localization, tests, Git index or commits were changed by this worker. No tests, analyze, generator or build were run.

## Owned work (`lib/main.dart`)

- LAN discovery button and sheet title, empty result and failure wrapper use new shared `release_misc_*` keys. Discovery retains its exception and resolves the label while rendering rather than retaining an English sentence.
- Connection label defaults reuse `nav_home`, seeded once in `didChangeDependencies` (never inherited localization access in `initState`; existing/imported/user-edited labels remain untouched).
- Host example hint reuses `example_host_hint`.
- All three Classic health-check presentation paths now resolve the structured `ApiHealthCheckResult` through five shared release keys instead of its English `userMessage` method. The helper leaves endpoint/status values intact and preserves the existing 401/403/404/other HTTP/network branches.
- Registry: `.dart_tool/l10n-release/misc-strings.json` — **8 keys**, English values, descriptions and explicitly typed `String`/`int` placeholders. Parent must integrate, translate and generate before compile/analyze.
- Retained literal exceptions: brand `ARES`, font `Cinzel`, example URL `https://hermes-desktop.example.lan`, certificate PEM recognition markers, and three internal `Certificate file too large.` exceptions. Those three are caught by `_pickCertificateIdentity` and replaced with existing `certificate_import_failed`; their English text is not displayed by that path.
- **Known remaining upstream English on owned screens:** `ConfigImportResult.summary`, `ConfigBackupException.message`, `ClientCertificateImportException.message`, and LAN timeout diagnostics still originate in read-only services. Their exact sources are listed below (and the additional diagnostics section). Do not claim every message reachable from `main.dart` is localized.

## A. Confirmed direct UI English (read-only)

Sensitive/consent-bearing screens were not modified. Translate display copy without translating capability IDs, backing enum/wire values, keys, signatures or request payloads; do not change admission/consent behavior. For interpolation expressions, app-authored words need localization while server/user content remains literal.

| File:line | Exact source expression/literal |
|---|---|
| `lib/core/capabilities/capability_pages.dart:38` | `'Capabilities'` |
| `lib/core/capabilities/capability_pages.dart:42` | `'Skills'` |
| `lib/core/capabilities/capability_pages.dart:43` | `'Plugins'` |
| `lib/core/capabilities/capability_pages.dart:44` | `'Connectors'` |
| `lib/core/capabilities/capability_pages.dart:45` | `'Backends'` |
| `lib/core/capabilities/capability_pages.dart:157` | `'Install blocked ($verdict): $detail'` |
| `lib/core/capabilities/capability_pages.dart:159` | `'Scan verdict: $verdict. Confirm $requested before installing.'` |
| `lib/core/capabilities/capability_pages.dart:160` | `'The gateway has not confirmed that $requested is installed.'` |
| `lib/core/capabilities/capability_pages.dart:183` | `'Edit ${skill.name}'` |
| `lib/core/capabilities/capability_pages.dart:192` | `'Cancel'` |
| `lib/core/capabilities/capability_pages.dart:196` | `'Save skill'` |
| `lib/core/capabilities/capability_pages.dart:212` | `'Archive ${skill.name}?'` |
| `lib/core/capabilities/capability_pages.dart:214` | `'The skill is archived and can be restored with hermes curator restore.'` |
| `lib/core/capabilities/capability_pages.dart:219` | `'Cancel'` |
| `lib/core/capabilities/capability_pages.dart:224` | `'Archive'` |
| `lib/core/capabilities/capability_pages.dart:243` | `'Hub identifier'` |
| `lib/core/capabilities/capability_pages.dart:251` | `'Install'` |
| `lib/core/capabilities/capability_pages.dart:257` | `'Install $_cautionFor anyway'` |
| `lib/core/capabilities/capability_pages.dart:262` | `'Update all'` |
| `lib/core/capabilities/capability_pages.dart:282` | `'Unlock'` |
| `lib/core/capabilities/capability_pages.dart:282` | `'Lock'` |
| `lib/core/capabilities/capability_pages.dart:291` | `'Edit'` |
| `lib/core/capabilities/capability_pages.dart:297` | `'Archive'` |
| `lib/core/capabilities/capability_pages.dart:371` | `'This update adds capabilities. Nothing changed yet.'` |
| `lib/core/capabilities/capability_pages.dart:373` | `'The scan blocked this plugin.'` |
| `lib/core/capabilities/capability_pages.dart:374` | `'The plugin was not changed.'` |
| `lib/core/capabilities/capability_pages.dart:383` | `'Install $name despite the scan?'` |
| `lib/core/capabilities/capability_pages.dart:385` | `'The security scan blocked $name. This confirmation applies only to $name.'` |
| `lib/core/capabilities/capability_pages.dart:390` | `'Cancel'` |
| `lib/core/capabilities/capability_pages.dart:395` | `'Install $name anyway'` |
| `lib/core/capabilities/capability_pages.dart:416` | `'Repository'` |
| `lib/core/capabilities/capability_pages.dart:429` | `'Install plugin'` |
| `lib/core/capabilities/capability_pages.dart:435` | `'Update plugins'` |
| `lib/core/capabilities/capability_pages.dart:445` | `'Accepting capabilities does not override the scan of $name.'` |
| `lib/core/capabilities/capability_pages.dart:457` | `'Accept capabilities'` |
| `lib/core/capabilities/capability_pages.dart:463` | `'Review scan for $_pendingName'` |
| `lib/core/capabilities/capability_pages.dart:472` | `'${plugin.description}\nFolder and preview-script grants stay in the Desktop app on that computer. Removing the plugin here does not revoke those local grants.'` |
| `lib/core/capabilities/capability_pages.dart:488` | `'Update'` |
| `lib/core/capabilities/capability_pages.dart:499` | `'Remove'` |
| `lib/core/capabilities/capability_pages.dart:504` | `'Remove ${plugin.name}?'` |
| `lib/core/capabilities/capability_pages.dart:508` | `'Cancel'` |
| `lib/core/capabilities/capability_pages.dart:513` | `'Remove'` |
| `lib/core/capabilities/capability_pages.dart:537` | `'Remove desktop half'` |
| `lib/core/capabilities/capability_pages.dart:614` | `'Server name'` |
| `lib/core/capabilities/capability_pages.dart:619` | `'Command'` |
| `lib/core/capabilities/capability_pages.dart:624` | `'HTTP URL'` |
| `lib/core/capabilities/capability_pages.dart:641` | `'Add server'` |
| `lib/core/capabilities/capability_pages.dart:659` | `'Probe'` |
| `lib/core/capabilities/capability_pages.dart:667` | `'Probe ${server.name}: ${probe.tools.join(', ')}'` |
| `lib/core/capabilities/capability_pages.dart:668` | `'Probe failed.'` |
| `lib/core/capabilities/capability_pages.dart:675` | `'Logs'` |
| `lib/core/capabilities/capability_pages.dart:697` | `'MCP log'` |
| `lib/core/capabilities/capability_pages.dart:702` | `'Connector'` |
| `lib/core/capabilities/capability_pages.dart:706` | `'Account alias'` |
| `lib/core/capabilities/capability_pages.dart:719` | `'Link account'` |
| `lib/core/capabilities/capability_pages.dart:729` | `'Remove account'` |
| `lib/core/capabilities/capability_pages.dart:742` | `'Tool connector'` |
| `lib/core/capabilities/capability_pages.dart:758` | `'Load tools'` |
| `lib/core/capabilities/capability_pages.dart:793` | `'Save tool grants'` |
| `lib/core/capabilities/capability_pages.dart:794` | `'Save tool grants for $_grantConnector'` |
| `lib/core/capabilities/capability_pages.dart:799` | `'This policy has no member revision, so tool grants stay unchanged.'` |
| `lib/core/capabilities/capability_pages.dart:865` | `'Backends for ${_setup!.name}'` |
| `lib/core/capabilities/capability_pages.dart:871` | `'Active'` |
| `lib/core/capabilities/capability_pages.dart:885` | `'Use'` |
| `lib/core/capabilities/capability_pages.dart:897` | `'Run setup'` |
| `lib/core/capabilities/capability_pages.dart:901` | `'Terminal backends'` |
| `lib/core/capabilities/capability_pages.dart:907` | `'Active'` |
| `lib/core/capabilities/capability_pages.dart:914` | `'Use ${backend.label}?'` |
| `lib/core/capabilities/capability_pages.dart:917` | `'This changes the terminal backend for this profile.'` |
| `lib/core/capabilities/capability_pages.dart:923` | `'Cancel'` |
| `lib/core/capabilities/capability_pages.dart:928` | `'Use backend'` |
| `lib/core/capabilities/capability_pages.dart:942` | `'Select'` |
| `lib/core/capabilities/capability_pages.dart:1055` | `'Browser vault'` |
| `lib/core/capabilities/capability_pages.dart:1061` | `'Saved site logins, addresses and cards. Passwords stay in the secure fields and are not listed here.'` |
| `lib/core/capabilities/capability_pages.dart:1073` | `'Remove saved item'` |
| `lib/core/capabilities/capability_pages.dart:1078` | `'Delete this item?'` |
| `lib/core/capabilities/capability_pages.dart:1083` | `'Cancel'` |
| `lib/core/capabilities/capability_pages.dart:1088` | `'Delete'` |
| `lib/core/capabilities/capability_pages.dart:1109` | `'Unlocked'` |
| `lib/core/capabilities/capability_pages.dart:1109` | `'Locked'` |
| `lib/core/capabilities/capability_pages.dart:1110` | `'Not detected'` |
| `lib/core/capabilities/capability_pages.dart:1130` | `'Unlock ${source.label}'` |
| `lib/core/capabilities/capability_pages.dart:1136` | `'Master password'` |
| `lib/core/capabilities/capability_pages.dart:1143` | `'Cancel'` |
| `lib/core/capabilities/capability_pages.dart:1148` | `'Unlock'` |
| `lib/core/capabilities/capability_pages.dart:1167` | `'Lock'` |
| `lib/core/capabilities/capability_pages.dart:1167` | `'Unlock'` |
| `lib/core/capabilities/capability_pages.dart:1175` | `'Login'` |
| `lib/core/capabilities/capability_pages.dart:1176` | `'Address'` |
| `lib/core/capabilities/capability_pages.dart:1177` | `'Card'` |
| `lib/core/capabilities/capability_pages.dart:1186` | `'Label'` |
| `lib/core/capabilities/capability_pages.dart:1191` | `'Site origin'` |
| `lib/core/capabilities/capability_pages.dart:1197` | `'Identifier'` |
| `lib/core/capabilities/capability_pages.dart:1203` | `'Password'` |
| `lib/core/capabilities/capability_pages.dart:1209` | `'Authenticator key'` |
| `lib/core/capabilities/capability_pages.dart:1215` | `'Street'` |
| `lib/core/capabilities/capability_pages.dart:1219` | `'City'` |
| `lib/core/capabilities/capability_pages.dart:1223` | `'Postal code'` |
| `lib/core/capabilities/capability_pages.dart:1227` | `'Country'` |
| `lib/core/capabilities/capability_pages.dart:1234` | `'Name on card'` |
| `lib/core/capabilities/capability_pages.dart:1240` | `'Card number'` |
| `lib/core/capabilities/capability_pages.dart:1244` | `'Expiry month'` |
| `lib/core/capabilities/capability_pages.dart:1248` | `'Expiry year'` |
| `lib/core/capabilities/capability_pages.dart:1254` | `'Security code'` |
| `lib/core/capabilities/capability_pages.dart:1270` | `'Save'` |
| `lib/core/capabilities/capability_pages.dart:1320` | `'This gateway has no shared-metrics consent method.'` |
| `lib/core/capabilities/capability_pages.dart:1354` | `'Agent policy'` |
| `lib/core/capabilities/capability_pages.dart:1356` | `'Loading policy'` |
| `lib/core/capabilities/capability_pages.dart:1388` | `'Approval timeout'` |
| `lib/core/capabilities/capability_pages.dart:1393` | `'Confirm MCP reloads'` |
| `lib/core/capabilities/capability_pages.dart:1413` | `'Command allowlist'` |
| `lib/core/capabilities/capability_pages.dart:1418` | `'File checkpoints'` |
| `lib/core/capabilities/capability_pages.dart:1437` | `'Checkpoint limit'` |
| `lib/core/capabilities/capability_pages.dart:1442` | `'Browser private URLs'` |
| `lib/core/capabilities/capability_pages.dart:1459` | `'Use my real browser profile'` |
| `lib/core/capabilities/capability_pages.dart:1485` | `'Save policy'` |
| `lib/core/capabilities/capability_pages.dart:1491` | `'Shared metrics for this profile'` |
| `lib/core/capabilities/capability_pages.dart:1504` | `'Send shared metrics'` |
| `lib/core/screens/fleet_ssh_screen.dart:55` | `'Cancel'` |
| `lib/core/screens/fleet_ssh_screen.dart:59` | `'Confirm'` |
| `lib/core/screens/fleet_ssh_screen.dart:86` | `'Pin this SSH host key?'` |
| `lib/core/screens/fleet_ssh_screen.dart:87` | `'${dest.label}\n${key.fingerprint}\nCompare this fingerprint with the host administrator over an independent channel. No connection will be made.'` |
| `lib/core/screens/fleet_ssh_screen.dart:93` | `'Host key pinned.'` |
| `lib/core/screens/fleet_ssh_screen.dart:99` | `'Enroll the host’s public key first.'` |
| `lib/core/screens/fleet_ssh_screen.dart:102` | `'Open an interactive login shell.'` |
| `lib/core/screens/fleet_ssh_screen.dart:103` | `'Read ${mode == 'preview' ? '/' : '/api/health'} on remote 127.0.0.1:$servicePort through an SSH channel.'` |
| `lib/core/screens/fleet_ssh_screen.dart:105` | `'Connect to ${dest.label}?'` |
| `lib/core/screens/fleet_ssh_screen.dart:106` | `'$detail\n${key.fingerprint}\n${id == null ? 'Authenticate with your SSH agent.' : 'Use the selected identity file.'}'` |
| `lib/core/screens/fleet_ssh_screen.dart:147` | `'SSH session closed.'` |
| `lib/core/screens/fleet_ssh_screen.dart:148` | `'SSH session ended without a clean exit.'` |
| `lib/core/screens/fleet_ssh_screen.dart:156` | `'SSH operation failed. Check the destination and identity.'` |
| `lib/core/screens/fleet_ssh_screen.dart:179` | `'Verified SSH'` |
| `lib/core/screens/fleet_ssh_screen.dart:185` | `'This device has no supported system OpenSSH transport. The pinned gateway relay automatically accepts new keys and cannot be used for verified enrollment.'` |
| `lib/core/screens/fleet_ssh_screen.dart:188` | `'SSH host'` |
| `lib/core/screens/fleet_ssh_screen.dart:189` | `'SSH port'` |
| `lib/core/screens/fleet_ssh_screen.dart:190` | `'SSH user'` |
| `lib/core/screens/fleet_ssh_screen.dart:191` | `'Identity file (optional; otherwise use SSH agent)'` |
| `lib/core/screens/fleet_ssh_screen.dart:194` | `'Public host key from administrator (ssh-ed25519)'` |
| `lib/core/screens/fleet_ssh_screen.dart:199` | `'Review host key'` |
| `lib/core/screens/fleet_ssh_screen.dart:202` | `'Remote loopback service port'` |
| `lib/core/screens/fleet_ssh_screen.dart:207` | `'Check gateway over SSH'` |
| `lib/core/screens/fleet_ssh_screen.dart:211` | `'Preview source over SSH'` |
| `lib/core/screens/fleet_ssh_screen.dart:215` | `'Open SSH shell'` |
| `lib/core/screens/fleet_ssh_screen.dart:225` | `'Line to remote shell'` |
| `lib/core/screens/fleet_ssh_screen.dart:239` | `'Disconnect shell'` |
| `lib/core/screens/host_operations_screen.dart:105` | `'Cancel'` |
| `lib/core/screens/host_operations_screen.dart:109` | `'Confirm'` |
| `lib/core/screens/host_operations_screen.dart:121` | `'Update remote Hermes'` |
| `lib/core/screens/host_operations_screen.dart:122` | `'This starts an in-place update on the gateway host for ${widget.route.profile}. '` |
| `lib/core/screens/host_operations_screen.dart:123` | `'It does not update Ares on this device. Success is the matching update receipt, '` |
| `lib/core/screens/host_operations_screen.dart:124` | `'not the host staying reachable.'` |
| `lib/core/screens/host_operations_screen.dart:158` | `'Awaiting matching receipt. Update is still running.'` |
| `lib/core/screens/host_operations_screen.dart:160` | `'Update receipt succeeded.'` |
| `lib/core/screens/host_operations_screen.dart:162` | `'Update committed, with follow-up steps still owed.'` |
| `lib/core/screens/host_operations_screen.dart:163` | `'Update receipt failed.'` |
| `lib/core/screens/host_operations_screen.dart:164` | `'Update receipt refused.'` |
| `lib/core/screens/host_operations_screen.dart:165` | `'Update is still running.'` |
| `lib/core/screens/host_operations_screen.dart:167` | `'Update outcome is unknown. A live gateway is not a successful update.'` |
| `lib/core/screens/host_operations_screen.dart:173` | `'the gateway default'` |
| `lib/core/screens/host_operations_screen.dart:175` | `'Restart remote gateway'` |
| `lib/core/screens/host_operations_screen.dart:177` | `'This restarts the gateway shared by ${shared.join(', ')}. '` |
| `lib/core/screens/host_operations_screen.dart:178` | `'Live turns on this gateway are interrupted. '` |
| `lib/core/screens/host_operations_screen.dart:179` | `'Reconnect afterwards. Reachability is not proof the restart finished.'` |
| `lib/core/screens/host_operations_screen.dart:180` | `'This restarts the remote gateway for $profile. '` |
| `lib/core/screens/host_operations_screen.dart:181` | `'Live turns on this gateway are interrupted. '` |
| `lib/core/screens/host_operations_screen.dart:182` | `'Reconnect afterwards.'` |
| `lib/core/screens/host_operations_screen.dart:190` | `'Restart command is still running.'` |
| `lib/core/screens/host_operations_screen.dart:192` | `'Restart command finished. Reconnect to the host yourself.'` |
| `lib/core/screens/host_operations_screen.dart:193` | `'Restart command failed.'` |
| `lib/core/screens/host_operations_screen.dart:202` | `'$name is still running'` |
| `lib/core/screens/host_operations_screen.dart:204` | `'$name finished'` |
| `lib/core/screens/host_operations_screen.dart:205` | `'$name failed'` |
| `lib/core/screens/host_operations_screen.dart:214` | `'Curator paused.'` |
| `lib/core/screens/host_operations_screen.dart:214` | `'Curator resumed.'` |
| `lib/core/screens/host_operations_screen.dart:220` | `'Reset remote memory files'` |
| `lib/core/screens/host_operations_screen.dart:221` | `'Delete the $targetName memory file on ${widget.route.profile}? This cannot be undone from Ares.'` |
| `lib/core/screens/host_operations_screen.dart:227` | `'Reset $targetName. Removed ${deleted.length} remote file(s).'` |
| `lib/core/screens/host_operations_screen.dart:238` | `'The host did not confirm the bundle was redacted. No link is shown.'` |
| `lib/core/screens/host_operations_screen.dart:270` | `'Host'` |
| `lib/core/screens/host_operations_screen.dart:273` | `'Refresh'` |
| `lib/core/screens/host_operations_screen.dart:283` | `'These controls operate the remote gateway ${widget.connection.label} for '` |
| `lib/core/screens/host_operations_screen.dart:284` | `"${widget.route.profile ?? 'the gateway default'}"` |
| `lib/core/screens/host_operations_screen.dart:285` | `', not this device and not the Ares client update.'` |
| `lib/core/screens/host_operations_screen.dart:291` | `'${_status!.running ? 'Gateway process running' : 'Gateway process stopped'} '` |
| `lib/core/screens/host_operations_screen.dart:297` | `'Host heartbeat is stale (${_status!.heartbeatStaleSeconds}s).'` |
| `lib/core/screens/host_operations_screen.dart:305` | `'Restart remote gateway'` |
| `lib/core/screens/host_operations_screen.dart:310` | `'Update remote Hermes'` |
| `lib/core/screens/host_operations_screen.dart:314` | `'Run Doctor'` |
| `lib/core/screens/host_operations_screen.dart:318` | `'Security audit'` |
| `lib/core/screens/host_operations_screen.dart:329` | `'Check update receipt'` |
| `lib/core/screens/host_operations_screen.dart:332` | `'Remote host logs'` |
| `lib/core/screens/host_operations_screen.dart:347` | `'INFO'` |
| `lib/core/screens/host_operations_screen.dart:347` | `'WARNING'` |
| `lib/core/screens/host_operations_screen.dart:347` | `'ERROR'` |
| `lib/core/screens/host_operations_screen.dart:362` | `'Search host logs'` |
| `lib/core/screens/host_operations_screen.dart:367` | `'Remote host driver'` |
| `lib/core/screens/host_operations_screen.dart:369` | `'Computer Use readiness is the gateway machine\'s driver and OS permissions, not this device.'` |
| `lib/core/screens/host_operations_screen.dart:379` | `'Curator'` |
| `lib/core/screens/host_operations_screen.dart:384` | `'Curator paused'` |
| `lib/core/screens/host_operations_screen.dart:384` | `'Curator running'` |
| `lib/core/screens/host_operations_screen.dart:386` | `'No completed run'` |
| `lib/core/screens/host_operations_screen.dart:392` | `'Run Curator now'` |
| `lib/core/screens/host_operations_screen.dart:395` | `'Reset remote memory files'` |
| `lib/core/screens/host_operations_screen.dart:402` | `'Reset memory file'` |
| `lib/core/screens/host_operations_screen.dart:406` | `'Reset user file'` |
| `lib/core/screens/host_operations_screen.dart:410` | `'Reset both files'` |
| `lib/core/screens/host_operations_screen.dart:421` | `'I agree to upload a redacted diagnostic bundle from the remote host'` |
| `lib/core/screens/host_operations_screen.dart:428` | `'Share redacted diagnostics'` |
| `lib/core/screens/model_admin_screen.dart:21` | `'Auto'` |
| `lib/core/screens/model_admin_screen.dart:267` | `'Connect the live gateway session before reading billing. Nothing is charged from this page.'` |
| `lib/core/screens/model_admin_screen.dart:384` | `'Could not complete that request.'` |
| `lib/core/screens/model_admin_screen.dart:400` | `'Cancel'` |
| `lib/core/screens/model_admin_screen.dart:405` | `'Confirm'` |
| `lib/core/screens/model_admin_screen.dart:435` | `'Providers and billing'` |
| `lib/core/screens/model_admin_screen.dart:438` | `'Refresh'` |
| `lib/core/screens/model_admin_screen.dart:454` | `'API keys'` |
| `lib/core/screens/model_admin_screen.dart:458` | `'Custom endpoints'` |
| `lib/core/screens/model_admin_screen.dart:462` | `'Provider accounts'` |
| `lib/core/screens/model_admin_screen.dart:466` | `'Effort and speed presets'` |
| `lib/core/screens/model_admin_screen.dart:470` | `'Delegation'` |
| `lib/core/screens/model_admin_screen.dart:474` | `'Mixture of agents'` |
| `lib/core/screens/model_admin_screen.dart:478` | `'Credits and plans'` |
| `lib/core/screens/model_admin_screen.dart:508` | `'No provider keys were reported for this profile.'` |
| `lib/core/screens/model_admin_screen.dart:519` | `'${key.name} · ${key.envKey} · ${key.saved ? 'Saved' : 'Not saved'}'` |
| `lib/core/screens/model_admin_screen.dart:531` | `'New key value'` |
| `lib/core/screens/model_admin_screen.dart:540` | `'Provider key saved.'` |
| `lib/core/screens/model_admin_screen.dart:544` | `'Save key'` |
| `lib/core/screens/model_admin_screen.dart:553` | `'Clear provider key'` |
| `lib/core/screens/model_admin_screen.dart:554` | `'Remove the saved $key value from this profile?'` |
| `lib/core/screens/model_admin_screen.dart:558` | `'Provider key cleared.'` |
| `lib/core/screens/model_admin_screen.dart:562` | `'Clear key'` |
| `lib/core/screens/model_admin_screen.dart:572` | `'New endpoint'` |
| `lib/core/screens/model_admin_screen.dart:577` | `'${endpoint.name}${endpoint.current ? ' · current' : ''}'` |
| `lib/core/screens/model_admin_screen.dart:599` | `'Name'` |
| `lib/core/screens/model_admin_screen.dart:604` | `'Base URL'` |
| `lib/core/screens/model_admin_screen.dart:609` | `'Model'` |
| `lib/core/screens/model_admin_screen.dart:627` | `'API key'` |
| `lib/core/screens/model_admin_screen.dart:628` | `'Leave blank to keep a key this endpoint already has.'` |
| `lib/core/screens/model_admin_screen.dart:643` | `'${result.reachable ? 'Reachable' : 'Unreachable'} · $transport · ${result.models.length} models. ${result.message}'` |
| `lib/core/screens/model_admin_screen.dart:646` | `'Test endpoint'` |
| `lib/core/screens/model_admin_screen.dart:657` | `'Endpoint saved.'` |
| `lib/core/screens/model_admin_screen.dart:661` | `'Save endpoint'` |
| `lib/core/screens/model_admin_screen.dart:669` | `'Use this endpoint'` |
| `lib/core/screens/model_admin_screen.dart:670` | `'Make this named endpoint the current model for this profile?'` |
| `lib/core/screens/model_admin_screen.dart:674` | `'Endpoint is now current.'` |
| `lib/core/screens/model_admin_screen.dart:676` | `'Use endpoint'` |
| `lib/core/screens/model_admin_screen.dart:684` | `'Delete endpoint'` |
| `lib/core/screens/model_admin_screen.dart:685` | `'Delete this named endpoint from the profile?'` |
| `lib/core/screens/model_admin_screen.dart:692` | `'Endpoint deleted.'` |
| `lib/core/screens/model_admin_screen.dart:698` | `'Delete endpoint'` |
| `lib/core/screens/model_admin_screen.dart:704` | `'Signing in stays on the provider sign-in screen. Disconnect only runs when this gateway says the account can be removed.'` |
| `lib/core/screens/model_admin_screen.dart:709` | `'Signed in'` |
| `lib/core/screens/model_admin_screen.dart:709` | `'Not signed in'` |
| `lib/core/screens/model_admin_screen.dart:717` | `'Disconnect ${account.name}'` |
| `lib/core/screens/model_admin_screen.dart:718` | `'Disconnect this provider account on the gateway?'` |
| `lib/core/screens/model_admin_screen.dart:726` | `'Provider account disconnected.'` |
| `lib/core/screens/model_admin_screen.dart:730` | `'Disconnect'` |
| `lib/core/screens/model_admin_screen.dart:732` | `'Not disconnectable'` |
| `lib/core/screens/model_admin_screen.dart:739` | `'Provider'` |
| `lib/core/screens/model_admin_screen.dart:744` | `'Model'` |
| `lib/core/screens/model_admin_screen.dart:758` | `'Fast'` |
| `lib/core/screens/model_admin_screen.dart:773` | `'Preset saved for this model.'` |
| `lib/core/screens/model_admin_screen.dart:776` | `'Save preset'` |
| `lib/core/screens/model_admin_screen.dart:781` | `'Chat id'` |
| `lib/core/screens/model_admin_screen.dart:794` | `'Save a preset before applying it.'` |
| `lib/core/screens/model_admin_screen.dart:798` | `'Apply preset'` |
| `lib/core/screens/model_admin_screen.dart:799` | `'Set this chat\'s effort and speed from the saved preset?'` |
| `lib/core/screens/model_admin_screen.dart:807` | `'Preset applied to this chat.'` |
| `lib/core/screens/model_admin_screen.dart:810` | `'Apply to this chat'` |
| `lib/core/screens/model_admin_screen.dart:821` | `'This route sends the picked effort unchanged.'` |
| `lib/core/screens/model_admin_screen.dart:825` | `'Show route clamp'` |
| `lib/core/screens/model_admin_screen.dart:833` | `'Delegation is blocked: $_blocked'` |
| `lib/core/screens/model_admin_screen.dart:840` | `'Delegation backend'` |
| `lib/core/screens/model_admin_screen.dart:847` | `'${backend['label'] ?? backend['name']}${backend['available'] == true ? '' : ' · unavailable'}'` |
| `lib/core/screens/model_admin_screen.dart:864` | `'Delegation backend saved.'` |
| `lib/core/screens/model_admin_screen.dart:867` | `'Save backend'` |
| `lib/core/screens/model_admin_screen.dart:871` | `'Max iterations'` |
| `lib/core/screens/model_admin_screen.dart:876` | `'Max concurrent children'` |
| `lib/core/screens/model_admin_screen.dart:881` | `'Child timeout seconds'` |
| `lib/core/screens/model_admin_screen.dart:888` | `'Delegation effort, leave unchanged'` |
| `lib/core/screens/model_admin_screen.dart:908` | `'Delegation limits saved.'` |
| `lib/core/screens/model_admin_screen.dart:910` | `'Save limits'` |
| `lib/core/screens/model_admin_screen.dart:918` | `'Remove route'` |
| `lib/core/screens/model_admin_screen.dart:931` | `'Route name'` |
| `lib/core/screens/model_admin_screen.dart:935` | `'Route provider'` |
| `lib/core/screens/model_admin_screen.dart:939` | `'Route model'` |
| `lib/core/screens/model_admin_screen.dart:947` | `'Route effort unchanged'` |
| `lib/core/screens/model_admin_screen.dart:968` | `'Add route'` |
| `lib/core/screens/model_admin_screen.dart:976` | `'Default route'` |
| `lib/core/screens/model_admin_screen.dart:996` | `'Delegation routes saved.'` |
| `lib/core/screens/model_admin_screen.dart:998` | `'Save routes'` |
| `lib/core/screens/model_admin_screen.dart:1031` | `'Profile routes saved.'` |
| `lib/core/screens/model_admin_screen.dart:1033` | `'Save profile routes'` |
| `lib/core/screens/model_admin_screen.dart:1038` | `'No mixture is loaded.'` |
| `lib/core/screens/model_admin_screen.dart:1041` | `'Mixture enabled'` |
| `lib/core/screens/model_admin_screen.dart:1052` | `'Loud degraded references'` |
| `lib/core/screens/model_admin_screen.dart:1056` | `'Silent degraded references'` |
| `lib/core/screens/model_admin_screen.dart:1061` | `'Aggregator'` |
| `lib/core/screens/model_admin_screen.dart:1064` | `'Aggregator provider'` |
| `lib/core/screens/model_admin_screen.dart:1069` | `'Aggregator model'` |
| `lib/core/screens/model_admin_screen.dart:1072` | `'Reference ${index + 1}'` |
| `lib/core/screens/model_admin_screen.dart:1075` | `'Reference provider'` |
| `lib/core/screens/model_admin_screen.dart:1079` | `'Reference model'` |
| `lib/core/screens/model_admin_screen.dart:1085` | `'Add reference model'` |
| `lib/core/screens/model_admin_screen.dart:1124` | `'Mixture saved.'` |
| `lib/core/screens/model_admin_screen.dart:1126` | `'Save mixture'` |
| `lib/core/screens/model_admin_screen.dart:1166` | `'Turn on auto-reload and charge $amount when the balance falls '` |
| `lib/core/screens/model_admin_screen.dart:1169` | `'Turn off auto-reload? It currently charges $amount when the '` |
| `lib/core/screens/model_admin_screen.dart:1170` | `'balance falls below $threshold.'` |
| `lib/core/screens/model_admin_screen.dart:1174` | `'this plan'` |
| `lib/core/screens/model_admin_screen.dart:1179` | `' It is scheduled for the end of the current period.'` |
| `lib/core/screens/model_admin_screen.dart:1180` | `' It takes effect $when.'` |
| `lib/core/screens/model_admin_screen.dart:1181` | `'Schedule $name$priceText.$whenText No charge is made now.'` |
| `lib/core/screens/model_admin_screen.dart:1208` | `'Credit purchase submitted.'` |
| `lib/core/screens/model_admin_screen.dart:1239` | `'Credit purchase settled.'` |
| `lib/core/screens/model_admin_screen.dart:1269` | `'Credit and plan changes wait for confirmation. A plan that would charge immediately is shown and not confirmed here.'` |
| `lib/core/screens/model_admin_screen.dart:1271` | `'Balance ${billing['balance_display'] ?? '—'}'` |
| `lib/core/screens/model_admin_screen.dart:1290` | `'Buy credits'` |
| `lib/core/screens/model_admin_screen.dart:1291` | `'Charge \$$amount to the payment method on this Nous account. This spends real money.'` |
| `lib/core/screens/model_admin_screen.dart:1296` | `'Buy credits'` |
| `lib/core/screens/model_admin_screen.dart:1309` | `'Retry same charge'` |
| `lib/core/screens/model_admin_screen.dart:1310` | `'Retry the same credit charge. This does not start a second purchase.'` |
| `lib/core/screens/model_admin_screen.dart:1315` | `'Retry same charge'` |
| `lib/core/screens/model_admin_screen.dart:1320` | `'Credit purchases are not available for this account.'` |
| `lib/core/screens/model_admin_screen.dart:1328` | `'Auto-reload'` |
| `lib/core/screens/model_admin_screen.dart:1331` | `'Read-only until this account can charge.'` |
| `lib/core/screens/model_admin_screen.dart:1337` | `'Auto-reload'` |
| `lib/core/screens/model_admin_screen.dart:1349` | `'Auto-reload updated.'` |
| `lib/core/screens/model_admin_screen.dart:1358` | `'Change auto-reload on the portal: ${billingPortalUrl(billing)}'` |
| `lib/core/screens/model_admin_screen.dart:1365` | `'Keep going on credits'` |
| `lib/core/screens/model_admin_screen.dart:1371` | `'Keep going on credits'` |
| `lib/core/screens/model_admin_screen.dart:1373` | `'Continue on credits when the plan window is used up?'` |
| `lib/core/screens/model_admin_screen.dart:1374` | `'Stop continuing on credits when the plan window is used up?'` |
| `lib/core/screens/model_admin_screen.dart:1381` | `'Credit continuation updated.'` |
| `lib/core/screens/model_admin_screen.dart:1414` | `'This plan change is not confirmed from Ares.'` |
| `lib/core/screens/model_admin_screen.dart:1433` | `'This change is scheduled. Confirm to apply it.'` |
| `lib/core/screens/model_admin_screen.dart:1436` | `'Preview plan'` |
| `lib/core/screens/model_admin_screen.dart:1441` | `'Team subscriptions are changed on the portal: ${billingPortalUrl(billing)}'` |
| `lib/core/screens/model_admin_screen.dart:1451` | `'Schedule plan change'` |
| `lib/core/screens/model_admin_screen.dart:1463` | `'Plan change scheduled.'` |
| `lib/core/screens/model_admin_screen.dart:1469` | `'Confirm scheduled plan change'` |
| `lib/core/screens/profile_admin_panel.dart:11` | `'This operation is unavailable on this gateway.'` |
| `lib/core/screens/profile_admin_panel.dart:13` | `'Access denied by the gateway.'` |
| `lib/core/screens/profile_admin_panel.dart:15` | `'Connection changed. Reopen Profiles.'` |
| `lib/core/screens/profile_admin_panel.dart:17` | `'Invalid input or gateway response. Check the target before retrying.'` |
| `lib/core/screens/profile_admin_panel.dart:18` | `'Could not verify the result. Refresh the target before trying again.'` |
| `lib/core/screens/profile_admin_panel.dart:45` | `'Cancel'` |
| `lib/core/screens/profile_admin_panel.dart:49` | `'Create'` |
| `lib/core/screens/profile_admin_panel.dart:166` | `'Edit SOUL.md'` |
| `lib/core/screens/profile_admin_panel.dart:167` | `'Save the persona for $scope.'` |
| `lib/core/screens/profile_admin_panel.dart:168` | `'Persona'` |
| `lib/core/screens/profile_admin_panel.dart:171` | `'Persona saved.'` |
| `lib/core/screens/profile_admin_panel.dart:180` | `'${f.key} (${f.isSet ? 'configured' : 'not set'})'` |
| `lib/core/screens/profile_admin_panel.dart:186` | `'Configure ${c.name}'` |
| `lib/core/screens/profile_admin_panel.dart:187` | `'Applies to $scope. Blank keeps an existing value. To remove a value, list its key below.'` |
| `lib/core/screens/profile_admin_panel.dart:190` | `'Enabled'` |
| `lib/core/screens/profile_admin_panel.dart:195` | `'Keys to remove (comma-separated)'` |
| `lib/core/screens/profile_admin_panel.dart:213` | `'Saved and applied by the gateway.'` |
| `lib/core/screens/profile_admin_panel.dart:214` | `'Saved. A gateway restart may be required.'` |
| `lib/core/screens/profile_admin_panel.dart:221` | `'Create signed route'` |
| `lib/core/screens/profile_admin_panel.dart:222` | `'Applies to $scope. Use a unique name. The gateway creates a signing secret. If another operator creates the name simultaneously the host may replace that route.'` |
| `lib/core/screens/profile_admin_panel.dart:224` | `'Route ID'` |
| `lib/core/screens/profile_admin_panel.dart:226` | `'Signature'` |
| `lib/core/screens/profile_admin_panel.dart:230` | `'Events (comma-separated)'` |
| `lib/core/screens/profile_admin_panel.dart:232` | `'Delivery target'` |
| `lib/core/screens/profile_admin_panel.dart:243` | `'Prompt'` |
| `lib/core/screens/profile_admin_panel.dart:244` | `'Skills (comma-separated)'` |
| `lib/core/screens/profile_admin_panel.dart:246` | `'Delivery mode'` |
| `lib/core/screens/profile_admin_panel.dart:247` | `'Agent processes event'` |
| `lib/core/screens/profile_admin_panel.dart:248` | `'Agent processes event'` |
| `lib/core/screens/profile_admin_panel.dart:248` | `'Direct delivery'` |
| `lib/core/screens/profile_admin_panel.dart:250` | `'Delivery chat ID (optional)'` |
| `lib/core/screens/profile_admin_panel.dart:265` | `'Created ${r.url}. Store the signing secret before leaving.'` |
| `lib/core/screens/profile_admin_panel.dart:282` | `'Hide signing secret'` |
| `lib/core/screens/profile_admin_panel.dart:282` | `'Reveal signing secret'` |
| `lib/core/screens/profile_admin_panel.dart:332` | `'Cancel'` |
| `lib/core/screens/profile_admin_panel.dart:345` | `'Confirm'` |
| `lib/core/screens/profile_admin_panel.dart:350` | `'Edit persona'` |
| `lib/core/screens/profile_admin_panel.dart:351` | `'Portable profile bundle'` |
| `lib/core/screens/profile_admin_panel.dart:364` | `'Clone profile'` |
| `lib/core/screens/profile_admin_panel.dart:366` | `'Clone profile'` |
| `lib/core/screens/profile_admin_panel.dart:367` | `'Copy settings, skills, persona and potentially provider credentials from $scope. Messaging tokens are not requested.'` |
| `lib/core/screens/profile_admin_panel.dart:368` | `'New profile ID'` |
| `lib/core/screens/profile_admin_panel.dart:371` | `'Cloned ${a.name} to ${v[0]}.'` |
| `lib/core/screens/profile_admin_panel.dart:376` | `'Rename display label'` |
| `lib/core/screens/profile_admin_panel.dart:376` | `'Rename profile'` |
| `lib/core/screens/profile_admin_panel.dart:378` | `'Rename ${a.name}'` |
| `lib/core/screens/profile_admin_panel.dart:380` | `'Change the presentation label for $scope. Its ID stays default.'` |
| `lib/core/screens/profile_admin_panel.dart:381` | `'Rename $scope on the server. A running gateway may stop.'` |
| `lib/core/screens/profile_admin_panel.dart:382` | `'New name'` |
| `lib/core/screens/profile_admin_panel.dart:385` | `'Rename verified.'` |
| `lib/core/screens/profile_admin_panel.dart:391` | `'Delete profile'` |
| `lib/core/screens/profile_admin_panel.dart:393` | `'Delete ${a.name}'` |
| `lib/core/screens/profile_admin_panel.dart:394` | `'Permanently delete $scope, including sessions and credentials. Type the exact profile ID.'` |
| `lib/core/screens/profile_admin_panel.dart:395` | `'Profile ID to delete'` |
| `lib/core/screens/profile_admin_panel.dart:403` | `'Profile deleted.'` |
| `lib/core/screens/profile_admin_panel.dart:404` | `'Profile deleted. Server identity cleanup is still pending.'` |
| `lib/core/screens/profile_admin_panel.dart:410` | `'Export profile archive'` |
| `lib/core/screens/profile_admin_panel.dart:412` | `'Export ${a.name}'` |
| `lib/core/screens/profile_admin_panel.dart:413` | `'Create a .tar.gz on $scope. Known credential stores are excluded, but private data can remain. Review before sharing.'` |
| `lib/core/screens/profile_admin_panel.dart:417` | `'Archive on ${widget.label}: ${await a.exportProfile()}'` |
| `lib/core/screens/profile_admin_panel.dart:422` | `'Import profile archive'` |
| `lib/core/screens/profile_admin_panel.dart:424` | `'Import a trusted profile'` |
| `lib/core/screens/profile_admin_panel.dart:425` | `'Use a reviewed .tar.gz already on ${widget.label}. It can contain plugins, scripts and schedules. A new profile ID is required.'` |
| `lib/core/screens/profile_admin_panel.dart:427` | `'Absolute archive path on gateway'` |
| `lib/core/screens/profile_admin_panel.dart:428` | `'New profile ID'` |
| `lib/core/screens/profile_admin_panel.dart:432` | `'Imported ${v[1]}.'` |
| `lib/core/screens/profile_admin_panel.dart:437` | `'Messaging channels'` |
| `lib/core/screens/profile_admin_panel.dart:446` | `'DM pairing requests'` |
| `lib/core/screens/profile_admin_panel.dart:448` | `'No pending or approved users.'` |
| `lib/core/screens/profile_admin_panel.dart:456` | `'Legacy pairing: no verifiable request ID. Ask the user to pair again.'` |
| `lib/core/screens/profile_admin_panel.dart:461` | `'${p.pending ? 'Approve' : 'Revoke'} ${p.user}'` |
| `lib/core/screens/profile_admin_panel.dart:463` | `'${p.pending ? 'Approve' : 'Revoke'} ${p.user}'` |
| `lib/core/screens/profile_admin_panel.dart:464` | `'${p.platform} on $scope: ${p.pending ? 'allow' : 'remove'} this user’s messaging access.'` |
| `lib/core/screens/profile_admin_panel.dart:469` | `'Pairing change verified.'` |
| `lib/core/screens/profile_admin_panel.dart:476` | `'Create Telegram bot by QR'` |
| `lib/core/screens/profile_admin_panel.dart:478` | `'Create Telegram bot'` |
| `lib/core/screens/profile_admin_panel.dart:479` | `'Start a Telegram pairing on $scope using the gateway’s setup service.'` |
| `lib/core/screens/profile_admin_panel.dart:480` | `'Bot name'` |
| `lib/core/screens/profile_admin_panel.dart:496` | `'Telegram bot creation QR code'` |
| `lib/core/screens/profile_admin_panel.dart:504` | `'Expires: ${s.expires.toLocal()}'` |
| `lib/core/screens/profile_admin_panel.dart:505` | `'Check Telegram pairing'` |
| `lib/core/screens/profile_admin_panel.dart:508` | `'Waiting for Telegram.'` |
| `lib/core/screens/profile_admin_panel.dart:512` | `'Apply Telegram bot'` |
| `lib/core/screens/profile_admin_panel.dart:513` | `'Enable @${status.bot} on $scope and attempt a gateway restart. Only the listed users may message it.'` |
| `lib/core/screens/profile_admin_panel.dart:514` | `'Allowed numeric user IDs'` |
| `lib/core/screens/profile_admin_panel.dart:520` | `'Saved. Restart still required.'` |
| `lib/core/screens/profile_admin_panel.dart:521` | `'Saved; gateway restart requested.'` |
| `lib/core/screens/profile_admin_panel.dart:525` | `'Cancel Telegram setup'` |
| `lib/core/screens/profile_admin_panel.dart:532` | `'Inbound webhooks'` |
| `lib/core/screens/profile_admin_panel.dart:538` | `'Enable webhook service'` |
| `lib/core/screens/profile_admin_panel.dart:540` | `'Enable webhooks'` |
| `lib/core/screens/profile_admin_panel.dart:541` | `'Enable inbound webhooks on $scope and attempt a gateway restart.'` |
| `lib/core/screens/profile_admin_panel.dart:547` | `'Enabled. Restart still required.'` |
| `lib/core/screens/profile_admin_panel.dart:548` | `'Enabled; restart requested.'` |
| `lib/core/screens/profile_admin_panel.dart:553` | `'Create signed route'` |
| `lib/core/screens/profile_admin_panel.dart:567` | `'${del                                     ? 'Delete'                                     : route.enabled                                     ? 'Disable'                                     : 'Enable'} ${route.name}'` |
| `lib/core/screens/profile_admin_panel.dart:572` | `'Change exactly ${route.name} on $scope.'` |
| `lib/core/screens/profile_admin_panel.dart:577` | `'Route change verified.'` |
| `lib/core/screens/profile_admin_panel.dart:583` | `'Delete route'` |
| `lib/core/screens/profile_admin_panel.dart:585` | `'Disable route'` |
| `lib/core/screens/profile_admin_panel.dart:586` | `'Enable route'` |
| `lib/core/screens/profile_admin_panel.dart:595` | `'Back up entire agent home'` |
| `lib/core/screens/profile_admin_panel.dart:597` | `'Back up entire agent home'` |
| `lib/core/screens/profile_admin_panel.dart:598` | `'This is not an Ares settings backup. Save all profiles, sessions and credentials on ${widget.label}. The archive is sensitive.'` |
| `lib/core/screens/profile_admin_panel.dart:603` | `'Backup started on ${widget.label}.'` |
| `lib/core/screens/profile_admin_panel.dart:607` | `'Transfer to a Cloud agent'` |
| `lib/core/screens/profile_admin_panel.dart:616` | `'Check backup progress'` |
| `lib/core/screens/profile_admin_panel.dart:618` | `'Backup verified on ${widget.label}: ${b.archive}'` |
| `lib/core/screens/profile_admin_panel.dart:622` | `'Backup still running on ${widget.label}.'` |
| `lib/core/screens/profile_admin_panel.dart:627` | `'Save backup to this device'` |
| `lib/core/screens/profile_admin_panel.dart:633` | `'Save sensitive full-home archive'` |
| `lib/core/screens/profile_admin_panel.dart:643` | `'Save cancelled.'` |
| `lib/core/screens/profile_admin_panel.dart:643` | `'Backup saved.'` |
| `lib/core/screens/profile_admin_panel.dart:645` | `'Up to 32 MiB. Larger archives remain on the gateway.'` |
| `lib/core/screens/profile_bundle_screen.dart:54` | `'Connection changed. Reopen Profiles.'` |
| `lib/core/screens/profile_bundle_screen.dart:85` | `'Unsupported or oversized profile archive.'` |
| `lib/core/screens/profile_bundle_screen.dart:124` | `'Current layout'` |
| `lib/core/screens/profile_bundle_screen.dart:125` | `'One pane'` |
| `lib/core/screens/profile_bundle_screen.dart:127` | `'${g.stacked ? 'Stacked' : 'Side by side'} · ${g.percent}% first pane'` |
| `lib/core/screens/profile_bundle_screen.dart:134` | `'Portable profile bundle'` |
| `lib/core/screens/profile_bundle_screen.dart:152` | `'No supported appearance in this profile.'` |
| `lib/core/screens/profile_bundle_screen.dart:155` | `'Review appearance saved with this profile'` |
| `lib/core/screens/profile_bundle_screen.dart:159` | `'Skin: ${style.skin ?? 'unchanged'} · Mode: ${style.mode?.name ?? 'unchanged'} · ${_layoutLabel(style)}'` |
| `lib/core/screens/profile_bundle_screen.dart:162` | `'Applies only to this named profile on this device. An imported arrangement starts with empty panes; choose its chats yourself.'` |
| `lib/core/screens/profile_bundle_screen.dart:174` | `'Appearance applied to ${widget.gateway} / ${widget.admin.name}.'` |
| `lib/core/screens/profile_bundle_screen.dart:176` | `'Apply to this profile on this device'` |
| `lib/core/screens/profile_bundle_screen.dart:180` | `'Export prepares a .tar.gz on the gateway. Review its portable files before saving a copy here. Import opens a local archive for review; opening alone uploads nothing.'` |
| `lib/core/screens/profile_bundle_screen.dart:201` | `'Prepare profile export'` |
| `lib/core/screens/profile_bundle_screen.dart:205` | `'Open .tar.gz from this device'` |
| `lib/core/screens/profile_bundle_screen.dart:209` | `'Bundle: ${b.profile} · ${b.files.length} reviewable files · ${b.omitted} omitted'` |
| `lib/core/screens/profile_bundle_screen.dart:212` | `'Only selected text files travel. Review for secrets and private information. Config, skills and schedules can change what the new profile does.'` |
| `lib/core/screens/profile_bundle_screen.dart:223` | `'Include this reviewed file'` |
| `lib/core/screens/profile_bundle_screen.dart:245` | `'Apply appearance to the new profile on this device'` |
| `lib/core/screens/profile_bundle_screen.dart:248` | `'Imports colours and pane sizes, never chats, tools or session IDs.'` |
| `lib/core/screens/profile_bundle_screen.dart:252` | `'The gateway retains a private staged copy. Import creates a new profile; it will not replace an existing one.'` |
| `lib/core/screens/profile_bundle_screen.dart:257` | `'New profile ID'` |
| `lib/core/screens/profile_bundle_screen.dart:273` | `'Imported $name on ${widget.gateway}.'` |
| `lib/core/screens/profile_bundle_screen.dart:279` | `' Appearance not applied: the gateway did not confirm the reviewed overlay.'` |
| `lib/core/screens/profile_bundle_screen.dart:292` | `' Appearance applied on this device.'` |
| `lib/core/screens/profile_bundle_screen.dart:296` | `' Appearance was not saved on this device.'` |
| `lib/core/screens/profile_bundle_screen.dart:304` | `'Save reviewed profile bundle'` |
| `lib/core/screens/profile_bundle_screen.dart:311` | `'Save cancelled.'` |
| `lib/core/screens/profile_bundle_screen.dart:312` | `'Profile bundle saved.'` |
| `lib/core/screens/profile_bundle_screen.dart:319` | `'Import selected files'` |
| `lib/core/screens/profile_bundle_screen.dart:320` | `'Save selected files to device'` |
| `lib/core/screens/profile_transfer_screen.dart:95` | `'No available Cloud agents in this account.'` |
| `lib/core/screens/profile_transfer_screen.dart:113` | `'Sign in to exactly one saved Ares connection for ${row.origin}, then return here.'` |
| `lib/core/screens/profile_transfer_screen.dart:152` | `'The previous undo receipt could not be verified. No change was made.'` |
| `lib/core/screens/profile_transfer_screen.dart:162` | `'Transfer to Cloud'` |
| `lib/core/screens/profile_transfer_screen.dart:166` | `'Source: ${widget.label} / ${widget.source.name}'` |
| `lib/core/screens/profile_transfer_screen.dart:169` | `'Connection changed. Leave this page. A restore already submitted may continue.'` |
| `lib/core/screens/profile_transfer_screen.dart:182` | `'Find my Cloud agents'` |
| `lib/core/screens/profile_transfer_screen.dart:198` | `'Destination: ${row.name} · ${row.origin} / default'` |
| `lib/core/screens/profile_transfer_screen.dart:199` | `'Agent ID: ${row.id}'` |
| `lib/core/screens/profile_transfer_screen.dart:200` | `'Status: ${current.phase.name}'` |
| `lib/core/screens/profile_transfer_screen.dart:202` | `'Copied ${((current.fraction ?? 0) * 100).floor()}%'` |
| `lib/core/screens/profile_transfer_screen.dart:207` | `'Undo replaces the destination with its pre-transfer backup.'` |
| `lib/core/screens/profile_transfer_screen.dart:208` | `'Replace this Cloud agent with the entire source home, including credentials, conversations and files. The source is not deleted. Incoming messaging bots are switched off.'` |
| `lib/core/screens/profile_transfer_screen.dart:214` | `'Type destination agent ID'` |
| `lib/core/screens/profile_transfer_screen.dart:235` | `'Could not retain the local undo receipt. Keep this page open.'` |
| `lib/core/screens/profile_transfer_screen.dart:241` | `'Undo transfer'` |
| `lib/core/screens/profile_transfer_screen.dart:241` | `'Replace Cloud agent'` |
| `lib/core/screens/profile_transfer_screen.dart:265` | `'Local undo receipt forgotten. No remote backup was removed.'` |
| `lib/core/screens/profile_transfer_screen.dart:267` | `'Forget local undo receipt only'` |
| `lib/core/screens/profile_transfer_screen.dart:277` | `'Stop before restore'` |
| `lib/core/screens/profile_transfer_screen.dart:282` | `'Do not close this page. Restore runs on the destination and cannot be cancelled.'` |
| `lib/core/screens/profile_transfer_screen.dart:286` | `'Undo point on destination: ${current.undoArchive}'` |
| `lib/core/screens/profile_transfer_screen.dart:290` | `'Files restored; destination gateway needs attention.'` |
| `lib/core/screens/profile_transfer_screen.dart:293` | `'Messaging disabled: ${current.messagingOff.join(', ')}'` |
| `lib/core/widgets/gateway_approval_dialog.dart:82` | `'Allow this folder until the session ends.'` |
| `lib/core/widgets/gateway_approval_dialog.dart:84` | `'Save this folder grant for later requests.'` |
| `lib/core/widgets/gateway_approval_dialog.dart:85` | `'Do not grant this folder.'` |
| `lib/core/widgets/gateway_approval_dialog.dart:93` | `'Allow this website until the session ends.'` |
| `lib/core/widgets/gateway_approval_dialog.dart:95` | `'Save this website grant for later requests.'` |
| `lib/core/widgets/gateway_approval_dialog.dart:96` | `'Do not grant this website.'` |
| `lib/core/widgets/gateway_approval_dialog.dart:125` | `'Folder access'` |
| `lib/core/widgets/gateway_approval_dialog.dart:126` | `'Website access'` |
| `lib/core/widgets/gateway_approval_dialog.dart:130` | `'Read-only'` |
| `lib/core/widgets/gateway_approval_dialog.dart:131` | `'Read and write'` |
| `lib/core/widgets/gateway_approval_dialog.dart:132` | `'The gateway did not say whether this is read-only or read-write.'` |
| `lib/core/widgets/gateway_approval_dialog.dart:156` | `'Folder'` |
| `lib/core/widgets/gateway_approval_dialog.dart:161` | `'The gateway did not name a folder.'` |
| `lib/core/widgets/gateway_approval_dialog.dart:168` | `'Website'` |
| `lib/core/widgets/gateway_approval_dialog.dart:173` | `'The gateway did not name a website.'` |
| `lib/core/widgets/mobile_push_settings.dart:73` | `'Unable to read Android push availability. Retry below.'` |
| `lib/core/widgets/mobile_push_settings.dart:93` | `'Push setup failed. Check Android permission, server authorization and transport, then retry.'` |
| `lib/core/widgets/mobile_push_settings.dart:151` | `'Status: Bound to ${boundLabel ?? 'another saved connection'} '` |
| `lib/core/widgets/mobile_push_settings.dart:152` | `'(not active for ${widget.connection.label}; handshake: $rawStatus)'` |
| `lib/core/widgets/mobile_push_settings.dart:153` | `'Status: $rawStatus'` |
| `lib/core/widgets/mobile_push_settings.dart:168` | `'Background notifications'` |
| `lib/core/widgets/mobile_push_settings.dart:171` | `'Bound to ${boundLabel ?? 'another saved connection'} '` |
| `lib/core/widgets/mobile_push_settings.dart:172` | `'— revoke that binding below before enabling for ${widget.connection.label}'` |
| `lib/core/widgets/mobile_push_settings.dart:173` | `'Private server activity for ${widget.connection.label}'` |
| `lib/core/widgets/mobile_push_settings.dart:199` | `'Bound to another saved connection ($boundLabel). Disable and revoke that binding before enabling for this connection.'` |
| `lib/core/widgets/mobile_push_settings.dart:200` | `'Bound to another saved connection. Disable and revoke that binding before enabling for this connection.'` |
| `lib/core/widgets/mobile_push_settings.dart:207` | `'Local notifications are turned off above. Background notification consent is unchanged, but ordinary background activity hints are muted until "Enable notifications" is turned on.'` |
| `lib/core/widgets/mobile_push_settings.dart:216` | `'Legacy subscription: ${service.sessionIds.length} selected session(s) only. It will not expand automatically. Turn off, then on to opt in to server-authorized sessions.'` |
| `lib/core/widgets/mobile_push_settings.dart:224` | `'Bound only to this saved connection and profile. Session access follows current server authorization.'` |
| `lib/core/widgets/mobile_push_settings.dart:230` | `'Server revocation pending. Local delivery is off; retry while the original saved login is available.'` |
| `lib/core/widgets/mobile_push_settings.dart:251` | `'Refresh / retry'` |
| `lib/core/widgets/mobile_push_settings.dart:259` | `'Disable and revoke ${boundLabel ?? 'other connection'}'` |
| `lib/core/widgets/mobile_push_settings.dart:260` | `'Disable and revoke'` |
| `lib/core/widgets/mobile_push_settings.dart:266` | `'Refresh / retry rechecks availability after server setup; it cannot install the companion. Enabling notifications remains a separate choice.'` |
| `lib/core/widgets/mobile_push_settings.dart:269` | `'Background notifications require a separately installed and enabled server-side mobile-push companion. Android cannot install it. Updating the APK alone does not set up the server.'` |
| `lib/core/widgets/mobile_push_settings.dart:274` | `'Server setup guide'` |
| `lib/core/widgets/mobile_push_settings.dart:277` | `'Enable to request Android notification permission and share this installation’s endpoint and encryption keys with this server. Encrypted activity hints contain no chat content. Only sessions authorized by your server login are included.'` |
| `lib/core/widgets/mobile_push_settings.dart:280` | `'Built-in delivery uses Google’s push transport and needs Google Play Services, but includes no Firebase SDK. An optional UnifiedPush distributor can be used instead. Delivery is best-effort; reopen Hermes to reconcile.'` |
| `lib/core/widgets/mobile_push_settings.dart:284` | `'Advanced transport'` |
| `lib/core/widgets/mobile_push_settings.dart:287` | `'Automatic preserves an existing distributor choice, otherwise uses built-in Google delivery when available. Disable before changing transport.'` |
| `lib/core/widgets/mobile_push_settings.dart:293` | `'Push transport'` |
| `lib/core/widgets/mobile_push_settings.dart:299` | `'Automatic (recommended)'` |
| `lib/core/widgets/mobile_push_settings.dart:309` | `'Selected distributor (unavailable)'` |
| `lib/core/widgets/mobile_push_settings.dart:331` | `'No available transport detected. Built-in delivery needs Google Play Services; without it, install and configure a UnifiedPush distributor, then refresh.'` |
| `lib/core/workspace/ssh_terminal_dialog.dart:33` | `'Open a verified SSH terminal'` |
| `lib/core/workspace/ssh_terminal_dialog.dart:39` | `'Use a fingerprint obtained independently from the host administrator. This opens a new remote login, not the gateway or a local shell.'` |
| `lib/core/workspace/ssh_terminal_dialog.dart:42` | `'SSH host'` |
| `lib/core/workspace/ssh_terminal_dialog.dart:43` | `'Port'` |
| `lib/core/workspace/ssh_terminal_dialog.dart:44` | `'User'` |
| `lib/core/workspace/ssh_terminal_dialog.dart:45` | `'Host key fingerprint (SHA256:…)'` |
| `lib/core/workspace/ssh_terminal_dialog.dart:46` | `'SSH password (not saved)'` |
| `lib/core/workspace/ssh_terminal_dialog.dart:61` | `'Cancel'` |
| `lib/core/workspace/ssh_terminal_dialog.dart:71` | `'Connect'` |
| `lib/core/workspace/terminal_page.dart:76` | `'Connecting…'` |
| `lib/core/workspace/terminal_page.dart:136` | `'No matching live session or host working directory. Open the owning chat first.'` |
| `lib/core/workspace/terminal_page.dart:140` | `'This gateway does not offer this terminal capability. No local shell was started.'` |
| `lib/core/workspace/terminal_page.dart:142` | `'Gateway refused this terminal operation (${e.reason.name}).'` |
| `lib/core/workspace/terminal_page.dart:144` | `'The packaged local PTY is unavailable on this device.'` |
| `lib/core/workspace/terminal_page.dart:146` | `'Could not open or control the terminal. Check the host, credentials and fingerprint. No fallback shell was started.'` |
| `lib/core/workspace/terminal_page.dart:163` | `'Input refused. Reopen the originating chat.'` |
| `lib/core/workspace/terminal_page.dart:205` | `'Cancel'` |
| `lib/core/workspace/terminal_page.dart:209` | `'Confirm'` |
| `lib/core/workspace/terminal_page.dart:228` | `'Open a shell on this device?'` |
| `lib/core/workspace/terminal_page.dart:229` | `'This is the Ares device, not ${origin.connection.label}. The shell uses your app permissions and starts in app storage.'` |
| `lib/core/workspace/terminal_page.dart:235` | `'${ssh ? 'SSH ${login!.user}@${login.host}:${login.port}' : 'This device'} · ${++serial}'` |
| `lib/core/workspace/terminal_page.dart:256` | `'SSH shell'` |
| `lib/core/workspace/terminal_page.dart:256` | `'Local shell'` |
| `lib/core/workspace/terminal_page.dart:263` | `'Connection lost'` |
| `lib/core/workspace/terminal_page.dart:264` | `'Shell ended'` |
| `lib/core/workspace/terminal_page.dart:286` | `'This chat has no authenticated gateway terminal owner. A URL or Cloud login alone does not grant a shell.'` |
| `lib/core/workspace/terminal_page.dart:292` | `'Open a gateway shell?'` |
| `lib/core/workspace/terminal_page.dart:293` | `'Start a shell on $gatewayLabel in the verified chat working directory. This is not a device shell.'` |
| `lib/core/workspace/terminal_page.dart:298` | `'Gateway $gatewayLabel · ${++serial}'` |
| `lib/core/workspace/terminal_page.dart:320` | `'Shell ended or expired'` |
| `lib/core/workspace/terminal_page.dart:320` | `'Disconnected'` |
| `lib/core/workspace/terminal_page.dart:325` | `'Gateway shell'` |
| `lib/core/workspace/terminal_page.dart:341` | `'Close ${t.label}?'` |
| `lib/core/workspace/terminal_page.dart:342` | `'End this shell. To keep it running, hide the pane instead.'` |
| `lib/core/workspace/terminal_page.dart:350` | `'Closing…'` |
| `lib/core/workspace/terminal_page.dart:354` | `'Close not confirmed'` |
| `lib/core/workspace/terminal_page.dart:364` | `'Agent processes require the authenticated owning chat.'` |
| `lib/core/workspace/terminal_page.dart:430` | `'Read-only · ${r.status}'` |
| `lib/core/workspace/terminal_page.dart:453` | `'Watching this chat’s agent processes. Closing a mirror never stops its process.'` |
| `lib/core/workspace/terminal_page.dart:487` | `'Paste is limited to 16 KiB.'` |
| `lib/core/workspace/terminal_page.dart:490` | `'Paste into ${t.label}?'` |
| `lib/core/workspace/terminal_page.dart:515` | `'Paste'` |
| `lib/core/workspace/terminal_page.dart:523` | `'Select terminal output first.'` |
| `lib/core/workspace/terminal_page.dart:528` | `'Open the originating chat before inserting output.'` |
| `lib/core/workspace/terminal_page.dart:532` | `'Added to the originating chat draft. Nothing was sent.'` |
| `lib/core/workspace/terminal_page.dart:542` | `'Output · ${t.label}'` |
| `lib/core/workspace/terminal_page.dart:556` | `'Close'` |
| `lib/core/workspace/terminal_page.dart:560` | `'Add selection to chat draft'` |
| `lib/core/workspace/terminal_page.dart:583` | `'New terminal'` |
| `lib/core/workspace/terminal_page.dart:592` | `'Gateway host terminal'` |
| `lib/core/workspace/terminal_page.dart:596` | `'Verified SSH terminal'` |
| `lib/core/workspace/terminal_page.dart:603` | `'This device (local shell)'` |
| `lib/core/workspace/terminal_page.dart:604` | `'Local shell unavailable on mobile'` |
| `lib/core/workspace/terminal_page.dart:610` | `'Watch agent processes'` |
| `lib/core/workspace/terminal_page.dart:616` | `'Select or copy output'` |
| `lib/core/workspace/terminal_page.dart:621` | `'Add selected output to chat draft'` |
| `lib/core/workspace/terminal_page.dart:627` | `'Review clipboard paste'` |
| `lib/core/workspace/terminal_page.dart:632` | `'Reconnect same shell'` |
| `lib/core/workspace/terminal_page.dart:634` | `'Close mirror'` |
| `lib/core/workspace/terminal_page.dart:634` | `'Close shell'` |
| `lib/core/workspace/terminal_page.dart:663` | `'Choose + to open a terminal. No shell starts automatically.'` |
| `lib/core/workspace/terminal_page.dart:670` | `'Read-only process mirror · ${t.label}'` |
## B. Confirmed client-authored downstream text (read-only)

These model/service values are consumed by UI or OS/browser surfaces. They must not all be dismissed as “server diagnostics”: several are authored locally even when exposed via `.message`, `.summary`, `.label` or a notification channel. Translate at rendering or use typed codes/serviceStrings as appropriate; keep raw server details intact.

| File:line | Exact source expression/literal | Why it matters |
|---|---|---|
| `lib/core/capabilities/capability_admin.dart:419` | `'Enter a label.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:423` | `'Enter a valid URL like https://example.com.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:429` | `'Enter the identifier and password.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:448` | `'Enter the card name, number, expiry and security code.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:465` | `'Enter the street, city, postal code and country.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:602` | `'The gateway returned a response that could not be read.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:620` | `'The gateway refused the request (${response.statusCode}).'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:631` | `'This connection has no gateway socket, so $method is unavailable.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:675` | `'Choose a skill.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:683` | `'The skill text was not returned.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:692` | `'Choose a skill.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:700` | `'Choose a skill.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:705` | `'Choose a skill.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:710` | `'The skill text was not returned.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:719` | `'Choose a skill.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:721` | `'The skill was not saved.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:728` | `'Choose a skill.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:730` | `'The skill was not archived.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:761` | `'The skill was not installed.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:789` | `'Skill updates did not start.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:796` | `'Choose a skill.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:798` | `'The skill was not removed.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:832` | `'Enter a skill or plugin identifier.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:890` | `'Choose a plugin.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:905` | `'Choose a plugin.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:914` | `'Choose a plugin.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:916` | `'The plugin was not removed.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:922` | `'Choose a plugin.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:924` | `'The desktop half was not removed.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:931` | `'This gateway did not give the plugin a stable key.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:939` | `'The plugin was not changed.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:984` | `'Choose a server.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1003` | `'Choose a server.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1012` | `'Name the server.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1016` | `'Give the server a command or an http(s) URL.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1065` | `'Choose a toolset.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1071` | `'Tool backend status was not returned.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1098` | `'Choose a toolset.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1101` | `'Choose a provider.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1111` | `'Choose a toolset.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1114` | `'This provider has no setup action.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1121` | `'Setup did not start.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1145` | `'Choose a terminal backend.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1170` | `'Name the connector.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1182` | `'Choose an account.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1189` | `'Name the connector.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1229` | `'Reload the connector policy before changing tool grants.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1306` | `'Choose an item.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1312` | `'Choose a source.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1319` | `'Enter the master password.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1324` | `'Choose a source.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1336` | `'Choose a source.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1342` | `'Gateway config was not returned.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1383` | `'Choose a known approval mode.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1386` | `'Use a positive limit.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/capabilities/capability_admin.dart:1393` | `'The policy was not saved.'` | CapabilityException / VaultFormException return message in toString; capability pages display caught errors. HTTP verbs and map values are excluded below. |
| `lib/core/composer/reference_completion.dart:5` | `'Attach a file reference'` | Starter completion descriptions are rendered as row.meta in core/widgets/composer_reference_assist.dart:244. |
| `lib/core/composer/reference_completion.dart:6` | `'Attach a folder reference'` | Starter completion descriptions are rendered as row.meta in core/widgets/composer_reference_assist.dart:244. |
| `lib/core/composer/reference_completion.dart:7` | `'Attach a URL reference'` | Starter completion descriptions are rendered as row.meta in core/widgets/composer_reference_assist.dart:244. |
| `lib/core/composer/reference_completion.dart:8` | `'Attach an image reference'` | Starter completion descriptions are rendered as row.meta in core/widgets/composer_reference_assist.dart:244. |
| `lib/core/composer/reference_completion.dart:9` | `'Attach a tool reference'` | Starter completion descriptions are rendered as row.meta in core/widgets/composer_reference_assist.dart:244. |
| `lib/core/composer/reference_completion.dart:10` | `'Attach git context'` | Starter completion descriptions are rendered as row.meta in core/widgets/composer_reference_assist.dart:244. |
| `lib/core/composer/reference_completion.dart:11` | `'Attach the unstaged diff'` | Starter completion descriptions are rendered as row.meta in core/widgets/composer_reference_assist.dart:244. |
| `lib/core/composer/reference_completion.dart:12` | `'Attach the staged diff'` | Starter completion descriptions are rendered as row.meta in core/widgets/composer_reference_assist.dart:244. |
| `lib/core/models/gateway_activity.dart:121` | `'Tool'` | Tool name/status fallbacks reach core/widgets/gateway_activity_card.dart:188-189,237-238,273-280; compaction fallbacks populate GatewayTurnStatus.text. |
| `lib/core/models/gateway_activity.dart:128` | `'Running'` | Tool name/status fallbacks reach core/widgets/gateway_activity_card.dart:188-189,237-238,273-280; compaction fallbacks populate GatewayTurnStatus.text. |
| `lib/core/models/gateway_activity.dart:130` | `'Preparing'` | Tool name/status fallbacks reach core/widgets/gateway_activity_card.dart:188-189,237-238,273-280; compaction fallbacks populate GatewayTurnStatus.text. |
| `lib/core/models/gateway_activity.dart:132` | `'Working'` | Tool name/status fallbacks reach core/widgets/gateway_activity_card.dart:188-189,237-238,273-280; compaction fallbacks populate GatewayTurnStatus.text. |
| `lib/core/models/gateway_activity.dart:135` | `'Completed'` | Tool name/status fallbacks reach core/widgets/gateway_activity_card.dart:188-189,237-238,273-280; compaction fallbacks populate GatewayTurnStatus.text. |
| `lib/core/models/gateway_activity.dart:136` | `'Completed in ${_formatDuration(durationSeconds!)}'` | Tool name/status fallbacks reach core/widgets/gateway_activity_card.dart:188-189,237-238,273-280; compaction fallbacks populate GatewayTurnStatus.text. |
| `lib/core/models/gateway_activity.dart:139` | `'Failed'` | Tool name/status fallbacks reach core/widgets/gateway_activity_card.dart:188-189,237-238,273-280; compaction fallbacks populate GatewayTurnStatus.text. |
| `lib/core/models/gateway_activity.dart:140` | `'Failed after ${_formatDuration(durationSeconds!)}'` | Tool name/status fallbacks reach core/widgets/gateway_activity_card.dart:188-189,237-238,273-280; compaction fallbacks populate GatewayTurnStatus.text. |
| `lib/core/models/gateway_activity.dart:390` | `'Compacting conversation context…'` | Tool name/status fallbacks reach core/widgets/gateway_activity_card.dart:188-189,237-238,273-280; compaction fallbacks populate GatewayTurnStatus.text. |
| `lib/core/models/gateway_activity.dart:392` | `'Conversation context compacted'` | Tool name/status fallbacks reach core/widgets/gateway_activity_card.dart:188-189,237-238,273-280; compaction fallbacks populate GatewayTurnStatus.text. |
| `lib/core/models/gateway_insight.dart:101` | `'Background task completed'` | GatewayNotice.title is rendered by core/widgets/gateway_insight_card.dart:123. |
| `lib/core/models/gateway_insight.dart:102` | `'Background task $taskId completed'` | GatewayNotice.title is rendered by core/widgets/gateway_insight_card.dart:123. |
| `lib/core/models/gateway_insight.dart:103` | `'Hermes review'` | GatewayNotice.title is rendered by core/widgets/gateway_insight_card.dart:123. |
| `lib/core/render/rich_transcript.dart:182` | `'Note'` | AlertBanner reads _labels[alert.type] directly into Text at line 204. |
| `lib/core/render/rich_transcript.dart:183` | `'Tip'` | AlertBanner reads _labels[alert.type] directly into Text at line 204. |
| `lib/core/render/rich_transcript.dart:184` | `'Important'` | AlertBanner reads _labels[alert.type] directly into Text at line 204. |
| `lib/core/render/rich_transcript.dart:185` | `'Warning'` | AlertBanner reads _labels[alert.type] directly into Text at line 204. |
| `lib/core/render/rich_transcript.dart:186` | `'Caution'` | AlertBanner reads _labels[alert.type] directly into Text at line 204. |
| `lib/core/screens/cron_screen.dart:125` | `'Untitled'` | Cron fallback title and Pause/Resume button labels. |
| `lib/core/screens/cron_screen.dart:811` | `'Resume'` | Cron fallback title and Pause/Resume button labels. |
| `lib/core/screens/cron_screen.dart:811` | `'Pause'` | Cron fallback title and Pause/Resume button labels. |
| `lib/core/screens/parallel_workspace_entry.dart:6` | `'Parallel workspace'` | Classic More uses the title/subtitle constants at core/widgets/more_pane.dart:150-151; stale-owner notice is a SnackBar. |
| `lib/core/screens/parallel_workspace_entry.dart:8` | `'Open multiple chats in tabs or side by side.'` | Classic More uses the title/subtitle constants at core/widgets/more_pane.dart:150-151; stale-owner notice is a SnackBar. |
| `lib/core/screens/parallel_workspace_entry.dart:88` | `'The connection changed. Reopen it to use the workspace.'` | Classic More uses the title/subtitle constants at core/widgets/more_pane.dart:150-151; stale-owner notice is a SnackBar. |
| `lib/core/screens/session_list_screen.dart:1391` | `'Space'` | Space-scope display-name fallback. |
| `lib/core/services/ai_search_query_rewriter.dart:43` | `'Choose an AI search model before using AI search.'` | Client-authored AI search errors are shown as SessionSearchException.message by conversation browser surfaces. |
| `lib/core/services/ai_search_query_rewriter.dart:72` | `'The Hermes API rejected the saved API key.'` | Client-authored AI search errors are shown as SessionSearchException.message by conversation browser surfaces. |
| `lib/core/services/ai_search_query_rewriter.dart:83` | `'AI query rewrite failed with HTTP ${response.statusCode}.'` | Client-authored AI search errors are shown as SessionSearchException.message by conversation browser surfaces. |
| `lib/core/services/ai_search_query_rewriter.dart:95` | `'The selected model returned no usable search query.'` | Client-authored AI search errors are shown as SessionSearchException.message by conversation browser surfaces. |
| `lib/core/services/ai_search_query_rewriter.dart:103` | `'Hermes returned a malformed AI rewrite response.'` | Client-authored AI search errors are shown as SessionSearchException.message by conversation browser surfaces. |
| `lib/core/services/chat_space_store.dart:183` | `'A space with this name already exists'` | FormatException.message is shown unchanged by core/screens/spaces_screen.dart:95,136. |
| `lib/core/services/chat_space_store.dart:211` | `'A space with this name already exists'` | FormatException.message is shown unchanged by core/screens/spaces_screen.dart:95,136. |
| `lib/core/services/chat_space_store.dart:249` | `'Space name must be 1–80 characters'` | FormatException.message is shown unchanged by core/screens/spaces_screen.dart:95,136. |
| `lib/core/services/client_certificate_service.dart:181` | `'This certificate needs its password. Enter it below and it will open automatically.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:186` | `'The certificate password is incorrect, or the file is corrupted.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:191` | `'The certificate password is incorrect.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:196` | `'This certificate uses an encryption method the app cannot read.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:200` | `'The selected file is not a readable PKCS#12 (.p12/.pfx) certificate.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:204` | `'The selected certificate could not be read.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:309` | `'That file is not a certificate: pick a .p12/.pfx container or PEM certificate and key files.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:405` | `'The selected certificate is not a PEM certificate.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:411` | `'The selected private key is not a PEM private key.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:434` | `'This certificate needs its password. Enter it below and it will open automatically.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:458` | `'The certificate password is incorrect, or the file is corrupted.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:459` | `'The selected certificate and private key could not be loaded.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:500` | `'The saved client certificate files could not be read.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:527` | `'The client certificate could not be stored securely on this device.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:627` | `'The certificate could not be stored securely on this device.'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/client_certificate_service.dart:722` | `'Client certificate'` | ClientCertificateImportException.message is displayed by main.dart _importCertificate and nextgen/ui/certificate_picker.dart; Client certificate is an app-authored identity fallback label. |
| `lib/core/services/config_backup.dart:108` | `'This file is not a Hermes configuration backup.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:114` | `'This backup was made by a newer version of the app and cannot be '` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:143` | `'This backup claims a client certificate for a connection but '` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:144` | `'does not contain it, so a complete restore is not possible.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:165` | `'This backup file is damaged and could not be read.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:255` | `'A saved preference has an unsupported type and cannot be exported.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:282` | `'This backup file is damaged and could not be read.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:310` | `'Choose a passphrase — the backup contains your API keys.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:315` | `'The backup could not be protected safely.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:333` | `'The backup could not be protected safely.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:363` | `'This file is not a Hermes configuration backup.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:369` | `'This file is not a Hermes configuration backup.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:375` | `'This backup was made by a newer version of the app and cannot be '` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:391` | `'This backup uses an unsupported encryption scheme.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:403` | `'This backup file is damaged and could not be read.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:411` | `'This backup file is damaged and could not be read.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:427` | `'Wrong passphrase, or this backup file has been altered.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup.dart:439` | `'This backup file is damaged and could not be read.'` | ConfigBackupException.message is shown by main.dart _showRestoreError and core/widgets/config_backup_card.dart. |
| `lib/core/services/config_backup_io.dart:74` | `'Hermes configuration backup'` | Share-sheet subject and ConfigBackupException message. |
| `lib/core/services/config_backup_io.dart:95` | `'That file could not be read.'` | Share-sheet subject and ConfigBackupException message. |
| `lib/core/services/config_backup_service.dart:40` | `'$connectionsAdded added'` | ConfigImportResult.summary is shown by main.dart _showRestoreConfig and core/widgets/config_backup_card.dart; backup exceptions also reach those surfaces. |
| `lib/core/services/config_backup_service.dart:41` | `'$connectionsUpdated updated'` | ConfigImportResult.summary is shown by main.dart _showRestoreConfig and core/widgets/config_backup_card.dart; backup exceptions also reach those surfaces. |
| `lib/core/services/config_backup_service.dart:42` | `'$connectionsRemoved removed'` | ConfigImportResult.summary is shown by main.dart _showRestoreConfig and core/widgets/config_backup_card.dart; backup exceptions also reach those surfaces. |
| `lib/core/services/config_backup_service.dart:44` | `'No connection changes'` | ConfigImportResult.summary is shown by main.dart _showRestoreConfig and core/widgets/config_backup_card.dart; backup exceptions also reach those surfaces. |
| `lib/core/services/config_backup_service.dart:46` | `'$connections · $preferencesApplied settings restored'` | ConfigImportResult.summary is shown by main.dart _showRestoreConfig and core/widgets/config_backup_card.dart; backup exceptions also reach those surfaces. |
| `lib/core/services/config_backup_service.dart:118` | `'The client certificate for "${connection.label}" could not be '` | ConfigImportResult.summary is shown by main.dart _showRestoreConfig and core/widgets/config_backup_card.dart; backup exceptions also reach those surfaces. |
| `lib/core/services/config_backup_service.dart:119` | `'included in this backup: ${error.message}'` | ConfigImportResult.summary is shown by main.dart _showRestoreConfig and core/widgets/config_backup_card.dart; backup exceptions also reach those surfaces. |
| `lib/core/services/fleet_ssh.dart:30` | `'Invalid SSH host, port or user.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:51` | `'An OpenSSH Ed25519 public host key is required.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:60` | `'Invalid Ed25519 host key.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:129` | `'Could not verify host-key enrollment.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:130` | `'A different key is already pinned. Verify the change separately.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:139` | `'System OpenSSH is unavailable.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:142` | `'Confirm the host key before connecting.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:147` | `'Select an absolute identity file.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:220` | `'Invalid remote port.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:236` | `'Preview exceeds the 64 KiB limit.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:242` | `'SSH connection refused. Check the enrolled host key, identity and service.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:251` | `'The remote service did not return HTTP 200.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:259` | `'Encoded responses are not supported by this preview.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:268` | `'Only text and HTML source can be previewed.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:274` | `'The service did not confirm gateway health.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/fleet_ssh.dart:276` | `'Gateway is responding on remote loopback port $port.'` | FleetSshException notices and success message are displayed by core/screens/fleet_ssh_screen.dart; host-key/wire serialization is excluded. |
| `lib/core/services/gateway_wake_word.dart:541` | `'Client wake microphone stream failed: $error'` | Locally authored wake notices reach core/widgets/gateway_wake_controls.dart:49-52,272-273,432-433. |
| `lib/core/services/gateway_wake_word.dart:546` | `'Microphone track ended during wake-word capture — re-toggle wake word to re-arm.'` | Locally authored wake notices reach core/widgets/gateway_wake_controls.dart:49-52,272-273,432-433. |
| `lib/core/services/gateway_wake_word.dart:574` | `'Client wake capture stalled: no microphone audio callbacks arrived.'` | Locally authored wake notices reach core/widgets/gateway_wake_controls.dart:49-52,272-273,432-433. |
| `lib/core/services/gateway_wake_word.dart:634` | `'Client wake capture hears only silence — check OS microphone access and re-toggle wake word.'` | Locally authored wake notices reach core/widgets/gateway_wake_controls.dart:49-52,272-273,432-433. |
| `lib/core/services/gateway_wake_word.dart:700` | `'Wake-word feed refused $_feedFailures consecutive frames$detail — re-toggle wake word to re-arm.'` | Locally authored wake notices reach core/widgets/gateway_wake_controls.dart:49-52,272-273,432-433. |
| `lib/core/services/hermes_sign_in.dart:1045` | `'Signed in'` | Browser callback page title and body are directly served by _callbackPage; no localized projection there. |
| `lib/core/services/hermes_sign_in.dart:1045` | `'You can go back to Hermes now.'` | Browser callback page title and body are directly served by _callbackPage; no localized projection there. |
| `lib/core/services/hermes_sign_in.dart:1047` | `'Waiting for sign-in'` | Browser callback page title and body are directly served by _callbackPage; no localized projection there. |
| `lib/core/services/hermes_sign_in.dart:1048` | `'This page is not part of the current sign-in.'` | Browser callback page title and body are directly served by _callbackPage; no localized projection there. |
| `lib/core/services/mobile_push_api.dart:49` | `'Select 1–128 durable session IDs, each 1–200 ASCII characters using '` | Subscription validation/availability diagnostics feed mobile-push error presentation. |
| `lib/core/services/mobile_push_api.dart:50` | `'only letters, digits, _ . : @ or -. Remove blank IDs and whitespace.'` | Subscription validation/availability diagnostics feed mobile-push error presentation. |
| `lib/core/services/mobile_push_api.dart:69` | `'Mobile push is unavailable on this server.'` | Subscription validation/availability diagnostics feed mobile-push error presentation. |
| `lib/core/services/mobile_push_api.dart:73` | `'Invalid server VAPID public key.'` | Subscription validation/availability diagnostics feed mobile-push error presentation. |
| `lib/core/services/mobile_push_api.dart:79` | `'This server needs an updated mobile-push plugin for automatic subscriptions.'` | Subscription validation/availability diagnostics feed mobile-push error presentation. |
| `lib/core/services/mobile_push_service.dart:65` | `'Off'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:119` | `'Android only'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:158` | `'Native notification preferences could not be synchronized.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:215` | `'Choose a saved connection on Android first.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:235` | `'Checking server authorization'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:259` | `'Allow Android notifications before enabling mobile push.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:298` | `'Error'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:320` | `'Off'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:328` | `'Could not persist revocation. Retry disabling before leaving the app.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:360` | `'Off; server API ready'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:363` | `'Error'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:380` | `'Error'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:432` | `'Error'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:505` | `'Off; server revocation pending'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:506` | `'Off'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:522` | `'Off; saved connection changed'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:533` | `'Pending distributor endpoint'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:548` | `'Registering'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:566` | `'Invalid registration response.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:596` | `'Server did not confirm activation.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:605` | `'Active'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:606` | `'Pending encrypted challenge (waiting for silent server verification push)'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:671` | `'Event cursor did not advance.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:702` | `'Event reconciliation incomplete; retry after the server backlog is reduced.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:779` | `'Allow Android notifications in system settings, then retry.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:782` | `'The server mobile-push plugin is unavailable, outdated, or returned an invalid subscription response. Ask the operator to update it, then retry.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:786` | `'No push transport is available. Built-in delivery needs working Google Play Services; alternatively install a UnifiedPush distributor and retry.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:789` | `'Several UnifiedPush distributors are available. Choose one in Advanced transport, then retry.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:792` | `'The selected UnifiedPush distributor is unavailable. Restore it or choose another in Advanced transport.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:797` | `'The server mobile-push companion is unavailable. It may be missing or disabled, or this connection may point to the wrong dashboard. Install or enable the companion on the server, check the dashboard connection, then refresh. See Server setup guide above.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:800` | `'Server denied mobile push. Ask the operator to authorize this principal and these sessions.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/mobile_push_service.dart:804` | `'Mobile push is not ready. Check server plugin authorization, distributor and network, then retry.'` | Client-authored status/availability/error copy is rendered in core/widgets/mobile_push_settings.dart, including statusText at 190. |
| `lib/core/services/model_admin.dart:78` | `'Choose a provider and a model.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:82` | `'Choose a known effort level.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:231` | `'Enter a name for this endpoint.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:234` | `'Enter the model this endpoint serves.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:237` | `'Choose Auto or a known API mode.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:241` | `'This endpoint identifier is not usable.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:253` | `'Use HTTPS for a remote endpoint, or HTTP on localhost.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:260` | `'That API key cannot be saved.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:283` | `'The gateway response did not match the expected shape.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:327` | `'The endpoint answered.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:328` | `'The endpoint did not answer.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:358` | `'The gateway response did not match the expected shape.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:427` | `'Enter iteration, concurrency and timeout limits before saving.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:432` | `'Choose a known effort level.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:455` | `'Each route needs a name and a model before it can be saved.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:459` | `'Route names must be unique.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:467` | `'Choose a known effort level.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:475` | `'The default route has to be one of the saved routes.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:490` | `'Choose a loud or silent degraded-reference policy.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:498` | `'The gateway did not return an active mixture.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:516` | `'Name a provider and model for the aggregator and every reference.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:611` | `'Charge outcome unknown. It may still settle. Check the portal before retrying.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:684` | `'The gateway refused this billing request.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/model_admin.dart:704` | `'Enter the chat id this change applies to.'` | ModelAdminException.message and endpoint-test fallback messages reach core/screens/model_admin_screen.dart (_run at 381-382, endpoint result at 643). |
| `lib/core/services/normal_gateway_application_session.dart:524` | `'Chat'` | OS notification title/body/action fallback copy; also the app-authored default Chat title. |
| `lib/core/services/normal_gateway_application_session.dart:3045` | `'Hermes response ready'` | OS notification title/body/action fallback copy; also the app-authored default Chat title. |
| `lib/core/services/normal_gateway_application_session.dart:3045` | `'Hermes turn failed'` | OS notification title/body/action fallback copy; also the app-authored default Chat title. |
| `lib/core/services/normal_gateway_application_session.dart:3149` | `'Approval needed — $title'` | OS notification title/body/action fallback copy; also the app-authored default Chat title. |
| `lib/core/services/normal_gateway_application_session.dart:3150` | `'Input needed — $title'` | OS notification title/body/action fallback copy; also the app-authored default Chat title. |
| `lib/core/services/normal_gateway_application_session.dart:3153` | `'Open the chat to review the requested action.'` | OS notification title/body/action fallback copy; also the app-authored default Chat title. |
| `lib/core/services/normal_gateway_application_session.dart:3154` | `'Open the chat to respond.'` | OS notification title/body/action fallback copy; also the app-authored default Chat title. |
| `lib/core/services/normal_gateway_application_session.dart:3162` | `'Approve'` | OS notification title/body/action fallback copy; also the app-authored default Chat title. |
| `lib/core/services/normal_gateway_application_session.dart:3163` | `'Deny'` | OS notification title/body/action fallback copy; also the app-authored default Chat title. |
| `lib/core/services/remote_model_admin.dart:40` | `'The gateway returned HTTP ${response.statusCode}.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:49` | `'The gateway response could not be read.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:54` | `'The gateway response did not match the expected shape.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:67` | `'Connect the live gateway session before changing billing or a chat.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:80` | `'This gateway does not provide that operation.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:87` | `'The gateway refused this request.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:95` | `'The gateway response did not match the expected shape.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:108` | `'Enter the key to save.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:116` | `'The gateway did not save that key.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:123` | `'Choose a provider key to clear.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:127` | `'The gateway did not clear that key.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:151` | `'The gateway did not save that endpoint.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:159` | `'This endpoint identifier is not usable.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:168` | `'The gateway did not activate that endpoint.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:176` | `'This endpoint identifier is not usable.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:188` | `'Provider accounts need an authenticated HTTPS gateway, or localhost.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:194` | `'Provider accounts could not be read.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:203` | `'The gateway did not disconnect that account.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:207` | `'That provider account cannot be disconnected.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:221` | `'Choose one of the available delegation backends.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:231` | `'The gateway did not select that backend.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:246` | `'The gateway did not save those routes.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:260` | `'Each profile route needs a profile name.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:264` | `'Profile routes must be unique.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:274` | `'The default profile route has to be one of the allowed profiles.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:284` | `'The gateway did not save those profile routes.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:304` | `'The gateway did not save those limits.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:313` | `'The gateway did not save that mixture.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:363` | `'Choose one of the offered credit amounts.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:377` | `'That charge could not be checked.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:416` | `'Auto-reload amounts were not provided, so they were not changed.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:431` | `'Choose a plan first.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/remote_model_admin.dart:439` | `'Only a scheduled plan change can be confirmed from here.'` | ModelAdminException errors reach core/screens/model_admin_screen.dart:381-382. |
| `lib/core/services/session_search_client.dart:94` | `'Could not reach the dashboard: $error'` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:132` | `'The dashboard rejected the saved credentials. Check the dashboard '` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:133` | `'username and password for this connection.'` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:140` | `'This dashboard does not expose session search. Update Hermes on the '` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:141` | `'host, or switch back to on-device search.'` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:146` | `'The dashboard redirected session search (HTTP '` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:148` | `'credentials; check the connection address.'` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:153` | `'Session search failed with HTTP ${response.statusCode}.'` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:171` | `'The dashboard returned a malformed search response.'` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:177` | `'The dashboard returned an unexpected search response.'` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:186` | `'The dashboard returned more search results than requested.'` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:195` | `'Unexpected message search response.'` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/session_search_client.dart:205` | `'Unexpected message search result.'` | Client-authored SessionSearchException messages are displayed verbatim; these are NOT all server-authored details. |
| `lib/core/services/turn_notification_service.dart:294` | `'Approve'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:295` | `'Deny'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:689` | `'not initialised'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:701` | `'permission denied'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:720` | `'Ares Turns'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:721` | `'Notifications for completed background turns'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:728` | `'Ares Attention'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:729` | `'Approvals and input requests that need you'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:735` | `'Ares Background'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:736` | `'Background task completions'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:742` | `'Ares Notices'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:743` | `'Credit and plugin notices'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:1137` | `'replies are off'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:1193` | `'replies are off'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:1257` | `'conversation; permission denied'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:1345` | `'failures are off'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:1500` | `'permission denied'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/turn_notification_service.dart:1500` | `'not initialised'` | Darwin action labels and Android channel names/descriptions are OS-visible text. App-authored recordAttempt reasons are shown verbatim by core/widgets/recent_notifications_sheet.dart:98-101; diagnostic kind/outcome codes are separate. |
| `lib/core/services/windows_toast_sink.dart:294` | `'Windows did not report its notification setting'` | App-authored Windows notification attempt reasons are shown as raw detail in recent-notification sheets. |
| `lib/core/services/windows_toast_sink.dart:343` | `'notifications are off'` | App-authored Windows notification attempt reasons are shown as raw detail in recent-notification sheets. |
| `lib/core/utils/activity_feed.dart:302` | `'Turn recovery failed'` | ActivityPane renders item.label directly at core/widgets/activity_pane.dart:409. |
| `lib/core/utils/activity_feed.dart:311` | `'Waiting for your input'` | ActivityPane renders item.label directly at core/widgets/activity_pane.dart:409. |
| `lib/core/utils/activity_feed.dart:317` | `'The turn failed'` | ActivityPane renders item.label directly at core/widgets/activity_pane.dart:409. |
| `lib/core/utils/activity_feed.dart:323` | `'Completed'` | ActivityPane renders item.label directly at core/widgets/activity_pane.dart:409. |
| `lib/core/utils/activity_feed.dart:329` | `'Stopped'` | ActivityPane renders item.label directly at core/widgets/activity_pane.dart:409. |
| `lib/core/utils/activity_feed.dart:340` | `'Stalled — no update from Hermes'` | ActivityPane renders item.label directly at core/widgets/activity_pane.dart:409. |
| `lib/core/utils/activity_feed.dart:348` | `'Submitted, waiting for Hermes'` | ActivityPane renders item.label directly at core/widgets/activity_pane.dart:409. |
| `lib/core/utils/activity_feed.dart:348` | `'Running'` | ActivityPane renders item.label directly at core/widgets/activity_pane.dart:409. |
| `lib/core/utils/home_turn_signals.dart:156` | `'Turn recovery failed'` | App-authored Home attention reasons, not wire values. |
| `lib/core/utils/home_turn_signals.dart:159` | `'Waiting for your input'` | App-authored Home attention reasons, not wire values. |
| `lib/core/utils/home_turn_signals.dart:161` | `'The last turn failed'` | App-authored Home attention reasons, not wire values. |
| `lib/core/widgets/image_recovery_capability_notice.dart:18` | `'Image and text recovery is not available on Classic REST/SSE. '` | Both English explanations flow unchanged into Text(text) at line 60. |
| `lib/core/widgets/image_recovery_capability_notice.dart:19` | `'An unacknowledged image send cannot be restored on this connection, '` | Both English explanations flow unchanged into Text(text) at line 60. |
| `lib/core/widgets/image_recovery_capability_notice.dart:20` | `'and nothing is sent again automatically.'` | Both English explanations flow unchanged into Text(text) at line 60. |
| `lib/core/widgets/image_recovery_capability_notice.dart:23` | `'Image and text recovery is not available on companion recovery. '` | Both English explanations flow unchanged into Text(text) at line 60. |
| `lib/core/widgets/image_recovery_capability_notice.dart:24` | `'An unacknowledged image send cannot be restored on this connection, '` | Both English explanations flow unchanged into Text(text) at line 60. |
| `lib/core/widgets/image_recovery_capability_notice.dart:25` | `'and nothing is sent again automatically.'` | Both English explanations flow unchanged into Text(text) at line 60. |
## C. Raw status / diagnostic display sites

Not every raw identifier is a translation defect. Known semantic states need a localized display mapping; unknown future values, technical event/Git codes and free-form server logs should remain diagnosable. Never translate the stored/transmitted status itself.

| File:line | Exact source expression/literal | Why it matters |
|---|---|---|
| `lib/core/capabilities/capability_pages.dart:869` | `subtitle: Text(provider.status),` | Known backend availability codes are unlocalized; map at rendering, retain unknown identifiers. |
| `lib/core/capabilities/capability_pages.dart:905` | `subtitle: Text('${backend.status} ${backend.detail}'.trim()),` | Backend code and free-form diagnostic detail are mixed; localize known status only. |
| `lib/core/capabilities/capability_pages.dart:1068` | `'${item.kind} ${item.origin} ${item.backend}'.trim(),` | Vault item kinds login/address/payment are raw wire values; backend/origin are identities. |
| `lib/core/screens/profile_transfer_screen.dart:200` | `Text('Status: ${current.phase.name}'),` | Transfer enum names are visible along with an English prefix; render localized phase labels. |
| `lib/core/screens/profile_admin_panel.dart:444` | `detail: '${c.id} · ${c.state}',` | Messaging-channel state code is displayed verbatim. |
| `lib/core/screens/profile_admin_panel.dart:557` | `subtitle: SelectableText('${route.signature} · ${route.url}'),` | Signature method is a technical identifier; distinguish from localized route actions. |
| `lib/core/screens/host_operations_screen.dart:377` | `Text('${check.label}: ${check.status}. ${check.message}'),` | Host check status is raw; labels/messages can be server content. Preserve diagnostic details. |
| `lib/core/screens/kanban_board_screen.dart:2334` | `'${_kanbanCardCount(context, board.total)} · ${context.sharedL10n.ng_board_active('${board.activeWorkCount}')} · ${board.defaultWorkspaceKind}',` | Board default workspace-kind code is visible beside localized metadata. |
| `lib/core/screens/kanban_board_screen.dart:4005` | `title: Text(ev.kind),` | Kanban event kind is a raw event identifier, not translated prose. |
| `lib/core/screens/bots_screen.dart:3503` | `title: Text(ev.kind),` | Room event kind is a raw event identifier. |
| `lib/core/screens/bots_screen.dart:1944` | `if (installed) '${status.geometry} · ${status.placement}',` | Display geometry/placement codes are rendered as raw settings values. |
| `lib/core/screens/memory_graph_screen.dart:474` | `label: Text('${provider.name} (${provider.status})'),` | Memory provider status code is displayed verbatim. |
| `lib/core/screens/workspace_workers_screen.dart:287` | `'${l.task_identity(w.id)} · ${l.task_status(w.status ?? l.task_not_supplied)}',` | Localized wrapper still receives a raw worker status code. |
| `lib/core/widgets/git_review_pane.dart:497` | `'${file.status} +${file.added} -${file.removed}${file.staged ? ' · ${context.sharedL10n.release_core_git_staged}' : ''}',` | Git status is a conventional machine code; do not translate the underlying value. |
| `lib/core/widgets/recent_notifications_sheet.dart:93` | `'${_stamp(context, a.at)} · ${a.kind} · ${a.outcome}',` | Notification diagnostic kind/outcome are raw codes by design; not an English UI-label completion claim. |
| `lib/nextgen/ui/settings_page.dart:741` | `'${ngStamp(context, a.at, seconds: true)} · ${a.kind} · ${a.outcome}',` | NextGen notification diagnostic kind/outcome remain raw codes; two app-authored reason sentences are already mapped below. |
| `lib/nextgen/ui/session_dock.dart:574` | `return barrier.reason.isEmpty ? label : '$label: ${barrier.reason}';` | Barrier reason is server diagnostic text, appended to a localized status label. |
| `lib/core/workspace/terminal_page.dart:430` | `t.status = 'Read-only · ${r.status}';` | English prefix plus raw process status code; keep the code stable and map its displayed label. |
## D. Further diagnostics / non-UI English and deliberate exceptions

- **LAN timeout:** `lib/core/services/lan_discovery_service.dart:168`, `TimeoutException('LAN discovery timed out')`, is still interpolated as raw diagnostic detail in the now-localized discovery failure wrapper. Also `:144`, `StateError('Discovery is already running')`, is an internal service guard.
- **Health-check compatibility API:** `lib/core/services/connection_manager.dart:1393-1407`, `ApiHealthCheckResult.userMessage`, retains its old English return strings for compatibility. `main.dart` no longer calls it, but other owners should localize their presentation rather than translating HTTP codes/URLs or changing this API accidentally.
- **Attachment errors:** `lib/core/services/attachment_draft_service.dart:163-240,259,286-311,339-359,387-426,500,576-592` contains app-authored `AttachmentDraftException` English (for example `The selected image is empty or unreadable.`, `Unsupported image format. Choose a JPEG, PNG, or WebP image.`, `Only a failed attachment can be retried.`). Treat these as error-origin follow-up; their many callers include concurrently edited chat and preview surfaces, which were excluded from this audit. Registry candidate JSON has each exact source occurrence.
- **Other transport/validation diagnostics:** JSON/XML/ZIP/PDF parsers, ownership/revocation StateErrors, credential-store invariants, coordinator/journal state errors, raw JsonRpcError fallbacks and log/refusal text are recorded as lexical candidates, not counted as confirmed UI misses without a reviewed presentation sink. Examples: `core/services/attachment_document_service.dart`, `attachment_pdf_service.dart`, `ws_client.dart`, `gateway_turn_coordinator.dart`, and `core/presentation/imported_theme.dart`. Imported-theme FormatExceptions are already converted to localized appearance failures in `core/presentation/presentation_settings.dart:201-204`.
- **Voice controller diagnostics:** `lib/core/controllers/voice_composer_controller.dart:60,63,90,184,189,194,216` stores English statuses (`Speech recognition is unavailable`, `Voice setup failed: $error`, `Listening`, `Dictation ready to edit`). `VoiceComposerIndicator` itself uses localized `listening`; other consumers include the excluded chat file. Do not count these all as rendered misses without a sink.
- **Protocol/matching text:** `core/history/canonical_rewind.dart:41-42,50` mirrors Desktop refusal messages; `models/legacy_background_message.dart`, `legacy_lcm_summary.dart`, `cron_task_prompt.dart` and `utils/android_prompt_context.dart` contain transcript markers or agent-facing instructions, not UI chrome. Keep their matching/control text stable and map presentation by typed reason where needed.
- **Already mapped/backward-compatible English:** `core/l10n/workspace_strings.dart:58-82` and `core/services/fleet_updates.dart` use English state tokens that render through a localization mapper; `core/workspace/workspace_registry.dart` fallback metadata uses `localizedLabel`; `core/render/plugin_slots.dart` Notes uses a localized descriptor in Contributions; `core/services/text_size_preference.dart` and `core/theme/hermes_theme.dart` have compatibility labels but actual controls use localized mappers. These are not newly counted misses.
- **NextGen:** no additional direct client-authored English UI literals were confirmed outside excluded chat/preview/terminal and shared core surfaces. `nextgen/ui/connect_screen.dart:779-783` matches English sign-in tokens but maps all branches to localized keys. `nextgen/ui/main_page.dart:546,555` diagnostic reason sentences are mapped at rendering by `nextgen/ui/settings_page.dart:670-671`. `nextgen/ui/main_page.dart` command-palette keyword aliases are hidden search terms. The `hermes dashboard --host 0.0.0.0` command/clipboard payload, HTTPS, HTTP status strings, font names, product/provider names and protocol/OS identifiers are deliberately unchanged.
- **Conventional names/data:** JSON, Markdown, HTML, OpenRouter, Claude Code, Codex, radio station/provider names, keyboard identifiers (`Cmd / Meta`, `Ctrl`, `Alt`, `Shift`), byte units, numeric counts, times, file/path values and user/server-authored titles/descriptions are not translated as English prose. `core/services/remote_bots.dart:1679` (`Bot Chat`) is also a persisted lookup/title contract; avoid translating its wire value without a separate presentation fallback.
- Read alongside `core-exceptions.md` and `nextgen-exceptions.md`. In particular, their “server diagnostic details” exemption must not hide the locally authored backup, search, certificate, billing and capability failure messages identified in section B.

## Integration and verification

- Static validation only: owned-file Dart formatting/parser, scoped whitespace diff check, registry metadata/placeholder/reference checks, and inventory counts. No tests/analyze/generation/build/commits/index/pushes.
- `misc-owned-files.json` is the exact formatting/write manifest. `misc-audit-candidates.json` is supporting lexical evidence, **not** an all-defects list: it intentionally includes false positives (wire values, URLs, regexes, data and developer exceptions).
- `misc-verification.json` records the exact counts and source hashes for the files in these findings. Line numbers are a source snapshot and may shift if concurrent owners continue editing; each expression is included to make the target unambiguous.
