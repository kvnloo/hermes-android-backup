#!/usr/bin/env python3
"""Disposable loopback SSH and Webapp peer. It does not install Hermes, execute
client command strings, or forward connections. SSH and host-terminal sessions
each own one POSIX PTY running a fixed read/print loop.
"""
import asyncio
import contextlib
import fcntl
import json
import os
import pty
import secrets
import struct
import sys
import tempfile
import termios
import traceback

import asyncssh
from aiohttp import web, WSMsgType

META = "\0HERMES_TERMINAL_META:"
SECRET = secrets.token_urlsafe(32)
COOKIE = secrets.token_urlsafe(32)
PROGRAM = r"""test -t 0 || exit 3
stty -echo
printf '%s\n' tty-ready
n=0
while IFS= read -r value; do
  n=$((n+1))
  printf '%s:%s:%s\n' "$n" "$(stty size)" "$value"
done
"""


class HostPty:
    def __init__(self, fd, proc):
        self.fd = fd
        self.proc = proc
        self.viewer = None
        self.history = bytearray()
        self.pending = bytearray()
        self.lock = asyncio.Lock()
        self.task = asyncio.create_task(self._drain())

    @classmethod
    async def create(cls, cwd):
        fd, slave = pty.openpty()
        fcntl.ioctl(fd, termios.TIOCSWINSZ, struct.pack("HHHH", 24, 80, 0, 0))
        try:
            proc = await asyncio.create_subprocess_exec(
                "/bin/sh", "-c", PROGRAM,
                stdin=slave, stdout=slave, stderr=slave, cwd=cwd,
                env={"PATH": "/usr/bin:/bin", "HOME": cwd, "TERM": "xterm-256color"},
            )
        finally:
            os.close(slave)
        return cls(fd, proc)

    def resize(self, cols, rows):
        fcntl.ioctl(self.fd, termios.TIOCSWINSZ, struct.pack("HHHH", rows, cols, 0, 0))

    async def _drain(self):
        try:
            while data := await asyncio.to_thread(os.read, self.fd, 4096):
                await self._publish(data)
        except OSError:
            pass

    async def _publish(self, data):
        async with self.lock:
            self.history.extend(data)
            del self.history[:-65536]
            if self.viewer is None:
                self.pending.extend(data)
                del self.pending[:-65536]
            else:
                await self.viewer(data)

    async def handoff(self, send_prefix, send_bytes):
        """Send the greeting and the retained transcript before any newer output."""
        async with self.lock:
            await send_prefix()
            if self.history:
                await send_bytes(bytes(self.history))
            self.pending.clear()
            self.viewer = send_bytes

    def detach(self, send):
        if self.viewer is send:
            self.viewer = None

    async def close(self):
        if self.proc.returncode is None:
            self.proc.terminate()
        with contextlib.suppress(ProcessLookupError):
            await self.proc.wait()
        self.task.cancel()
        with contextlib.suppress(asyncio.CancelledError, OSError):
            await self.task
        with contextlib.suppress(OSError):
            os.close(self.fd)


class SSH(asyncssh.SSHServer):
    def begin_auth(self, username):
        return True

    def password_auth_supported(self):
        return True

    def public_key_auth_supported(self):
        return False

    def validate_password(self, user, password):
        return user == "fixture" and secrets.compare_digest(SECRET, password)


async def ssh_process(process, cwd):
    if process.command or not process.term_type:
        process.exit(1)
        return
    shell = await HostPty.create(cwd)

    async def write(data):
        process.stdout.write(data)
        await process.stdout.drain()

    try:
        await shell.handoff(lambda: asyncio.sleep(0), write)
        while True:
            try:
                data = await process.stdin.read(4096)
            except asyncssh.TerminalSizeChanged as change:
                shell.resize(change.width, change.height)
                continue
            if not data:
                break
            os.write(shell.fd, data)
    finally:
        shell.detach(write)
        await shell.close()
        process.exit(0)


