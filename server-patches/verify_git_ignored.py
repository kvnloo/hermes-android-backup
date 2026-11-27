"""Replay 0003 alone/after 0002; test the patched router in process, without a listener.

Run: python server-patches/verify_git_ignored.py [--python /existing/venv/bin/python]
Use an interpreter with Hermes' dashboard dependencies. No installs or real profiles.
"""
import argparse
import asyncio
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tarfile
import tempfile
from unittest.mock import patch

PIN = 'b7ee21c14e38316273f88d8ed112491ba1c87d15'
HERE = Path(__file__).resolve().parent
PATCH = HERE / '0003-list-git-ignored.patch'


def replay():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--upstream', type=Path, default=Path.home() / '.hermes/hermes-agent')
    parser.add_argument('--python', default=sys.executable, help='Existing dashboard Python (3.11+)')
    args = parser.parse_args()
    git = shutil.which('git')
    if not git:
        raise RuntimeError('git is required')
    scratch = HERE / '.dart_tool'
    scratch.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(dir=scratch, prefix='git-flags-') as tmp:
        fixture = Path(tmp).resolve()
        source, home = fixture / 'source', fixture / 'home'
        for directory in (source, home / '.hermes', fixture / 'tmp'):
            directory.mkdir(parents=True)
        env = {'HOME': str(home), 'HERMES_HOME': str(home / '.hermes'), 'TMPDIR': str(fixture / 'tmp'),
               'XDG_CONFIG_HOME': str(home / 'config'), 'XDG_CACHE_HOME': str(home / 'cache'),
               'PATH': os.environ['PATH'], 'TERM': 'dumb', 'GIT_CONFIG_NOSYSTEM': '1',
               'GIT_CONFIG_GLOBAL': os.devnull, 'GIT_CONFIG_SYSTEM': os.devnull,
               'GIT_CEILING_DIRECTORIES': str(fixture), 'GIT_ALLOW_PROTOCOL': ''}
        archive = fixture / 'pinned.tar'
        with archive.open('wb') as out:
            subprocess.run([git, '-C', str(args.upstream.absolute()), 'archive', PIN, '--', '*.py', '*.yaml',
                            'pyproject.toml', ':!tests', ':!apps', ':!plugins', ':!optional-*', ':!skills',
                            ':!website'], stdout=out, env=env, check=True, timeout=60)
        with tarfile.open(archive) as tar:
            # Only regular files are needed; never extract links into the fixture.
            for member in tar:
                if member.isfile() and (source / member.name).resolve().is_relative_to(source):
                    target = source / member.name
                    target.parent.mkdir(parents=True, exist_ok=True)
                    content = tar.extractfile(member)
                    assert content is not None
                    with content, target.open('wb') as out:
                        shutil.copyfileobj(content, out)
        for command in (['init', '-q'], ['apply', '--check', str(PATCH)],
                        ['apply', '--whitespace=error', str(HERE / '0002-confirmed-text-v1.patch')],
                        ['apply', '--check', str(PATCH)], ['apply', '--whitespace=error', str(PATCH)]):
            subprocess.run([git, *command], cwd=source, env=env, check=True, timeout=15)
        # -S: no editable-install .pth that could import a live checkout. Add only the
        # interpreter's dependency directories, AFTER the pinned archive.
        boot = ('import site,sys,pathlib,runpy; sys.path.insert(0,str(pathlib.Path.cwd())); '
                'sys.path.extend(site.getsitepackages([str(pathlib.Path(sys.executable).parent.parent)])); '
                'runpy.run_path(sys.argv[1])["verify"]()')
        subprocess.run([args.python, '-ISB', '-c', boot, str(Path(__file__).resolve())],
                       cwd=source, env=env, check=True, timeout=90)
    print('PASS: 0003 applies to ' + PIN + ' alone and after 0002; handler verification passed.')


