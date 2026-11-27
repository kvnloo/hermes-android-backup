# Bot Mode: New Bot, Edit Profile and roster sections

Ares's F11 roster follows Hermes Desktop b7ee21c14e
(`apps/desktop/src/plugins/hermes-bots`). Code: `lib/core/screens/bot_profile_forms.dart`
(forms, avatar), `lib/core/services/bot_sections.dart` (section model), the
`profiles.*` calls in `lib/core/services/remote_bots.dart`, and the wiring in
`lib/core/screens/bots_screen.dart`. Both layouts render the same screen.

## Gateway methods (tui_gateway/methods_profiles.py)

| Use | Method | Params Ares sends |
|---|---|---|
| Roster, and the record a look save writes over | `profiles.list` | `include_sessions` |
| New Bot | `profiles.create` | `name`, `description`, `clone_from` (null = fresh), `no_skills`, `share_auth`, `soul`, and `model` + `provider` only as a pair |
| Edit Profile, Advanced | `profiles.describe` | `name` |
| Look, description, Advanced sections | `profiles.configure` | `name` plus only the sections that changed |
| Picture | `profiles.set_asset` / `profiles.get_asset` | `name`, `asset: avatar`, `data` (PNG data URL) or `clear: true` |

All of them go on the connection's socket with no `profile` param (launch
scoped, like `profiles.list`). A refusal keeps the gateway's message
(`BotProfileRefusal`) so the form shows it inline.

## New Bot (create-dialog.tsx)

- The profile is created on Create only. Cancel sends nothing. Desktop's
  draft-on-Capabilities-tab flow is not ported (Ares has no Capabilities tab
  in the form), so there is never a draft to discard.
- The id is Desktop's `slugifyProfileName` of the typed name and must match
  `PROFILE_ID_RE` (`^[a-z0-9][a-z0-9_-]{0,63}$`). A name on the roster is
  taken. Reserved names (`hermes`, `test`, …) are the gateway's to refuse.
  `botProfileSlug` is a line-for-line port: NFC, then each letter or digit
  through NFKD without its combining marks (`unorm_dart`, MIT, Unicode 18
  tables; see NOTICE.md), else a `u<hex>` token. `test/bot_profile_slug_test.dart`
  holds it to the ids Desktop's own function gives for 41 names
  (`Ｂｏｔ２` → `bot2`, `ﬁle` → `file`, `Ⅻ` → `xii`, `ǿ` → `u1ff`, the 64-character
  cut).
- `description` is `Title — description`; SOUL.md is Desktop's composed
  persona unless the user wrote one. The teammate protocol is never
  appended: the gateway injects it (`bot_mode_protocol`).
- Then the look (`shape`, `color`, `imageKind`, `title`, `created`) is
  written to `ui_meta['hermes-bots']` and the picture to the asset store.
  Desktop's intro turn and Bot Chat birth (`createCanonicalChat` with
  `kickoff`) are not run: opening Bot Chat later finds or makes the chat.

## Avatar (avatar-picker.tsx)

Desktop's classic shapes (`circle`, `blob`, `squircle`, `pill`, `triangle`,
`hexagon`, `cloud`, `drop`), the 12 `PROFILE_SWATCHES` (`hsl(h 68% 58%)`, in
Desktop's spelling), "Match the name", and an uploaded picture (PNG, JPEG,
WebP or GIF up to 15 MB, cropped to a 256 px PNG). The picker returns a
path, not the bytes (`withData: false`): the picker's size and then the
file's length on disk are checked against 15 MB before anything is read
(`readBotAvatarFile`). The picture is decoded at `botAvatarDecodeSize` of the
size its header gives (short side down to 256 px, long side at most
2048 px), so a small file claiming huge dimensions is never decoded at full
size (`test/bot_avatar_pick_test.dart`, `test/bot_avatar_decode_test.dart`).
Desktop's Generate
(`image.generate`) and Pet tabs and its generated blob faces are not ported;
a `blobatar…` shape from Desktop is drawn as `blob`.

## Edit Profile (edit-profile-dialog.tsx)

Only what changed since the form opened is written:

- look: the changed fields (`editedLook`) over the bot's current record,
  re-read from `profiles.list`, with `ui_meta_expected_revisions`; a
  conflict re-reads and retries (3 times), so another writer's fields stay;
- picture: only when it changed;
- one `profiles.configure` with `description` and the dirty Advanced
  sections. Skills, toolsets and MCP lists replace what the profile had; all
  or no toolsets clears the pin. A guarded model answers `confirm_required`;
  Ares shows the gateway's message and resends the model alone with
  `confirm_expensive_model`.

Removing the picture, replacing SOUL.md or turning off a skill, toolset or
MCP server asks first. Desktop writes the description with
`cli.exec profile describe`; Ares uses `profiles.configure description`,
the gateway's typed editor path. Clearing the model (Desktop's
`config unset model`) is not offered: both provider and model are required.

## Roster search (data.ts, filterBots)

`filterBotRoster` in `remote_bots.dart`. The query is trimmed, lowercased
and loses a leading `@`. It matches the title the row shows (the record's
`title`, else the profile's display name, else its id) and Desktop's
`displayName` spelling of it (`research-buddy` as "Research Buddy", the
untitled default profile as "Hermes"), the profile id, the @handle (`hermes`
for `default`), the description, and the preview of the latest activity
(the fresher of the Bot Chat and the last session, Desktop's
`botActivitySession`). Ares also matches the row's subtitle (model and
provider) and the last session's preview, both of which it shows. Search
narrows the roster and never re-orders it.

## Sections (user-sections.ts)

- Membership is on the bot (`sectionId`, `sectionName` in its record).
- The section list is this device's: SharedPreferences key
  `bot-sections-v1:<connectionId>:<gateway profile>` holding only ids and
  names. Desktop keeps one list per Desktop; Ares keeps one per connection.
- Sections another device made are rebuilt from their members.
- Collapse lasts for the visit; nothing is collapsed while searching.
- Delete has no confirmation and offers Undo, as Desktop: nothing is lost.

## Owner scoping

Each request captures the bound target before its first await and checks
`_owns(target)` after every await. A reply that lands after the connection
changed is dropped: the form closes, nothing more is sent, nothing is
reported.
