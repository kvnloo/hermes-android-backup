# Kanban cards in the chat dock

Scope row KDK. An Ares addition; Hermes Desktop has no equivalent.

Any card a chat sends to Kanban shows as a row above that chat's composer,
with its title, status and assignee. The status stays live while the chat is
on screen. Tapping a row opens the card in Ares's Kanban board (F12) on the
same connection, profile and board.

## Where the rows are

- **NextGen:** a fourth section of the dock (`NgDock`,
  `lib/nextgen/ui/session_dock.dart`), after goal, subagents and tasks. It
  folds like them and shares the dock's height cap and scroll.
- **Classic:** Classic has no dock. The strip (`ClassicKanbanDock`,
  `lib/core/widgets/kanban_dock.dart`) sits in the composer's status column,
  directly above the activity bar that shows the running tool or delegated
  task. One row that folds open.

Both draw the same rows (`KanbanDockRows`). The folded row shows the count
("3 Kanban cards · 1 done"), a dot per card and the first unfinished title.
Open, it lists up to five cards, unfinished ones first. More than five adds
**Show all N**, which opens the board filtered to this chat's cards (a
"This chat (N)" chip that can be cleared).

Finished cards (done or archived) stay, dimmed, with a dismiss button. A
dismissal is remembered for that chat on that connection and profile, and is
lifted if the card is reopened on the board.

## Which cards belong to a chat

Two sources, joined by board and task id
(`lib/core/services/chat_kanban_dock.dart`):

1. **The chat's own tool calls.** `kanban_create` gives the new card;
   `kanban_link` gives the two cards it linked. Read from live
   `tool.complete` events and from stored history rows (each assistant
   `tool_calls` entry joined to the tool row that answers it). A refused or
   still-running call gives nothing.
2. **Hermes provenance.** `kanban_db.Task.session_id` is the session whose
   agent loop created the task (`hermes_cli/kanban_db.py:636`, stamped by
   `tools/kanban_tools.py:1143-1146`). The dashboard board API serialises the
   whole task with `asdict(task)` (`plugins/kanban/dashboard/plugin_api.py`,
   `_task_dict`, lines 179-181), so `GET /board` and `GET /tasks/{id}`
   **do return `session_id`**. Ares parses it (`KanbanTaskCard.sessionId`)
   and matches it to the chat's own session ids. This also finds cards a
   worker created under a card the chat made: those inherit the creator's
   session.

Source pin: Hermes `b7ee21c14e38316273f88d8ed112491ba1c87d15`.

A chat's session ids are its stored id plus the ids `session.resume` returns
for it (`stored_session_id`, `resumed`): a compressed chat resumes as its
continuation, and cards made afterwards carry that id. A compression inside
an open chat moves it to the continuation too
(`tui_gateway/session_compression.py`, `_sync_session_key_after_compress`),
and the gateway's next `session.info` names it in `stored_session_id`. Both
layouts add that id as well (NextGen in `NgChatController._withInfo`,
Classic through the chat owner's `kanbanSessionIds` and the screen's
`session.info` handler) and keep the older ones, so cards stamped with
either id belong to the chat.

The board always outranks the transcript: once the board has reported a
card, its title, status and assignee come from the board.

## Live status

The dock reads the board only while it is on screen, and only over the
socket the chat itself opened. It never opens a connection: while the chat's
socket is down it asks nothing, and the chat tells it when the socket is up
again. On open (and when a new card appears) it reads:

- `GET /boards` for the current board,
- `GET /board` for the current board and for each board the chat's own calls
  named,
- `GET /tasks/{id}` for a tracked card missing from that read (an archived
  card), at most eight per read.

It then follows each board that still has an unfinished card of this chat
through the board screen's own `watchKanbanEvents` stream, and re-reads only
when an event names one of its cards or is a `created` event. Such a frame
re-reads only its own board (`GET /board`, no `GET /boards`, no other
board), and asks `GET /tasks/{id}` only for the cards the frame named that
the board no longer lists. Frames are coalesced: the first after a quiet
spell is read at once, and the ones in the 300 ms after it share one read
when that window ends. When every card is finished the stream is closed.

A stream that closes is dialled again from its cursor after 1, 2, 4, 8, 16
and then every 32 seconds, as the board screen does; one that stayed open
for 30 seconds starts again at 1 second. The events in between arrive with
the new stream, so nothing is re-read for the drop itself. If the host
offers no event stream, or while a dropped one waits to be dialled again,
the dock polls that board alone every 15 seconds, the interval the board
screen itself uses, and stops when nothing is unfinished.