def verify():
    from fastapi import FastAPI
    import httpx
    from hermes_cli import _subprocess_compat as compat
    from hermes_cli.web_routers import files

    source = Path.cwd()
    fixture = source.parent
    assert fixture.parent == HERE / '.dart_tool' and Path.home() == fixture / 'home'
    assert all(m.__file__ and Path(m.__file__).resolve().is_relative_to(source) for m in (files, compat))
    assert Path(os.environ['HERMES_HOME']) == Path.home() / '.hermes'
    app = FastAPI()
    app.include_router(files.router)

    async def get(directory, flags=None, status=200):
        params = {'path': str(directory)}
        if flags is not None:
            params['git_flags'] = flags
        async with httpx.AsyncClient(transport=httpx.ASGITransport(app), base_url='http://fixture') as client:
            response = await client.get('/api/fs/list', params=params)
        assert response.status_code == status, (directory, response.status_code, response.text)
        return response.json()

    def listing(directory, flags=None, status=200):
        return asyncio.run(get(directory, flags, status))

    repo = fixture / 'repo'
    nested = repo / 'nested'
    nested.mkdir(parents=True)
    subprocess.run(['git', 'init', '-q'], cwd=repo, check=True)
    (repo / '.gitignore').write_text('*.log\n!keep.log\nignored-dir/\n')
    (repo / '.git' / 'info' / 'exclude').write_text('repo-local-only\n')
    (nested / '.gitignore').write_text('*.tmp\n!keep.tmp\n')
    expected = {'.gitignore': False, 'ignored-dir': True, 'tracked.log': False, 'keep.log': False,
                'a.log': True, 'a.tmp': True, 'keep.tmp': False, 'ordinary': False, '-q.log': True,
                ':!thing.log': True, 'two words.log': True, 'line\nbreak.log': True,
                'return\rname.log': True, 'tab\tname.log': True, '雪.log': True, 'repo-local-only': True,
                't*.log': None, 'tracke?.log': None, 'tracke[d].log': None, 'a\\b.log': None}
    (nested / 'ignored-dir').mkdir()
    for name in expected.keys() - {'.gitignore', 'ignored-dir'}:
        (nested / name).touch()
    # Include the 0002 recovery inode as well as upstream's hidden/sensitive basenames.
    for name in ('.env', 'auth.json', '.ares-replace-v1-private', 'node_modules'):
        (nested / name).touch()
    (nested / 'alias').symlink_to(Path.home() / '.ssh' / 'private')
    subprocess.run(['git', 'add', '-f', '--', 'tracked.log'], cwd=nested, check=True)
    index = repo / '.git' / 'index'
    old_index = index.read_bytes()

    # Fail the test on a network connection or an unexpected shell/SSH/other process.
    def guard(event, args):
        if event in ('socket.connect', 'socket.bind', 'os.system', 'os.posix_spawn'):
            raise AssertionError(event)
        if event == 'subprocess.Popen':
            cmd = args[1]
            if cmd[0] != 'git' or not any(k in cmd for k in ('config', 'check-ignore')):
                raise AssertionError(('unexpected process', cmd))
    sys.addaudithook(guard)

    # Only the local config inputs are supplied; even backend selection is upstream.
    with patch.object(files, 'load_config', return_value={'terminal': {'backend': 'local'}}), patch.object(
            files, 'load_env', return_value={}):
        with patch.object(files, '_fs_mark_git_ignored', side_effect=AssertionError('unexpected Git probe')):
            legacy = listing(nested)
            assert legacy == listing(nested, 'false')
        assert {e['name'] for e in legacy['entries']} == expected.keys(), legacy
        assert all(set(e) == {'name', 'isDirectory', 'path'} for e in legacy['entries'])
        with patch.object(subprocess, 'run', wraps=subprocess.run) as ran:
            flagged = listing(nested, 'true')
        check, = [c for c in ran.call_args_list if 'check-ignore' in c.args[0]]
        assert check.kwargs['cwd'] == nested and not check.kwargs.get('shell') and 0 < check.kwargs['timeout'] <= 2
        admitted = {os.fsencode('./' + n) for n, v in expected.items() if v is not None}
        assert set(check.kwargs['input'].split(b'\0')) == {b'', *admitted}
        env = check.kwargs['env']
        assert env['GIT_CONFIG_NOSYSTEM'] == '1' and env['GIT_OPTIONAL_LOCKS'] == '0'
        assert [{k: v for k, v in row.items() if k != 'gitIgnored'} for row in flagged['entries']] == legacy['entries']
        for row in flagged['entries']:
            want = expected[row['name']]
            assert (row['gitIgnored'] is want if want is not None else 'gitIgnored' not in row), row
        assert index.read_bytes() == old_index and not index.with_suffix('.lock').exists()

        plain = repo / 'plain'
        plain.mkdir()
        assert listing(plain, 'true') == {'entries': []}
        (plain / 'only').touch()
        assert listing(plain, 'true')['entries'][0]['gitIgnored'] is False  # check-ignore rc=1
        nonrepo = fixture / 'nonrepo'
        nonrepo.mkdir()
        (nonrepo / 'x').touch()
        assert listing(nonrepo, 'true') == listing(nonrepo)
        assert listing(nonrepo / 'x', 'true') == {'entries': [], 'error': 'ENOTDIR'}
        with patch.dict(os.environ, {'HERMES_DASHBOARD_FILES_ROOT': str(repo)}), patch.object(
                files, '_fs_mark_git_ignored', side_effect=AssertionError('locked-root Git probe')):
            assert listing(nested, 'true') == legacy
            listing(nonrepo, 'true', 403)
        with patch.object(compat, 'noninteractive_repo_git_env', return_value=None):
            assert listing(nested, 'true') == legacy
        with patch.dict(os.environ, {'PATH': str(fixture / 'no-git')}):
            assert listing(nested, 'true') == legacy
        real_run = subprocess.run

        def timeout_check(cmd, **kwargs):
            if 'check-ignore' in cmd:
                raise subprocess.TimeoutExpired(cmd, kwargs['timeout'])
            return real_run(cmd, **kwargs)

        with patch.object(subprocess, 'run', side_effect=timeout_check):
            assert listing(nested, 'true') == legacy
        index.write_bytes(b'bad fixture index')
        assert listing(nested, 'true') == legacy
        index.write_bytes(old_index)
        # No Git process at all for empty or over-budget admitted listings.
        with patch.object(compat, 'noninteractive_repo_git_env', side_effect=AssertionError('over-budget Git')):
            many = repo / 'many'
            many.mkdir()
            for i in range(513):
                (many / str(i)).touch()
            assert listing(many, 'true') == listing(many)
            for item in many.iterdir():
                item.unlink()
            assert listing(many, 'true') == {'entries': []}
            for i in range(180):
                (many / (str(i) + 'x' * 200)).touch()
            assert listing(many, 'true') == listing(many)

    class SshFixture:
        def list_dir(self, path, hidden):
            assert path == '/on-ssh' and hidden == files._FS_READDIR_HIDDEN
            return {'entries': [{'name': name, 'path': path + '/' + name, 'isDirectory': False}
                                for name in ('remote.log', '.env')], 'remote': True}

    with patch.object(files, '_fs_backend', return_value=SshFixture()), patch.object(
            files, '_fs_mark_git_ignored', side_effect=AssertionError('SSH Git probe')):
        assert listing('/on-ssh', 'true') == listing('/on-ssh') == {'entries': [
            {'name': 'remote.log', 'path': '/on-ssh/remote.log', 'isDirectory': False}], 'remote': True}


if __name__ == '__main__':
    replay()