async def main():
    with tempfile.TemporaryDirectory(prefix="ares-pty-") as cwd:
        key = asyncssh.generate_private_key("ssh-ed25519")
        ssh = await asyncssh.create_server(
            SSH, "127.0.0.1", 0, server_host_keys=[key], encoding=None,
            agent_forwarding=False, x11_forwarding=False,
            process_factory=lambda process: ssh_process(process, cwd),
        )
        tickets = {}
        terminals = {}
        row = {"id": "stored", "profile": "work", "cwd": cwd, "git_metadata_generation": 1}

        def allowed(req):
            return secrets.compare_digest(req.cookies.get("hermes_session_at", ""), COOKIE)

        def take_ticket(req, kind):
            if "ticket" in req.query or "token" in req.query:
                return False
            offered = req.headers.get("Sec-WebSocket-Protocol", "").split(",")
            return any(tickets.pop(item.strip(), None) == kind for item in offered)

        async def handle(req):
            path = req.path.removeprefix("/prefix")
            query = req.query
            if path == "/auth/password-login" and req.method == "POST":
                body = await req.json()
                if body.get("provider") != "basic" or not secrets.compare_digest(body.get("password", ""), SECRET):
                    raise web.HTTPForbidden()
                response = web.json_response({"ok": True})
                response.set_cookie("hermes_session_at", COOKIE, httponly=True)
                return response
            if path in ("/api/ws", "/api/host-terminal"):
                kind = "gateway" if path == "/api/ws" else "host-terminal"
                if not take_ticket(req, kind):
                    raise web.HTTPForbidden()
                socket = web.WebSocketResponse(protocols=["hermes-gateway-v1"])
                await socket.prepare(req)
                if kind == "gateway":
                    await socket.send_json({"jsonrpc": "2.0", "method": "event", "params": {
                        "type": "gateway.ready", "payload": {"session_authority": True}}})
                    async for frame in socket:
                        if frame.type != WSMsgType.TEXT:
                            continue
                        rpc = json.loads(frame.data)
                        method = rpc.get("method")
                        result = {}
                        if method == "session.resume":
                            result = {"session_id": "runtime", "stored_session_id": "stored", "info": {
                                "profile_name": "work", "cwd": cwd, "terminal_backend": "local"}}
                        params = rpc.get("params") or {}
                        if method == "process.list" and params.get("session_id") == "runtime":
                            result = {"processes": [{"session_id": "proc-1", "status": "running", "output_tail": "snapshot"}]}
                        if "id" in rpc:
                            await socket.send_json({"jsonrpc": "2.0", "id": rpc["id"], "result": result})
                        if method == "process.list" and params.get("session_id") == "runtime":
                            for sid, event, payload in [
                                ("sibling", "agent.terminal.output", {"process_id": "proc-1", "chunk": "foreign"}),
                                ("runtime", "agent.terminal.output", {"process_id": "proc-1", "chunk": "live"}),
                                ("runtime", "terminal.close", {"process_id": "proc-1"}),
                            ]:
                                await socket.send_json({"jsonrpc": "2.0", "method": "event", "params": {
                                    "type": event, "session_id": sid, "payload": payload}})
                    return socket
                if query.get("profile") != "work" or query.get("cwd", cwd) != cwd:
                    await socket.close(code=4403)
                    return socket
                attach = query.get("attach")
                closing = query.get("action") == "close"
                if closing:
                    shell = terminals.pop(attach, None) if attach else None
                    if shell is None:
                        await socket.close(code=4403 if not attach else 4410)
                        return socket
                    await shell.close()
                    await socket.send_str(META + json.dumps({"terminalId": attach, "closed": True}))
                    await socket.close(code=1000)
                    return socket
                if attach and attach not in terminals:
                    await socket.close(code=4410)
                    return socket
                token = attach or secrets.token_urlsafe(32)
                shell = terminals.get(token)
                if shell is None:
                    shell = terminals[token] = await HostPty.create(cwd)

                async def send(data, current=socket):
                    await current.send_bytes(data)

                meta = META + json.dumps({
                    "terminalId": token, "cwd": cwd, "shell": "sh",
                    "reconnected": bool(attach), "truncated": False})
                await shell.handoff(lambda: socket.send_str(meta), send)
                try:
                    async for frame in socket:
                        if frame.type == WSMsgType.BINARY:
                            os.write(shell.fd, frame.data)
                        elif frame.type == WSMsgType.TEXT and frame.data.startswith("\x1b[RESIZE:"):
                            cols, rows = map(int, frame.data[9:-1].split(";"))
                            shell.resize(cols, rows)
                finally:
                    shell.detach(send)
                return socket
            if not allowed(req):
                raise web.HTTPForbidden()
            if path in ("/api/auth/ws-ticket", "/api/webapp/socket-ticket") and req.method == "POST":
                kind = "gateway" if path == "/api/auth/ws-ticket" else query.get("socket")
                if kind not in ("gateway", "host-terminal"):
                    raise web.HTTPBadRequest()
                token = secrets.token_urlsafe(32)
                tickets["hermes-gateway-ticket." + token] = kind
                return web.json_response({"ticket": token, "ttl_seconds": 30})
            if query.get("profile") != "work":
                raise web.HTTPForbidden()
            if path == "/api/sessions/stored":
                return web.json_response(row)
            if path == "/api/tools/terminal/backends":
                return web.json_response({"active": "local", "backends": []})
            raise web.HTTPNotFound()

        app = web.Application()
        app.router.add_route("*", "/{tail:.*}", handle)
        runner = web.AppRunner(app, access_log=None)
        await runner.setup()
        site = web.TCPSite(runner, "127.0.0.1", 0)
        await site.start()
        print(json.dumps({
            "http": runner.addresses[0][1], "ssh": ssh.get_port(),
            "pin": key.get_fingerprint(), "secret": SECRET,
        }), flush=True)
        try:
            await asyncio.to_thread(sys.stdin.buffer.read, 1)
        finally:
            ssh.close()
            await ssh.wait_closed()
            for shell in list(terminals.values()):
                await shell.close()
            await runner.cleanup()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except Exception:
        traceback.print_exc()
        raise
