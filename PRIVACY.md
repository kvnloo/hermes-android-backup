# Ares privacy policy

**Effective: 27 November 2026**

Ares (formerly Hermes Android) is a free, open-source client for a Hermes Agent server chosen by you or your organisation across Android, iOS, macOS, Windows and Linux. The app developer does not operate your server and does not receive your chats by default.

For privacy questions or requests, email <sam@samrusselltech.net> or open an issue at <https://github.com/rusty4444/ares/issues>. Do not post passwords, access tokens, private chats or other sensitive material in a public issue.

## Information stored on your device

Ares stores the settings and connection details needed to provide the app, including gateway addresses, usernames, SSH host key trust records, display preferences, chat drafts and cached files. Passwords, tokens and private keys are stored using platform-provided secure storage (such as Android Keystore, Apple Keychain on iOS and macOS, or OS credential storage on Windows and Linux) where the platform supports it. Configuration backups can contain sensitive connection material and are encrypted with the passphrase you choose.

When client-direct speech features are used, gateway-supplied speech provider credentials may be held temporarily in client memory only; they are not written to disk or logged, and the in-memory cache is cleared when the app is backgrounded, when the connection changes, or on sign-out.

You can remove local app data by clearing the app's storage or uninstalling it. Removing the app does not delete data held by your Hermes server or any configured speech or live-voice provider.

## Information sent to your Hermes server

When you use Ares, the app sends your chosen Hermes server the information needed to perform your requests. This can include:

- prompts, chat content, session identifiers and recent conversation or delegation context used to seed live or delegated sessions;
- photos, audio, video, documents and other files you attach or download, including user-initiated desktop screen or window captures (which become an attachment draft and are not auto-sent);
- microphone audio when you explicitly use dictation or voice features;
- authentication details, SSH connection details and client certificates needed to connect;
- optional in-window presence metadata (runtime session IDs, recent-input age and alert eligibility) when enabled and acknowledged—no keystroke contents or other applications' input are collected;
- model, approval, scheduled-job, project, memory, Kanban and settings actions you choose.

Ares supports both HTTPS and user-selected HTTP endpoints; transport encryption depends on the endpoint you configure. The server operator controls that server's retention, logging, model providers and onward disclosures. Ares does not select or operate those model providers for you. Review your server operator's privacy arrangements.

## Voice, speech providers and WebRTC live conversation

Depending on how your Hermes gateway is configured, Ares supports:

- **Client-direct speech transcription and synthesis:** audio recordings and text may be sent directly from your device to a gateway-configured speech provider (such as OpenAI, xAI, ElevenLabs or another configured endpoint) rather than only to your Hermes server.
- **Live voice via WebRTC:** microphone media tracks, WebRTC session/SDP connection metadata and optional recent conversation or delegation context are transmitted through your gateway and WebRTC session to the configured live-voice provider.

The app developer does not operate those third-party speech or live-voice providers. Their own privacy policies and retention practices apply to data you send through them.

## Distribution and update services

Ares 5.0 and later do not check for updates or download them in-app. Updates are delivered by the store or distribution channel you installed the app from (such as Google Play, the Apple App Store, Microsoft Store, F-Droid or GitHub Releases). That service's own privacy terms apply to how it operates.

Versions up to 4.0.17 that were not installed from Google Play checked GitHub Releases when the app opened, which sent ordinary connection metadata such as your IP address and user agent to GitHub, and could download an update from GitHub. Later versions do not.

## Optional notifications and push

Notifications can be disabled in your operating system settings (Android, iOS, macOS, Windows or Linux) or in the app. Optional push delivery requires the separately installed and authorised mobile-push server companion. Depending on your choices, the service may process session identifiers, registration tokens, endpoint addresses and encrypted challenge material. Notification text is kept minimal by design.

A compatible UnifiedPush distributor, Google Play Services, Apple Push Notification service (APNs) or Windows Notification Service (WNS) may process registration and delivery data. The relevant provider's privacy terms apply. Background delivery is best-effort.

## Analytics, advertising and marketing

Ares contains no advertising SDK and no developer-operated analytics service. It does not sell personal information or use chat content for advertising.

## AI output reports

The **Report AI output** action opens a new public GitHub issue in your browser. Ares does not automatically attach the reply, chat history, credentials or attachment paths. You choose what to submit. Remove sensitive material before posting. Where possible, report safety concerns without publishing personal data.

## External links and user-selected services

Ares can open links in your browser and can share files only when you choose the relevant action. Those destinations are governed by their own privacy policies. A link or file is not sent to a third party by the app unless you request that action.

## Changes

Material changes to this policy will be committed to this repository with the app release that contains them. The effective date above will be updated.
