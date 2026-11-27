#!/usr/bin/env python3
"""Open a saved fixture chat in the real Linux bundle, in both layouts.

Run only in a disposable Linux network namespace with loopback as the sole
interface. No host D-Bus, X display, preference files, or keyring are used.
See docs/linux-runner.md for prerequisites and scope.
"""
import csv
from contextvars import ContextVar
import importlib
import io
import json
import os
from pathlib import Path
import subprocess as sp
import sys
import tempfile
import time

ROOT = Path(__file__).resolve().parents[1]
APP_ID = 'com.hermesagent.ares'
PORT = 18642
OWNER = 'linux-fixture'


def serve(home, workspace=False):
    from aiohttp import web
    sys.path.insert(0, str(ROOT))
    fixture = importlib.import_module('tools.fake_gateway.fake_gateway')

    peer = ContextVar('fixture_peer_port', default=None)

    class DesktopState(fixture.GatewayState):
        def log(self, event):
            if event.get('method') == 'session.resume':
                event = {**event, 'peer_port': peer.get()}
            super().log(event)

    state = DesktopState('unused-fixture-key', home / 'events.jsonl')
    app = fixture.create_app(state)
    sessions = list(fixture.SESSIONS)
    if workspace:
        sessions.append(dict(sessions[0], id='fixture-split', title='Companion chat',
                             preview='Separate synthetic history', message_count=2))
        state.messages['fixture-split'] = [dict(role='user', content='Orchid compass witness.'),
                                           dict(role='assistant', content='Magenta lantern witness.')]

    @web.middleware
    async def desktop_reads(request, handler):
        # The shared fixture models the mobile REST envelope. The single-login
        # desktop client reads the same data using dashboard auth and keys.
        if request.method == 'GET' and fixture.dashboard_authorized(request):
            if request.path == '/api/sessions':
                return web.json_response({'sessions': sessions, 'total': len(sessions)})
            for session in sessions:
                detail = f"/api/sessions/{session['id']}"
                if request.path == detail:
                    return web.json_response({'session': session})
                if request.path == detail + '/messages':
                    return web.json_response({'messages': state.messages[session['id']]})
        if request.path == '/api/ws' and not request.query:
            offered = request.headers.get('Sec-WebSocket-Protocol', '').split(',')
            prefix = 'hermes-gateway-ticket.'
            tickets = [p.strip()[len(prefix):] for p in offered if p.strip().startswith(prefix)]
            if len(tickets) != 1 or 'hermes-gateway-v1' not in map(str.strip, offered):
                raise web.HTTPUnauthorized()
            # Translate only inside the test process for the stock fixture's
            # single-use ticket validator. No credential goes into a URL on wire.
            headers = request.headers.copy()
            del headers['Sec-WebSocket-Protocol']
            request = request.clone(rel_url=request.rel_url.with_query(ticket=tickets[0]),
                                    headers=headers)
            request['linux_smoke_protocol'] = True
        if request.path == '/api/ws':
            token = peer.set(request.transport.get_extra_info('peername')[1])
            try:
                return await handler(request)
            finally:
                peer.reset(token)
        return await handler(request)

    async def select_protocol(request, response):
        if response.status == 101 and request.get('linux_smoke_protocol'):
            response.headers['Sec-WebSocket-Protocol'] = 'hermes-gateway-v1'

    app.middlewares.append(desktop_reads)
    app.on_response_prepare.append(select_protocol)
    web.run_app(app, host='127.0.0.1', port=PORT, print=None, access_log=None)


def capture(home, region=None):
    screenshot = home / 'screen.png'
    crop = ['-a', ','.join(map(str, region))] if region else []
    sp.run(['scrot', '-o', *crop, screenshot], check=True, timeout=5)
    raw = sp.check_output(['tesseract', screenshot, 'stdout', '--psm', '11', 'tsv'],
                          stderr=sp.DEVNULL, text=True, timeout=10)
    return [row for row in csv.DictReader(io.StringIO(raw), delimiter='\t') if row['text']]


