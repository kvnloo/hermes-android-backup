# Terminals (F08)

Open **More → Parallel workspace**, choose a chat, then **Workspace tools → Terminals**. Nothing starts until you choose a terminal. The same page is used by Classic and NextGen.

| Action | What it does |
|---|---|
| Gateway host terminal | Asks for confirmation, then attaches a shell on that chat’s authenticated gateway. The tab is labelled with the gateway address. A URL or Cloud login with no workspace owner is shown as unsupported and does not open a shell on this device. |
| Verified SSH terminal | Connects only after you enter the host, user, independently obtained `SHA256:` host-key fingerprint, and a password. The password is not saved. A mismatched fingerprint never reaches authentication. |
| This device | Desktop only. Runs the packaged `ares-pty` helper, which opens the system shell in a private PTY. Phones show **Local shell unavailable on mobile** and do not launch a shell. |
| Hide pane | The workspace keeps the terminal mounted, including its PTY or gateway socket and scrollback. |
| Close shell / close the workspace tab | Ends that shell, including after the originating chat tab has closed. Typing, paste, and resize are still refused until that chat is open again. Closing a read-only agent-process mirror does not stop the process. |
| Reconnect same shell | Reattaches the same gateway terminal id and rebuilds the view from the server’s retained output. It never creates a replacement shell. |
| Select or copy output | Opens the buffered text. **Add selected output to chat draft** inserts the xterm selection into the originating chat only. Keyboard paste, the terminal context menu, and dropped text are shown for confirmation before they reach the shell. A paste over 16 KiB is refused. |

Agent process rows come from the owning chat’s `process.list` snapshot plus `agent.terminal.output` / `terminal.close` on that runtime session. Output for another session is ignored.

## Dependencies

Direct application packages added for this surface: `xterm` 4.0.0 (MIT), `dartssh2` 4.1.0 (MIT), and their existing MIT/BSD/Apache transitive packages (`equatable`, `quiver`, `zmodem`, `asn1lib`, `pinenacl`, `pointycastle`). No AGPL or GPL package was added. The desktop helper is two first-party C++ files, built by the macOS embed phase, Linux CMake, and Windows CMake. It is not a downloaded native library.

`tool/terminal_fixture/peer.py` is test-only. It uses AsyncSSH (Eclipse Public License 2.0), which is not an application dependency and is not bundled.

Closing the helper signals every process group in the shell's descendant tree: SIGHUP, then SIGTERM, then SIGKILL, with up to half a second of grace between them while any of those processes is still alive. A background job therefore does not outlive Close shell or app exit. The Windows helper still puts `cmd.exe` in a job object that ends the job when the helper closes, and it gives `cmd.exe` `SystemRoot` plus a PATH of `%SystemRoot%\System32;%SystemRoot%`.

Terminal SSH host-key pins are not stored yet. They should use the same store and format as `lib/core/services/fleet_ssh.dart` once that file is on this branch. Until then, each verified SSH terminal still asks for the `SHA256:` fingerprint and does not remember it.

## Checks

```sh
mkdir -p build/pty-tmp
export TMPDIR="$PWD/build/pty-tmp"
clang++ -std=c++17 -Wall -Wextra -Werror native/terminal/pty_posix.cc -o build/pty-tmp/ares-pty
uv venv --python python3 build/pty-tmp/venv
uv pip install --python build/pty-tmp/venv/bin/python asyncssh aiohttp
ARES_TERMINAL_FIXTURE_PYTHON="$PWD/build/pty-tmp/venv/bin/python" \
ARES_TERMINAL_FIXTURE_HELPER="$PWD/build/pty-tmp/ares-pty" \
flutter test --no-pub --concurrency=1 \
  test/workspace_terminal_wire_test.dart \
  test/workspace_terminal_page_test.dart \
  test/workspace_terminal_review_test.dart
```

The wire test drives real POSIX PTYs through the production gateway-ticket client and the production SSH client. The page test opens both workspace menus, refuses a gateway shell when the chat has no owner, shows the disabled mobile local-shell row, and checks that hiding the pane leaves `ares-pty` running while closing the tab stops it.

**Not verified here:** packaged macOS/Windows/Linux/Android/iOS builds, Windows ConPTY execution, and a live Hermes host. The disabled local-shell row is covered by a widget test that forces the mobile check; a physical phone was not used. The Windows helper is compiled by the existing Windows CMake file but was not executed on Windows.
