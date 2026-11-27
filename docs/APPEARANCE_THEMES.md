# Appearance themes

Hermes Android has ten device-wide colour themes: **Gold, Purple, Orange, Green, Blue, Red, Teal, Pink, Indigo and Cyan**.

## Choosing a theme

- Open **More → Settings → Appearance → Colour theme**, or tap the palette icon on the connection screen.
- Choose a colour. Changes apply immediately across existing screens without closing chats or discarding composer drafts.
- Choose **System**, **Light** or **Dark** independently of the colour theme.
- Appearance controls work without a gateway connection and remain available if loading server settings fails.
- The selected colour and brightness mode survive app restarts and are included in configuration backups. A rejected settings write restores the prior selection and displays an error; appearance writes are serialised so a failed older choice cannot overwrite a newer one.

## Colour coverage

The palette supplies the complete Material colour scheme and Hermes design tokens, including tinted backgrounds and cards, app bars, navigation, buttons, switches, input fields, menus, sheets, dialogs, selection, chat bubbles, tool cards and code blocks. Markdown text and code syntax use foreground colours suited to their actual backgrounds. The Hermes wordmark retains its Cinzel font and follows the chosen accent.

Status colours retain their meaning: errors remain red, success remains green, and warnings remain amber. Their tones adapt to light/dark mode. Alternative-colour swatches and media content are not recoloured. Fullscreen image viewing deliberately retains a black canvas and a white close icon on a black button.

The Android launcher icon and native launch screen are branding assets, not Flutter theme surfaces. Once Flutter is visible, status icons follow the app's selected light/dark mode. Gesture navigation remains transparent over the themed app. Three-button navigation receives a palette-matched surface in the OS-compatible brightness, because some Android versions tint those system buttons from the OS mode even when the app requests otherwise. This narrow system-chrome exception keeps buttons readable when the app and OS use opposite modes; it does not alter the chosen app theme.

## Inline embeds

**Settings → Appearance → Inline embeds** matches Hermes Desktop's setting of the same name. Rich previews come from third-party sites, so the choice applies before anything is fetched:

- **Ask** (the default) shows a placeholder naming the host for each https Markdown image and each bare YouTube, Vimeo, X, TikTok or Spotify link. **Load** shows that one embed; **Always allow _service_** remembers the service (an image's host, or the provider). Nothing is requested until you choose.
- **Always** loads them without asking.
- **Off** keeps plain links. An image becomes a link to itself.

**Reset _N_ allowed services** clears the remembered services. The setting replaces the earlier **External embeds** switch: on becomes Always, off becomes Ask.

Ares has no WebView, so no provider page, frame or script runs in the app. Images are downloaded only over https, without cookies, up to 8 MiB, and decoded no larger than 2048 pixels on the longer side; a failure leaves a link to the image. Provider previews show the provider's public title and thumbnail from its documented oEmbed endpoint (YouTube, Vimeo, X, TikTok and Spotify) or YouTube's thumbnail URL, and only those hosts and their thumbnail CDNs are contacted. Google Maps, OpenStreetMap, Instagram and Pinterest publish no keyless preview endpoint: their card is drawn from the link alone, contacts nobody, and needs no consent. Tapping any preview opens the link in your browser, and the link in the reply stays tappable in every mode. Providers are recognised by exact host or subdomain, never by a substring, so `eviltiktok.com` or `maps.google.evil.example` are ordinary links.

## Radio

**Settings → Appearance → Radio** plays a fixed list of internet radio streams. They come straight from third-party broadcasters, not from Hermes or your gateway: **Nightride FM** (`stream.nightride.fm`: Chillsynth, Nightride, Darksynth and Spacesynth), **Radio Paradise** (`stream.radioparadise.com`: Main Mix and Mellow Mix) and **GamingNow** (`media01.gamingnow.net`: EVE Radio). The stream addresses are built into the app; preferences store only a station's ID, so they cannot point the player anywhere else.

Nothing connects when you switch the radio on, choose a station or search the presets (search runs on this device). A stream starts only when you press **Play**, and Pause or switching the radio off releases it. While the station picker is open and a Nightride FM or GamingNow station is playing, Ares also reads that broadcaster's now-playing title from the same server (Radio Paradise offers none). The broadcaster sees your IP address as it would in a browser.

## Development and regression checks

- `lib/core/theme/hermes_theme.dart` owns palette seeds, semantic ramps, full colour schemes and component defaults.
- Read active colours through `HermesTokens.of(context)` or `Theme.of(context).colorScheme`. Do not instantiate default token sets inside presentation widgets; doing so ignores the selected palette.
- Use the paired `onAccent` and `onAccentContainer` foregrounds over their respective fills. Use `foregroundFor` for opaque semantic fills, not a fixed white/black assumption.
- `ThemePreferenceStore` persists enum names under `theme_palette`, independently of `theme_mode`. Unknown or incorrectly typed values fall back non-destructively to Gold.
- Save and rollback completion refresh the surviving app even if the Appearance sheet or picker has closed. Only picker-local state and error snackbars depend on the picker still being mounted.
- Code-block caches retain parser nodes, not theme-dependent text styles, so existing blocks recolour on same-brightness palette changes.
- Contrast tests cover every palette in light/dark mode, normal-size body/muted/accent text, semantic badges, selected surfaces, scheme pairs and component foregrounds with a minimum 4.5:1 text contrast.
- Widget tests cover live selection, navigation/draft retention, restart, backup restoration, offline Settings, and compact layouts with enlarged text.
- `test/theme_source_guard_test.dart` rejects fixed UI colours outside the design system, apart from narrow media exceptions.
- `test/imported_theme_surfaces_test.dart` measures body, secondary, hint, disabled and accent text on every surface an imported VS Code theme paints (page, cards, inputs and the composer, sidebar, selected rows, chips, menus, dialogs, snack bars, tooltips) in both layouts, both app brightness modes and a NextGen pop-out window.
- `test/inline_embeds_test.dart` records every HTTP request: Ask fetches nothing before a choice, Always only the allowed https hosts, Off nothing; `test/presentation_radio_test.dart` checks that only Play opens a stream.

Run Flutter validation serially in a checkout to avoid races in generated test assets:

```sh
flutter gen-l10n
flutter analyze --no-pub --fatal-infos
flutter test --no-pub
flutter build apk --debug --target-platform android-arm64 --no-pub
```
