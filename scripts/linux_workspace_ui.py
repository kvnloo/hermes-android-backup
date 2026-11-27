"""X11 workspace checks. Invoked by linux_fixture_smoke.py in its private session."""
import json
import os
from pathlib import Path
import re
import subprocess as sp
import time


APP = 'com.hermesagent.ares'


def xdo(*args):
    return sp.check_output(['xdotool', *map(str, args)], text=True, timeout=5).strip()


def windows():
    tree = sp.check_output(['xwininfo', '-root', '-tree'], text=True, timeout=5)
    ids = re.findall(r'(0x[0-9a-f]+) "Ares": \("' + re.escape(APP) + r'"', tree)
    return {int(xdo('getwindowpid', wid)): wid for wid in ids
            if 'Map State: IsViewable' in sp.check_output(
                ['xwininfo', '-id', wid], text=True, timeout=5)}


def wait_for(probe, reason, timeout=14):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if value := probe():
            return value
        time.sleep(.25)
    raise RuntimeError(reason)


def words_at(rows, phrase):
    target = phrase.casefold().split()
    tokens = [w['text'].strip('.,:;|').casefold() for w in rows]
    for i in range(len(rows) - len(target) + 1):
        if tokens[i:i + len(target)] == target:
            return rows[i]
    return None


def center(word):
    return (int(word['left']) + int(word['width']) // 2,
            int(word['top']) + int(word['height']) // 2)


def tcp_ports(proc):
    # The tables are namespace-wide. Require a socket inode actually open in
    # the child before attributing a loopback fixture event to that process.
    sockets = set()
    for fd in (proc / 'fd').iterdir():
        try:
            sockets.add(os.readlink(fd))
        except FileNotFoundError:
            pass
    tables = [proc / 'net' / name for name in ('tcp', 'tcp6')]
    return {int(fields[1].split(':')[1], 16) for table in tables if table.exists()
            for fields in map(str.split, table.read_text().splitlines()[1:])
            if fields[3] == '01' and f'socket:[{fields[9]}]' in sockets}


def check_workspace(layout, binary, home, app, capture):
    parent = wait_for(lambda: windows().get(app.pid), 'no original GTK window')
    # Include a wide NextGen sidebar and still leave room for two real panes.
    xdo('windowmove', parent, 0, 0, 'windowsize', parent, 1600, 960)
    xdo('windowfocus', parent)
    region = (0, 0, 1600, 960)
    last = []

    def screenshot():
        nonlocal last
        last = capture(home, region)
        return last

    def label(text, timeout=12):
        try:
            return wait_for(lambda: words_at(screenshot(), text), f'missing {text}', timeout)
        except RuntimeError as e:
            raise RuntimeError(f'{e}; last fixture OCR: ' + ' '.join(w['text'] for w in last)) from e

    def click(text):
        xdo('mousemove', *center(label(text)), 'click', 1)
        print(f'{layout}: clicked {text}', flush=True)
        time.sleep(.4)

    def toolbar(text, inset, expected):
        # The icon-only buttons are right-aligned with the visible app bar.
        # Confirm the resulting dialog/menu by its rendered controls; GTK does
        # not always show hover tooltips under Xvfb without a window manager.
        _, y = center(label('Parallel workspace'))
        xdo('mousemove', region[2] - inset, y, 'click', 1)
        label(expected)
        print(f'{layout}: clicked {text}; saw {expected}', flush=True)
        time.sleep(.4)

    def resumes(id):
        events = map(json.loads, (home / 'events.jsonl').read_text().splitlines())
        return [e['peer_port'] for e in events if e.get('method') == 'session.resume'
                and e.get('found') is True and e.get('session_id') == id]

    click('More')
    click('Parallel workspace')
    label('Add a chat to start a workspace')
    toolbar('Add chat', 100, 'Filter')
    label('Add chat')
    click('verification')
    transcript = 'deterministic message' if layout == 'classic' else 'Markdown este randat'
    label(transcript)
    wait_for(lambda: resumes('fixture-copy'), 'no primary resume')
    toolbar('Workspace options', 20, 'Dock another pane')
    click('Dock another pane')
    label('Dock beside current pane')
    click('Companion chat')

    def side_by_side():
        rows = screenshot()
        left = words_at(rows, transcript)
        right = words_at(rows, 'Orchid compass witness') or words_at(rows, 'Magenta lantern witness')
        if left and right and center(right)[0] - center(left)[0] > 300:
            return center(left)[0], center(right)[0]
        return None

    try:
        cols = wait_for(side_by_side, f'{layout}: both transcripts not visible side by side')
    except RuntimeError as e:
        raise RuntimeError(f'{e}; last fixture OCR: ' + ' '.join(w['text'] for w in last)) from e
    wait_for(lambda: resumes('fixture-split'), 'no split resume')
    print(f'{layout}: fixture-copy + fixture-split transcripts side by side, x={cols}; both resumed', flush=True)
    if windows() != {app.pid: parent}:
        raise RuntimeError('expected exactly one Ares GTK window before pop-out')
    toolbar('Workspace options', 20, 'Open chat in new window')
    before = len(resumes('fixture-copy'))
    click('Open chat in new window')

    def new_window():
        found = windows()
        if len(found) == 2 and found.get(app.pid) == parent:
            return next((pid, wid) for pid, wid in found.items() if pid != app.pid)
        return None

    pid, child = wait_for(new_window, 'no new Ares GTK window', timeout=48)
    proc = Path('/proc') / str(pid)
    status = (proc / 'status').read_text()
    argv = (proc / 'cmdline').read_bytes().split(b'\0')
    if not (re.search(rf'^PPid:\s+{app.pid}$', status, re.MULTILINE)
            and (proc / 'exe').resolve() == Path(binary).resolve()
            and argv[1:] == [b'--ares-workspace-chat-v1', b'']):
        raise RuntimeError('new window is not the expected child of the original process')
    wait_for(lambda: set(resumes('fixture-copy')[before:]) & tcp_ports(proc),
             'no fresh fixture-copy resume on a socket owned by the child')
    # Eliminate the parent as a possible pixel source for child transcript OCR.
    xdo('windowunmap', parent, 'windowmove', child, 0, 0, 'windowraise', child)
    geom = dict(line.split('=', 1) for line in xdo('getwindowgeometry', '--shell', child).splitlines())
    region = tuple(int(geom[k]) for k in ('X', 'Y', 'WIDTH', 'HEIGHT'))
    label(transcript)
    print(f'{layout}: GTK parent={parent}/pid={app.pid}, child={child}/pid={pid}, '
          f'same extracted ELF; child-only OCR + fixture-copy resume on child-owned socket', flush=True)
    # The real parent owns the child's stdin. Its exit must retire the child.
    app.terminate()
    app.wait(timeout=5)
    wait_for(lambda: not windows() and (not proc.exists() or '\nState:\tZ' in (proc / 'status').read_text()),
             'child outlived its parent')
    print(f'{layout}: parent termination retired child; zero Ares windows', flush=True)
