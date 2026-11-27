"""Replay patch + unit tests from a pinned, disposable archive. Never writes upstream."""
import argparse
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

PIN = 'b7ee21c14e38316273f88d8ed112491ba1c87d15'
HERE = Path(__file__).resolve().parent


def run():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--upstream', type=Path, default=Path.home() / '.hermes/hermes-agent')
    parser.add_argument('--python', type=Path, help='Existing interpreter with pinned Hermes dependencies')
    args = parser.parse_args()
    upstream = args.upstream.resolve(strict=True)
    py = str(args.python.absolute() if args.python else upstream / 'venv/bin/python')
    git = shutil.which('git')
    if git is None:
        raise RuntimeError('git is required')
    if subprocess.check_output([git, '-C', str(upstream), 'rev-parse', '--verify', PIN + '^{commit}'],
                               text=True).strip() != PIN:
        raise RuntimeError('pinned source unavailable')
    base = HERE / '.dart_tool'
    base.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='replay-', dir=base) as tmp:
        fixture = Path(tmp).resolve()
        source, home, scratch = fixture / 'source', fixture / 'home', fixture / 'tmp'
        for directory in (source, home / '.hermes', scratch):
            directory.mkdir(parents=True, mode=0o700)
        (fixture / '.disposable').touch()
        env = {'HOME': str(home), 'HERMES_HOME': str(home / '.hermes'), 'TMPDIR': str(scratch),
               'PATH': os.environ['PATH'], 'TERM': 'dumb', 'PYTHONDONTWRITEBYTECODE': '1',
               'XDG_CACHE_HOME': str(home / 'cache'), 'XDG_CONFIG_HOME': str(home / 'config'),
               'ARES_CONFIRMED_EDIT_FIXTURE': str(fixture), 'GIT_CONFIG_NOSYSTEM': '1'}
        archive = fixture / 'source.tar'
        with archive.open('wb') as out:
            subprocess.run([git, '-C', str(upstream), 'archive', PIN, '--', '*.py', '*.yaml', 'pyproject.toml',
                            'LICENSE', ':!tests', ':!apps', ':!plugins', ':!optional-*', ':!skills', ':!website'],
                           stdout=out, check=True, env=env)
        subprocess.run(['tar', '-xf', str(archive), '-C', str(source)], check=True, env=env)
        patch_file = HERE / '0002-confirmed-text-v1.patch'
        for command in (['init', '-q'], ['apply', '--check', '--verbose', str(patch_file)],
                        ['apply', '--whitespace=error', str(patch_file)]):
            subprocess.run([git, '-C', str(source), *command], check=True, env=env)
        print('Verified and applied patch to disposable source at ' + PIN, flush=True)
        # Never start a server, shell, external program or network client from the tests.
        script = ('import sys,runpy\n'
                  'def guard(event, args):\n'
                  ' if event in ("socket.connect", "socket.bind", "subprocess.Popen", "os.system", "os.posix_spawn"):\n'
                  '  raise RuntimeError("Unexpected test I/O: " + event)\n'
                  'sys.addaudithook(guard)\n'
                  'path=sys.argv.pop(); sys.path.insert(0, "."); runpy.run_path(path, run_name="__main__")')
        subprocess.run([py, '-IB', '-c', script, str(HERE / 'test_confirmed_text_v1.py')],
                       cwd=source, env=env, check=True, timeout=120)


if __name__ == '__main__':
    run()
