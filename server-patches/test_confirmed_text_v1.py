"""Run via verify_confirmed_text_v1.py. No listener, live profile, installer or shell."""
import asyncio
from concurrent.futures import ThreadPoolExecutor
from contextlib import ExitStack
from dataclasses import asdict
import hashlib
import json
import os
from pathlib import Path
import stat
import tempfile
import threading
import unittest
from unittest.mock import patch
from uuid import uuid4

if 'ARES_CONFIRMED_EDIT_FIXTURE' not in os.environ:
    raise unittest.SkipTest('Use verify_confirmed_text_v1.py; never use a live profile')
FIXTURE = Path(os.environ['ARES_CONFIRMED_EDIT_FIXTURE']).resolve(strict=True)
HOME = Path(os.environ['HERMES_HOME']).resolve(strict=True)
assert (FIXTURE / '.disposable').is_file() and HOME.is_relative_to(FIXTURE)
assert Path(tempfile.gettempdir()).resolve().is_relative_to(FIXTURE)

from fastapi import HTTPException
from starlette.requests import Request
import hermes_cli.confirmed_text as edit
import hermes_cli.web_confirmed_text as endpoint
from hermes_cli.sqlite_safe_read import connect_tracked
from hermes_cli.web_routers import files
from persistence_assembly import open_persistence, profile_scope
from persistence.authority.bindings import NewSessionBinding, local_session_id
from gateway.session_policy import build_policy

assert Path(files.__file__).resolve().is_relative_to(FIXTURE / 'source')
assert Path(edit.__file__).resolve().is_relative_to(FIXTURE / 'source')


def hashed(data):
    return hashlib.sha256(data).hexdigest()


def stored(cwd, *, backend='local', tools=('file',), source='gui'):
    request_id = uuid4().hex
    principal = 'test-owner'
    sid = local_session_id(str(HOME), principal, request_id)
    hp = asdict(build_policy({'source': source, 'cwd': str(cwd), 'toolsets': list(tools)},
                             {'terminal': {'backend': 'local'}}))
    hp['terminal_json'] = json.dumps({**json.loads(hp['terminal_json']), 'TERMINAL_ENV': backend})
    route = 'test:' + request_id
    stamp = '2026-01-01T00:00:00+00:00'
    with open_persistence(profile_scope(home=HOME)) as store:
        epoch = store.runtime.begin_epoch(instance_id='fixture')
        store.bindings.reserve(epoch=epoch, owner=None, binding=NewSessionBinding(
            profile_id=str(HOME), principal_id=principal, request_id=request_id, session_id=sid,
            route=route, entry={'session_key': route, 'session_id': sid, 'created_at': stamp,
                                'updated_at': stamp, 'origin': {'chat_id': sid, 'chat_type': 'dm',
                                                               'user_id': principal, 'platform': 'local'}},
            policy=hp, created_source=hp['platform']))
    return sid


def req(data, query=b'profile=default', *, auth=True):
    sent = False
    async def receive():
        nonlocal sent
        assert not sent
        sent = True
        return {'type': 'http.request', 'body': data, 'more_body': False}
    return Request({'type': 'http', 'method': 'POST', 'path': '/api/fs/replace-text-v1',
                    'query_string': query, 'headers': [(b'content-type', b'application/json')],
                    'state': {'native_http_principal': auth}}, receive)


def fake_auth(request):
    # Test boundary only. Do not load/launch the full dashboard app or mint a real ticket.
    if not request.state.native_http_principal:
        raise HTTPException(401)


