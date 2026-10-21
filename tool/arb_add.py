"""Adds strings to lib/l10n/arb/app_en.arb and app_hi.arb, then regenerates
AppLocalizations. Safe to run from several shells at once (it takes a lock:
flock on POSIX, a lock directory on Windows).

Usage: python3 tool/arb_add.py strings.json

strings.json maps a key to [english, hindi] or to
{"en": ..., "hi": ..., "placeholders": {"name": {"type": "String"}}}.
A key that already exists keeps its text (a different text is reported).
"""
import json
import os
import subprocess
import sys
import time
from contextlib import contextmanager
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ARB = ROOT / 'lib' / 'l10n' / 'arb'


LOCK = ROOT / '.dart_tool' / 'arb_add.lock'


@contextmanager
def locked():
    """One writer at a time. POSIX uses flock, which the system releases when
    the process dies for any reason. Windows has no fcntl, so it takes a lock
    directory (mkdir is atomic)."""
    LOCK.parent.mkdir(parents=True, exist_ok=True)
    try:
        import fcntl
    except ImportError:
        fcntl = None
    if fcntl is not None:
        with open(LOCK.with_suffix('.flock'), 'w') as handle:
            fcntl.flock(handle, fcntl.LOCK_EX)
            yield
        return
    deadline = time.time() + 120
    while True:
        try:
            os.mkdir(LOCK)
            break
        except FileExistsError:
            if time.time() > deadline:
                raise SystemExit(f'lock {LOCK} is held; remove it if stale')
            time.sleep(0.2)
    try:
        yield
    finally:
        os.rmdir(LOCK)


def main(path):
    new = json.loads(Path(path).read_text(encoding='utf-8'))
    with locked():
        files = {lang: ARB / f'app_{lang}.arb' for lang in ('en', 'hi')}
        data = {
            lang: json.loads(f.read_text(encoding='utf-8'))
            for lang, f in files.items()
        }
        for key, value in new.items():
            if isinstance(value, list):
                value = {'en': value[0], 'hi': value[1]}
            if key in data['en']:
                if data['en'][key] != value['en']:
                    print(f'kept existing {key!r}: {data["en"][key]!r}')
                continue
            for lang in ('en', 'hi'):
                data[lang][key] = value[lang]
            if 'placeholders' in value:
                data['en'][f'@{key}'] = {'placeholders': value['placeholders']}
        for lang, f in files.items():
            f.write_text(
                json.dumps(data[lang], ensure_ascii=False, indent=2) + '\n',
                encoding='utf-8',
            )
        subprocess.run(['flutter', 'gen-l10n'], cwd=ROOT, check=True,
                       stdout=subprocess.DEVNULL)


if __name__ == '__main__':
    main(sys.argv[1])
