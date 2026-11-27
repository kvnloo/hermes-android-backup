#!/usr/bin/env python3
"""Synthetic, plugin-free Mac gate: two actual Cocoa windows, no app install.

Requires the pinned Flutter SDK (pub get first), Xcode CLI tools and a logged-in
WindowServer. All binaries, synthetic data and run logs go under TMPDIR.
"""
import json
import os
from pathlib import Path
import plistlib
import shutil
import subprocess as sp
import tempfile
import threading
import time
from typing import cast
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SESSION = '/api/sessions/fixture-s'


class Server(ThreadingHTTPServer):
    reads: list[str]
    visible: threading.Event


class Fixture(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass

    def reply(self, obj, status=200):
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(json.dumps(obj).encode())

    def do_GET(self):
        path = self.path.split('?')[0]
        cast(Server, self.server).reads.append(path)
        row = {'id': 'fixture-s', 'title': 'Fixture chat', 'source': 'desktop',
               'message_count': 1}
        history = [{'id': 1, 'role': 'user', 'content': 'isolated-only rendered history',
                    'timestamp': 1700000000}]
        self.reply({'session': row} if path == SESSION else
                   {'messages': history, 'data': history} if path == SESSION + '/messages' else {})

    def do_POST(self):
        if self.path.startswith('/visible/'):
            cast(Server, self.server).visible.set()
            self.reply({})
        else:
            # This gate verifies historical chat windows, not gateway WS capabilities.
            self.reply({}, status=404)


def build(work):
    bundle = work / 'Run.app/Contents'
    binary = bundle / 'MacOS/Fixture'
    binary.parent.mkdir(parents=True)
    (bundle / 'Info.plist').write_bytes(plistlib.dumps({
        'CFBundleIdentifier': 'test.ares.workspace.fixture', 'CFBundleExecutable': 'Fixture',
        'CFBundleName': 'Ares Window Fixture', 'CFBundlePackageType': 'APPL',
        'CFBundleVersion': '1', 'NSPrincipalClass': 'NSApplication'}))
    executable = shutil.which('flutter')
    if not executable:
        raise RuntimeError('Flutter SDK not on PATH')
    flutter = Path(executable).resolve()
    framework = next((flutter.parents[1] / 'bin/cache/artifacts/engine/darwin-x64/FlutterMacOS.xcframework').glob('macos-*'))
    sp.run([flutter, 'build', 'bundle', '--no-pub', '--target-platform=darwin',
            '--asset-dir=' + str(bundle / 'Resources/flutter_assets'),
            '--depfile=' + str(work / 'kernel.d'), '-t', str(HERE / 'fixture.dart')],
           cwd=ROOT, check=True, timeout=180)
    sp.run(['xcrun', 'swiftc', '-F', framework, '-framework', 'FlutterMacOS',
            '-Xlinker', '-rpath', '-Xlinker', framework, HERE / 'main.swift',
            ROOT / 'macos/Runner/MainFlutterWindow.swift', '-o', binary], check=True, timeout=90)
    sp.run(['xcrun', 'swiftc', HERE / 'windows.swift', '-o', work / 'list-windows'],
           check=True, timeout=90)
    return binary


def exercise(work, binary, ng):
    server = Server(('127.0.0.1', 0), Fixture)
    server.reads = []
    server.visible = threading.Event()
    threading.Thread(target=server.serve_forever, daemon=True).start()
    scratch = Path(tempfile.mkdtemp(dir=work))
    env = dict(os.environ, TMPDIR=str(scratch) + '/', ARES_FIXTURE_PORT=str(server.server_port),
               ARES_FIXTURE_NEXTGEN=str(int(ng)))
    log = scratch / 'owner.log'
    with log.open('wb') as output:
        parent = sp.Popen([binary], env=env, stdin=sp.PIPE, stdout=output, stderr=output)
        assert parent.stdin is not None
        try:
            deadline = time.monotonic() + 50
            while time.monotonic() < deadline and parent.poll() is None:
                if server.visible.wait(.1) and 'LAUNCH_RETURNED' in log.read_text(errors='replace'):
                    break
            else:
                raise RuntimeError(f'Exact transcript not rendered; fixture reads: {server.reads}')
            children = sp.check_output(['pgrep', '-P', str(parent.pid), '-x', 'Fixture'],
                                       text=True).splitlines()
            assert len(children) == 1, children
            child = children[0]
            windows = sp.check_output([work / 'list-windows', str(parent.pid), child], text=True)
            assert child + ' ' in windows and str(parent.pid) + ' ' in windows, windows
            assert SESSION in server.reads and SESSION + '/messages' in server.reads, server.reads
            parent.stdin.write(b'X')
            parent.stdin.flush()
            deadline = time.monotonic() + 8
            while time.monotonic() < deadline and sp.call(['kill', '-0', child], stderr=sp.DEVNULL) == 0:
                time.sleep(.05)
            assert sp.call(['kill', '-0', child], stderr=sp.DEVNULL) != 0 and parent.poll() is None
            print(('NextGen' if ng else 'Classic') + ': two OS windows, exact chat/transcript, '
                  'same-ID revocation closed only the child: PASS', flush=True)
        finally:
            parent.stdin.close()
            parent.terminate()
            parent.wait(10)
            server.shutdown()
            server.server_close()


if __name__ == '__main__':
    with tempfile.TemporaryDirectory(prefix='ares-popout-test-') as scratch:
        work = Path(scratch)
        binary = build(work)
        for next_gen in [False, True]:
            exercise(work, binary, next_gen)