class ConfirmedEdit(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        # Run all native positives; do not turn an incompatible host into a silent skip.
        edit.Darwin()

    def setUp(self):
        self.owned = ExitStack()
        self.addCleanup(self.owned.close)
        self.cwd = Path(self.owned.enter_context(tempfile.TemporaryDirectory())).resolve()
        self.path = self.cwd / 'notes.txt'
        self.base = 'opened\r\n☃\n'.encode()
        self.new = 'changed\r\n☕\n'
        self.path.write_bytes(self.base)
        self.path.chmod(0o640)
        self.sid = stored(self.cwd)
        self.owned.enter_context(patch.object(files, '_require_token', fake_auth))

    def payload(self, **overrides):
        return {'path': str(self.path), 'cwd': str(self.cwd), 'session_id': self.sid,
                'content': self.new, 'expected_sha256': hashed(self.base), **overrides}

    def post(self, **overrides):
        request = req(json.dumps(self.payload(**overrides)).encode())
        return asyncio.run(files.fs_replace_text_v1(request, 'default'))

    def rejects(self, codes, fn):
        with self.assertRaises(HTTPException) as caught:
            fn()
        self.assertIn(caught.exception.status_code, codes)

    def recovery(self):
        return list(self.cwd.glob(edit.PREFIX + '*/original'))

    def test_upstream_read_then_real_handler(self):
        # The upstream read handler is unchanged; source bytes are the UTF-8 client baseline.
        opened = asyncio.run(files.fs_read_text(str(self.path), profile='default', session_id=self.sid))
        self.assertFalse(opened['truncated'] or opened['binary'])
        self.assertEqual(opened['path'], str(self.path))
        receipt = self.post(expected_sha256=hashed(opened['text'].encode()))
        self.assertEqual(receipt, {'ok': True, 'path': str(self.path), 'sha256': hashed(self.new.encode())})
        self.assertEqual(self.path.read_bytes(), self.new.encode())
        self.assertEqual(stat.S_IMODE(self.path.stat().st_mode), 0o640)
        old, = self.recovery()
        self.assertEqual(old.read_bytes(), self.base)
        self.assertTrue(files._is_sensitive_path(old))
        self.assertEqual((old.parent / '.gitignore').read_bytes(), b'*\n')
        self.assertEqual((old.parent / 'target').read_bytes(), b'notes.txt')
        self.assertEqual(stat.S_IMODE(old.parent.stat().st_mode), 0o700)

    def test_stale_or_deleted_never_creates(self):
        self.path.write_bytes(b'external')
        self.rejects({409}, self.post)
        self.assertEqual(self.path.read_bytes(), b'external')
        self.assertEqual(sorted(self.cwd.iterdir()), [self.path])
        self.path.unlink()
        self.rejects({409}, self.post)
        self.assertFalse(self.path.exists())

    def test_session_row_changes_in_custody_restores_without_publishing(self):
        read = edit.read_original
        def drift(fd, limit):
            data = read(fd, limit)
            with open_persistence(profile_scope(home=HOME)) as store:
                store.sessions.update_cwd(self.sid, str(self.cwd.parent))
            return data
        with patch.object(edit, 'read_original', drift):
            self.rejects({409}, self.post)
        self.assertEqual(sorted(self.cwd.iterdir()), [self.path])
        self.assertEqual(self.path.read_bytes(), self.base)

    def test_writer_during_publish_is_preserved_and_not_acknowledged(self):
        move = edit.Darwin.move
        with self.path.open('ab', buffering=0) as held:
            def write_old(native, srcfd, src, dstfd, dst):
                if Path(src).name == 'new':
                    held.write(b'last-moment external bytes')
                move(native, srcfd, src, dstfd, dst)
            with patch.object(edit.Darwin, 'move', write_old):
                self.rejects({409}, self.post)
        self.assertEqual(self.path.read_bytes(), self.new.encode())
        old, = self.recovery()
        self.assertEqual(old.read_bytes(), self.base + b'last-moment external bytes')

    def test_native_query_profile_gate_still_applies_before_bounded_parser(self):
        from hermes_cli.dashboard_auth.native_http import _check_profile_scope
        request = req(json.dumps(self.payload(profile='untrusted')).encode())
        asyncio.run(_check_profile_scope(request, str(HOME)))
        self.assertFalse(hasattr(request, '_body'))
        self.rejects({400}, lambda: asyncio.run(files.fs_replace_text_v1(request, 'default')))
        with self.assertRaises(PermissionError):
            asyncio.run(_check_profile_scope(req(b'{}'), str(HOME / 'other')))
        self.assertEqual(self.path.read_bytes(), self.base)

    def test_leaf_replaced_at_claim_restores_the_displaced_external_inode(self):
        pending = self.cwd / 'pending.txt'
        pending.write_bytes(b'external replacement')
        expected_inode = pending.stat().st_ino
        move = edit.Darwin.move
        def replace_at_claim(native, srcfd, src, dstfd, dst):
            if Path(dst).name == 'original':
                pending.replace(self.path)  # independent editor, never the backend publisher
            move(native, srcfd, src, dstfd, dst)
        with patch.object(edit.Darwin, 'move', replace_at_claim):
            self.rejects({409}, self.post)
        self.assertEqual(self.path.read_bytes(), b'external replacement')
        self.assertEqual(self.path.stat().st_ino, expected_inode)
        self.assertEqual(self.recovery(), [])

    def test_xattrs_and_nonprivate_workspace_refused(self):
        import ctypes as c
        with self.path.open('rb') as opened:
            setter = c.CDLL(None, use_errno=True).fsetxattr
            setter.argtypes = [c.c_int, c.c_char_p, c.c_char_p, c.c_size_t, c.c_uint32, c.c_int]
            self.assertEqual(setter(opened.fileno(), b'com.ares.test', b'v', 1, 0, 0), 0)
        self.rejects({403}, self.post)
        self.assertEqual(self.path.read_bytes(), self.base)
        self.cwd.chmod(0o755)
        self.rejects({403}, self.post)
        self.assertEqual(sorted(self.cwd.iterdir()), [self.path])

    def test_racing_external_replacement_wins_and_old_fd_survives(self):
        before, resume = threading.Event(), threading.Event()
        move = edit.Darwin.move
        def pause(native, srcfd, src, dstfd, dst):
            if Path(src).name == 'new':
                before.set()
                self.assertTrue(resume.wait(8))
            move(native, srcfd, src, dstfd, dst)
        with self.path.open('ab', buffering=0) as held, patch.object(edit.Darwin, 'move', pause):
            with ThreadPoolExecutor(max_workers=1) as pool:
                flight = pool.submit(self.post)
                try:
                    self.assertTrue(before.wait(8))
                    self.path.write_bytes(b'new external inode')
                finally:
                    resume.set()
                self.rejects({409}, flight.result)
            held.write(b' late write')
        self.assertEqual(self.path.read_bytes(), b'new external inode')
        old, = self.recovery()
        self.assertEqual(old.read_bytes(), self.base + b' late write')

    def test_external_open_fd_after_success_has_named_recovery(self):
        with self.path.open('ab', buffering=0) as held:
            self.post()
            held.write(b'held-writer')
        old, = self.recovery()
        self.assertEqual(old.read_bytes(), self.base + b'held-writer')
        self.assertEqual(self.path.read_bytes(), self.new.encode())

    def test_external_in_place_write_before_publication_is_not_lost(self):
        authorize = endpoint._task_local
        calls = 0
        with self.path.open('ab', buffering=0) as held:
            def drift(*args):
                nonlocal calls
                authorize(*args)
                calls += 1
                if calls == 2:
                    held.write(b'other')
            with patch.object(endpoint, '_task_local', drift):
                self.rejects({409}, self.post)
        self.assertEqual(self.path.read_bytes(), self.base + b'other')
        self.assertEqual(sorted(self.cwd.iterdir()), [self.path])

    def test_symlink_before_or_during_publish_does_not_redirect(self):
        neighbor = self.cwd / 'other.txt'
        neighbor.write_bytes(b'outside bytes')
        move = edit.Darwin.move
        def redirect(native, srcfd, src, dstfd, dst):
            if Path(src).name == 'new':
                self.path.symlink_to(neighbor)
            move(native, srcfd, src, dstfd, dst)
        with patch.object(edit.Darwin, 'move', redirect):
            self.rejects({409}, self.post)
        self.assertTrue(self.path.is_symlink())
        self.assertEqual(neighbor.read_bytes(), b'outside bytes')
        self.assertEqual(self.recovery()[0].read_bytes(), self.base)
        self.rejects({403}, self.post)

    def test_cwd_replaced_by_real_directory_during_publish(self):
        parent, moved = self.cwd, self.cwd.with_name(self.cwd.name + '-moved')
        move = edit.Darwin.move
        def redirect(native, srcfd, src, dstfd, dst):
            if Path(src).name == 'new':
                parent.rename(moved)
                parent.mkdir(mode=0o700)
            move(native, srcfd, src, dstfd, dst)
        try:
            with patch.object(edit.Darwin, 'move', redirect):
                self.rejects({409}, self.post)
            self.assertFalse((moved / 'notes.txt').exists())
            self.assertEqual(list(parent.iterdir()), [])
            original, = moved.glob(edit.PREFIX + '*/original')
            self.assertEqual(original.read_bytes(), self.base)
        finally:
            if moved.exists():
                parent.rmdir()
                moved.rename(parent)

    def test_nested_parent_and_case_alias_refused_without_mutation(self):
        actual = self.cwd / 'sub'
        actual.mkdir(mode=0o700)
        child = actual / self.path.name
        child.write_bytes(self.base)
        self.rejects({403}, lambda: self.post(path=str(child)))
        self.assertEqual(child.read_bytes(), self.base)
        self.rejects({403, 409}, lambda: self.post(path=str(self.cwd / 'NOTES.txt')))
        self.assertEqual(self.path.read_bytes(), self.base)
        self.assertEqual(self.recovery(), [])

    def test_wire_identity_and_policy_refusals(self):
        for fields, codes in [({'session_id': self.sid[:-1]}, {409}), ({'cwd': str(self.cwd.parent)}, {409}),
                              ({'path': str(self.cwd.parent / 'x')}, {403}),
                              ({'path': str(self.cwd) + '/./notes.txt'}, {400}),
                              ({'expected_sha256': hashed(self.base).upper()}, {400}),
                              ({'profile': 'other'}, {400}), ({'content': '\ud800'}, {400}),
                              ({'content': 'a\0b'}, {415}), ({'content': 'a' * (524288 + 1)}, {413})]:
            with self.subTest(fields=list(fields)):
                self.rejects(codes, lambda: self.post(**fields))
        self.assertEqual(self.path.read_bytes(), self.base)
        for backend in ('ssh', 'docker', 'unknown'):
            remote = stored(self.cwd, backend=backend)
            self.rejects({403}, lambda: self.post(session_id=remote))
        with patch.dict(os.environ, {'TERMINAL_ENV': 'ssh'}):
            self.rejects({403}, self.post)
        from tools.terminal_tool import register_task_env_overrides, clear_task_env_overrides
        register_task_env_overrides(self.sid, {'env_type': 'docker'})
        try:
            self.rejects({403}, self.post)
        finally:
            clear_task_env_overrides(self.sid)
        self.rejects({403}, lambda: self.post(session_id=stored(self.cwd, tools=('terminal',))))
        self.rejects({403}, lambda: self.post(session_id=stored(self.cwd, source='acp')))
        self.assertEqual(sorted(self.cwd.iterdir()), [self.path])

    def test_locked_root_sensitive_approval_safe_root_and_live_db(self):
        for key in ('HERMES_WRITE_SAFE_ROOT', 'HERMES_DASHBOARD_FILES_ROOT'):
            with patch.dict(os.environ, {key: str(self.cwd / 'elsewhere')}):
                self.rejects({403}, self.post)
        with patch('agent.file_safety.is_write_approval_required', return_value=True):
            self.rejects({403}, self.post)
        credential = self.cwd / 'config.yaml'
        credential.write_bytes(self.base)
        self.rejects({403}, lambda: self.post(path=str(credential)))
        self.assertEqual(credential.read_bytes(), self.base)
        conn = connect_tracked(self.path)
        try:
            self.rejects({409}, self.post)
        finally:
            conn.close()
        self.assertEqual(self.path.read_bytes(), self.base)

    def test_nontext_hardlink_fifo_metadata_and_mode(self):
        self.path.write_bytes(b'\xff')
        self.rejects({415}, lambda: self.post(expected_sha256=hashed(b'\xff')))
        self.assertEqual(self.path.read_bytes(), b'\xff')
        self.path.write_bytes(self.base)
        other = self.cwd / 'alias'
        os.link(self.path, other)
        self.rejects({403}, self.post)
        other.unlink()
        os.mkfifo(other)
        self.rejects({403}, lambda: self.post(path=str(other)))
        self.path.chmod(0o400)
        self.rejects({403}, self.post)
        self.path.chmod(0o640)
        self.path.write_bytes(b'a' * (524288 + 1))
        self.rejects({413}, self.post)

    def test_route_auth_and_versioned_method_contract(self):
        import httpx
        from fastapi import FastAPI
        async def check_http():
            app = FastAPI()
            app.include_router(files.router)
            async with httpx.AsyncClient(transport=httpx.ASGITransport(app=app),
                                         base_url='http://fixture.invalid', follow_redirects=False) as client:
                method = await client.get('/api/fs/replace-text-v1?profile=default')
                self.assertEqual(method.status_code, 405)
                slash = await client.post('/api/fs/replace-text-v1/?profile=default')
                self.assertEqual(slash.status_code, 404)
                self.assertNotIn('location', slash.headers)
        asyncio.run(check_http())
        paths = [(r.path, r.methods) for r in files.router.routes]
        self.assertIn(('/api/fs/replace-text-v1', {'POST'}), paths)
        self.assertIn(('/api/fs/read-text', {'GET'}), paths)
        self.rejects({401}, lambda: asyncio.run(files.fs_replace_text_v1(req(b'', auth=False), 'default')))
        for query, p in [(b'profile=current', 'current'), (b'', ''), (b'profile=default&profile=default', 'default')]:
            self.rejects({400}, lambda: asyncio.run(files.fs_replace_text_v1(req(b'', query), p)))
        self.rejects({413}, lambda: asyncio.run(files.fs_replace_text_v1(req(b'a' * (6 * 524288 + 16385)), 'default')))
        with patch.object(edit.sys, 'platform', 'unsupported'):
            self.rejects({501}, self.post)
        self.assertEqual(self.path.read_bytes(), self.base)


if __name__ == '__main__':
    unittest.main(verbosity=2)