On screen means all of: no route covers the chat (`ModalRoute.isCurrentOf`;
the board the dock opened as a route on a phone, a sheet, another screen),
its pane is the one shown (`Visibility.of` and `HermesPaneVisibility`: the
Classic shell keeps visited panes mounted in an `IndexedStack` with their
tickers running) and its tickers run (`TickerMode`). Both layouts use the
same `KanbanDockAttachment` (`lib/core/widgets/kanban_dock.dart`). Leaving
the screen, closing the chat or switching to another one closes the stream,
the poll and the transport. The rows are kept in memory, and coming back
reads the board once and follows it again.

## Opening the board

`openChatKanban` builds the request from the chat's own gateway owner and a
route minted at the tap, so the board opens on the chat's connection and
profile and nowhere else.

- A chat at least **900 px** wide opens the board as a **420 px pane**
  beside itself (`KanbanPaneHost`). The board's sheets stay inside the pane;
  back closes the sheet, then the pane.
- A narrower chat (a phone, a parallel pane under 480 px, a tablet in
  portrait) pushes the board as a route.

If the board cannot open, the row stays and the reason is shown under the
rows and again on a tap:

| Reason | When |
| --- | --- |
| No dashboard access | A REST-only (API server) connection |
| Kanban is not turned on | The dashboard has no kanban plugin (404) |
| Sign in to the dashboard | 401 or 403 |
| Needs HTTPS or a local connection | Plain HTTP to a remote host |
| Could not reach Kanban | Any other failure; a tap still tries the board |
| The connection changed | The connection was edited or signed out |

A tap asks the board once more before refusing, so enabling the plugin or
signing in takes effect without reopening the chat.

## Owner scoping

One controller per chat, on one connection and profile. It reads through
that chat's own `RemoteWorkspaceOwner`, and every answer is checked against
the epoch of its request before it is applied. A read still in flight when
the chat is closed or switched away from is dropped. Events for another
chat's session never reach a controller, and a card whose `session_id` is
another chat's is ignored.

## Limits

- **Boards searched.** Provenance is looked for on the gateway's current
  board and on boards the chat's own calls named. A card on another board
  that only provenance would reveal is not found. The board route has no
  `session_id` filter (`list_tasks` has one at `kanban_db.py:1424`, the
  route does not pass it), so each read fetches the board's open cards.
- **Archived cards.** `GET /board` is read without archived cards. An
  archived card is listed when the chat's transcript names it, not from
  provenance alone.
- **The board of a call.** `kanban_create` answers with the task id and
  status, not the board. The board is the call's `board` argument, else the
  gateway's current board at read time. A card created while another board
  was current is found only if the transcript names its board.
- **Live rows need tool events.** `kanban_create` is not in the gateway's
  always-on tool list (`tui_gateway/agent_factory.py`,
  `_TOOL_LIFECYCLE_UI_TOOLS`), so with tool progress off no live event
  arrives. NextGen then takes the card from the turn's stored rows when the
  turn ends; Classic takes it at its next history read. Classic's REST/SSE
  path carries no tool arguments live and its recovery-v2 path is not read
  live, so their rows also appear after the turn.
- **Deleted cards** leave the dock at the next read.
- **Large text on a small phone, NextGen.** At 320x640 with text at 1.5x or
  more and a keyboard up, the NextGen composer of this branch is itself
  taller than the room left (49 px over at 1.5x with a tasks-only dock, no
  Kanban involved). The composer lane owns that fix. The Kanban section
  lives inside the dock's existing cap, and
  `test/nextgen_kanban_dock_test.dart` holds it to changing nothing about
  where the composer ends up; its strict assertions switch on by themselves
  once the composer fits without the rows. Classic passes the strict case
  at 2.0x with 260 and 340 px keyboards.

## Tests

No live gateway: a fake gateway and a fake Kanban transport
(`test/support/fake_kanban_source.dart`), and the board screen over an
in-memory dashboard (`test/support/kanban_board_fixture.dart`).

- `test/chat_kanban_dock_test.dart`: sources, de-duplication, provenance,
  dismissal, access reasons, stream and poll lifetime, late answers; the
  frame window, per-board and per-card re-reads, and the re-dial backoff.
- `test/nextgen_kanban_dock_test.dart` and
  `test/classic_kanban_dock_test.dart`: a `kanban_create` in a turn makes a
  row with the right status; a status event updates it; a tap opens the
  board with that card selected (route and pane); another chat's card never
  shows; reload from history restores the rows; the reason is shown when
  the board cannot open; the narrow and keyboard cases.
- `test/kanban_dock_compression_test.dart`: both layouts, a compression in
  an open chat; cards stamped with the old and the continuation id both
  stay in the dock.
- `test/kanban_dock_visibility_test.dart`: both layouts, the board route
  the dock opens, a sheet and a hidden IndexedStack pane (the real Classic
  shell) detach the dock; coming back reads once and follows again.
