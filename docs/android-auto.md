# Android Auto: notification/reply milestone

This change implements the notification surface, not an Android Auto launcher app.
For the separate parked, standalone AAOS test APK, see [Ares on the car display](parked-automotive.md).
Assistant finals produced by the live NextGen shell or the classic application-owned
stock gateway path can use `MessagingStyle`, RemoteInput reply and mark-as-read.
Approvals, secret/input requests, failed/unknown turns and generic push hints are not
converted into read-aloud assistant conversations. The car host owns speech output;
Ares does not automatically start a second phone TTS instance or microphone.

## Routing and privacy

- Reply and read PendingIntents target a non-exported receiver and carry only an
  opaque per-notification token. They never contain a connection JSON, credential,
  cookie, prompt or assistant answer. Pending reply text and routing provenance
  reside in the existing Android-Keystore sealed store; no private key is shipped.
- Authority includes exact saved connection metadata, credential-inclusive hash,
  session ID, native revision ticket and expiry (30 minutes). Account mutations,
  preferences changes and targeted cancellation revoke native tokens. Same-value
  account edits do not revive them. Native push snapshots exclude the car queue.
- The receiver claims each action at most once before network activity. Lost claim
  or prompt acknowledgements are uncertain delivery, never permission to resend,
  create a fresh chat, switch accounts or fall back to UI autosend.
- Dart refreshes physical credentials, uses profile-scoped dashboard session lookup
  with per-page fences, resumes the existing session read-only, requires explicit
  idle state with no pending server requests, and submits through the existing
  application-owned normal gateway/journal. Native authority is rechecked through
  setup, baseline, write-ahead, socket/ticket/resume and prompt wire boundaries.
- A conversation stands in for the completion alert only when the native owner
  accepts it; a failed car path never loses the alert. Conversations are attempted
  only after this engine's native owner has answered a claim. When the owner is
  absent or rejects the post, the existing ordinary alert is posted instead (the
  classic path keeps its generic "Hermes response ready" notice), unless a
  targeted cancellation superseded the post. Ongoing-chat cleanup never depends
  on the car owner and does not revoke sibling tickets.
- Mark-as-read clears the exact notification and records the existing device-local
  read watermark. It does **not** claim a server-wide read receipt. Body tap uses
  the existing root notification navigation, never a new chat.
- No car/TV service, IOT-category misclassification, accessibility keyboard,
  voice-interaction role, overlay/exact-alarm permission, added wake lock, boot receiver,
  permanent foreground service, plaintext car-auth cache or automatic phone TTS.
  The existing bounded foreground protection and canonical signing remain intact.

## Acceptance limits / release blockers

The receiver performs native work without an Activity, but **does not start a new
headless Flutter engine**. With an existing engine, queued replies drain immediately;
otherwise they wait for ordinary app startup and expire rather than resurrecting
an engine with unfenced account stores. Thus killed-process immediate reply delivery
is not delivered, and this must not be advertised as complete first-class Auto
support. A future engine owner must install all existing secure storage/mutation
plugins and pass the same authority/uncertainty tests before enabling cold execution.

No real head-unit/DHU/device validation is included. Before publication, test parked
or as a passenger: car read-aloud/voice input, current profile and existing-session
continuity, permission/channel denial, OS/OEM background restrictions, process death,
notification expiry/replacement/read, concurrent phone/other-client turns, account
edit/removal and reconnect after uncertain wire delivery. The server remains the
final arbiter of concurrent cross-client submissions. Unsupported/unknown idle state
fails closed. Car-category/store acceptance is not established by manifest metadata.

Dart protocol seams and Robolectric tests are not Android Keystore acquisition,
physical head-unit or killed-process end-to-end proof. The parent maintenance owner
runs the complete suite; this branch runs focused gates only.