def exercise(layout, binary, home, workspace=False):
    from urllib.request import urlopen
    url = f'http://127.0.0.1:{PORT}'
    with urlopen(url + '/health', timeout=2) as response:
        if json.load(response)['service'] != 'hermes-android-fixture':
            raise RuntimeError('unexpected fixture')
    sp.run(['gnome-keyring-daemon', '--unlock', '--components=secrets'],
           input=b'disposable-keyring', check=True, timeout=10)
    conn = dict(id=OWNER, label='Linux fixture', host='127.0.0.1', port=PORT,
                dashboard_port=PORT, single_login=True, sign_in_method='none',
                desktop_gateway_url=url)
    pref_file = home / '.local' / 'share' / APP_ID / 'shared_preferences.json'
    pref_file.parent.mkdir(parents=True)
    pref_file.write_text(json.dumps({
        'flutter.saved_connections': [json.dumps(conn)],
        'flutter.nextgen_enabled': layout == 'nextgen',
        'flutter.last_connection_id': OWNER,
        f'flutter.nextgen_last_session.{OWNER}': 'fixture-copy',
    }))
    log = home / 'app.log'
    with log.open('w') as stream:
        app = sp.Popen([binary], stdout=stream, stderr=sp.STDOUT)
        try:
            if workspace:
                from linux_workspace_ui import check_workspace
                check_workspace(layout, binary, home, app, capture)
                if 'Unhandled Exception:' in log.read_text():
                    raise RuntimeError(f'{layout}: unhandled exception in parent log')
                return True
            clicked = False
            text = ''
            deadline = time.monotonic() + 30
            while time.monotonic() < deadline:
                if app.poll() is not None:
                    raise RuntimeError(f'{layout}: app exited {app.returncode}')
                words = capture(home)
                text = ' '.join(w['text'] for w in words).lower()
                if layout == 'classic' and not clicked:
                    label = next((w for w in words if w['text'].lower() == 'verification'), None)
                    if label:
                        sp.run(['xdotool', 'mousemove', str(int(label['left']) + 3),
                                str(int(label['top']) + 4), 'click', '1'], check=True)
                        clicked = True
                events = home / 'events.jsonl'
                resumed = events.exists() and any(
                    e.get('method') == 'session.resume' and e.get('found') is True
                    and e.get('session_id') == 'fixture-copy'
                    for e in map(json.loads, events.read_text().splitlines()))
                rendered = ('deterministic message' in text if layout == 'classic'
                            else 'markdown este randat' in text)
                if resumed and rendered:
                    break
                time.sleep(.35)
            else:
                raise RuntimeError(f'{layout}: no visible and resumed fixture chat; last OCR: {text}')
            windows = sp.check_output(['xwininfo', '-root', '-tree'], text=True)
            if f'"Ares": ("{APP_ID}"' not in windows:
                raise RuntimeError('missing Ares GTK window')
            print(f'{layout}: GTK window, fixture-copy resume and visible transcript verified', flush=True)
            for line in log.read_text().splitlines():
                if 'Unhandled Exception:' in line:
                    print(f'{layout}: RUNTIME ERROR: {line}', file=sys.stderr)
                    # Keep going so the second layout is also exercised.
                    return False
            return True
        finally:
            app.terminate()
            app.wait(timeout=5)


def main(binary, workspace=False):
    failures = []
    for layout in ('classic', 'nextgen'):
        with tempfile.TemporaryDirectory(prefix='ares-linux-smoke-') as directory:
            home = Path(directory)
            runtime = home / 'run'
            runtime.mkdir(mode=0o700)
            xauth = home / '.Xauthority'
            xauth.touch(mode=0o600)
            env = dict(PATH='/usr/bin:/bin', HOME=directory, XDG_RUNTIME_DIR=str(runtime),
                       XDG_DATA_HOME=str(home / '.local/share'), LANG='C.UTF-8', LIBGL_ALWAYS_SOFTWARE='1')
            args = [sys.executable, str(Path(__file__).resolve())]
            server = sp.Popen([*args, '--serve', *(['workspace'] if workspace else [])], env=env)
            try:
                from urllib.request import urlopen
                for _ in range(40):
                    if server.poll() is not None:
                        raise RuntimeError('fixture failed to start')
                    try:
                        with urlopen(f'http://127.0.0.1:{PORT}/health', timeout=.5):
                            break
                    except OSError:
                        time.sleep(.1)
                proc = sp.run(['dbus-run-session', '--', 'xvfb-run', '-a', '-f', str(xauth), '-s',
                               '-screen 0 1680x1020x24 +extension GLX -nolisten tcp',
                               *args, '--layout', layout, str(binary),
                               *(['workspace'] if workspace else [])], env=env, timeout=150)
                if proc.returncode:
                    failures.append(layout)
            finally:
                server.terminate()
                server.wait(timeout=10)
    if failures:
        raise SystemExit('failed: ' + ', '.join(failures))


if __name__ == '__main__':
    if not sys.platform.startswith('linux') or set(os.listdir('/sys/class/net')) != {'lo'}:
        raise SystemExit('requires an isolated Linux network namespace with loopback only')
    if os.geteuid() == 0:
        raise SystemExit('run as an unprivileged fixture user')
    if sys.argv[1:2] in (['--serve'], ['--layout']) and not (
        Path.home().name.startswith('ares-linux-smoke-')
        and Path(os.environ.get('XDG_RUNTIME_DIR', '')) == Path.home() / 'run'
    ):
        raise SystemExit('internal modes require a disposable smoke home')
    if sys.argv[1:] in (['--serve'], ['--serve', 'workspace']):
        serve(Path.home(), workspace=sys.argv[-1] == 'workspace')
    elif (len(sys.argv) >= 4 and sys.argv[1] == '--layout'
          and sys.argv[2] in ('classic', 'nextgen') and sys.argv[4:] in ([], ['workspace'])):
        raise SystemExit(0 if exercise(sys.argv[2], sys.argv[3], Path.home(),
                                       workspace=sys.argv[4:] == ['workspace']) else 1)
    elif len(sys.argv) == 3 and sys.argv[1] == '--workspace' and Path(sys.argv[2]).is_file():
        main(Path(sys.argv[2]).resolve(), workspace=True)
    elif len(sys.argv) == 2 and Path(sys.argv[1]).is_file():
        main(Path(sys.argv[1]).resolve())
    else:
        raise SystemExit(f'usage: {sys.argv[0]} [--workspace] path/to/bundle/ares')
