# Parallel workspace (F05)

In **Classic → More → Parallel workspace** or **NextGen → sidebar → More → Parallel workspace**, choose **Add chat**. The picker lists stored conversations on the selected owner. **Workspace options → Dock another pane** places an open tab or another chat beside it. Use **Workspace tools** to open the selected chat's details alongside the transcript or copy its ID. Classic connections to an unqualified legacy history API cannot safely resolve named profiles; the menu explains how to use a profile-aware connection instead.

- Choose a tab to bring it forward. The split can be horizontal or vertical, resized in three steps, swapped or undocked. **Hide pane** keeps the tab and its state mounted. **Close tab** releases its view; it does not archive the conversation. Reopen restores the view, not an unsaved editor buffer. Reload, close others/right/all and reordering operate on the selected tab. There are up to 16 open tabs and 16 recently closed tabs.
- If the two chat surfaces would not fit, the same pair becomes one full-width pane with **Switch pane**. **Focus pane full screen** hides the strip and the other pane; **Show workspace** brings them back. Resizing does not recreate tabs or transfer a draft to a neighbour.
- Layout changes are saved locally. **Save named layout** stores an arrangement; saving to an existing name requires confirmation. **Restore named layout** restores tab order, visible panes, orientation and split ratio. Loading a layout or leaving the workspace can dispose pages; use hide or undock to leave a page running. Restoring a chat always re-resolves its ID against the current owner's roster; absent rows and unregistered pages are not substituted with other chats.
- **Open chat in new window** is for stored chats on macOS, Windows and Linux. Move the independent OS window to another monitor using the window manager. A pop-out does not copy the original draft. See [IPC, lifecycle and platform gates](desktop-chat-popout.md). On a phone use the full-screen pane and **Switch pane**, not an external browser.

## Integration contract

`lib/core/workspace/workspace_registry.dart` is the shared, **trusted Dart** action/page registry. Both layouts use `aresWorkspaceRegistry`. Put your implementations in a feature-owned module; import the contributions and include them in that composition list. Do not add placeholder entries while a feature is unfinished. IDs must match `[a-z][a-z0-9.-]{0,95}` and be unique across actions and pages; a page ID is also its persisted identity. `ParallelWorkspace(..., registry: WorkspaceRegistry(entries))` is the isolated test/composition seam. The shipped `chat.details` and `chat.copy-id` are runnable reference implementations.

```dart
WorkspacePage(id, label, icon, Widget Function(BuildContext, WorkspaceTarget) build,
    {bool requiresSession = true, WorkspaceAvailability? unavailable});
WorkspaceAction(id, label, icon, FutureOr<void> Function(BuildContext, WorkspaceTarget) run,
    {bool requiresSession = true, WorkspaceAvailability? unavailable});
typedef WorkspaceAvailability = String? Function(WorkspaceTarget);
```

`WorkspaceTarget` exposes `SavedConnection connection`, `Session? session`, `bool nextGen`, and `bool Function() current`. `requiresSession: false` creates a connection-level page; it does not gain authority over an arbitrary chat. Return a human-readable reason from `unavailable` until your real backend grants the required capability. `null` enables the entry. Recheck `current()` after asynchronous waits and immediately before any remote write; revalidate capability and obtain any required confirmation in the handler. Never recover a destination from a global “current gateway”. Never hand the target/connection to untrusted web content or a plugin script. Obtain canonical cwd/capabilities from the owner, not the tab title or saved layout.

Page identity is `(sessionId, pageId)`. Switching, hiding, resizing or docking a page keeps its element and nested navigator alive. Offstage panes cannot receive focus; animation tickers are paused, **not** network subscriptions. PTY and browser integrations should keep their owner-scoped transport in `State`, not start it in `build`; distinguish hide, detach and close. On relaunch, restore a server-backed session/PTY using its own reconnect contract. Do not resurrect privileged operations or silently start a new shell from layout metadata. Use the pane's navigator (`useRootNavigator: false` for dialogs) rather than the app root. Changes to saved accounts revoke the workspace, its nested navigators and child windows.

The shell constructor is `ParallelWorkspace(connection: SavedConnection, nextGen: bool, loadSessions: Future<List<Session>> Function(), buildChat: Widget Function(BuildContext, Session, VoidCallback close), registry: ...)`. Classic and NextGen keep their own production chat transports; the shared layer never issues a prompt, impersonates a runtime session, hosts Hermes, or loads an external dashboard.

## Checks

`test/parallel_workspace_entrypoints_test.dart` opens the two menus and real chat/transcript/composer widgets at phone and desktop widths. The pane tests send synthetic concurrent Classic streams or interleaved NextGen deltas; `test/workspace_layout_shell_test.dart` covers registry execution, hide vs close, revoked callbacks, missing stored sessions and cold restoration. `test/workspace_popout_test.dart` checks target/hand-off guards. See [Linux runner](linux-runner.md) for dependency licences and native smoke evidence. The shell itself adds no package/version to the resolved dependency graph.
